import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/qr_duty_repository.dart';
import '../models/qr_duty.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for QR duty sessions and scans.
///
/// Token handling:
/// - Tokens are generated as cryptographically random strings (256-bit).
/// - Only the SHA-256 digest is stored in Firestore.
/// - Raw token is returned ONLY at creation time (never persisted).
/// - Validation: hash incoming token, compare digests, check replay, time windows, capacity.
class QRDutyRepositoryImpl implements QRDutyRepository {
  QRDutyRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _sessionsCollection() =>
      _firestore.instance.collection(FirestorePaths.qrDutySessions);

  CollectionReference<Map<String, dynamic>> _scansCollection() =>
      _firestore.instance.collection(FirestorePaths.qrDutyScans);

  static String _hashToken(String token) => sha256.convert(utf8.encode(token)).toString();

  static String _generateToken() {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String _scanId(String sessionId, String uid, QRDutyAction action) {
    // Deterministic ID for replay detection: sessionId\0uid\0action
    return '$sessionId\u0000$uid\u0000${action.wire}';
  }

  @override
  Stream<({List<QRDutySession> items, String? nextCursor})> watchEventSessions({
    required String eventId,
    int limit = 20,
  }) {
    if (!FirestorePaths.isValidDocId(eventId)) {
      return Stream.value((items: <QRDutySession>[], nextCursor: null));
    }
    var query = _sessionsCollection()
        .where('eventId', isEqualTo: eventId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) {
      final sessions = <QRDutySession>[];
      for (final doc in snapshot.docs) {
        try {
          sessions.add(QRDutySession.fromFirestore(doc));
        } on FormatException {
          Logger.warn('qr_duty_session.parse', code: 'FORMAT',
              fields: {'sessionId': doc.id, 'exists': doc.exists});
        }
      }
      return (items: sessions, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<QRDutySession> items, String? nextCursor})>> getEventSessions({
    required String eventId,
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(NotFoundException(resource: 'Event QR sessions'));
      }
      var query = _sessionsCollection()
          .where('eventId', isEqualTo: eventId)
          .orderBy('createdAt', descending: true)
          .limit(limit + 1);

      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final sessions = <QRDutySession>[];
      for (final doc in snapshot.docs) {
        try {
          sessions.add(QRDutySession.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = sessions.length > limit;
      final items = hasMore ? sessions.sublist(0, limit) : sessions;
      final nextCursor = hasMore
          ? items.last.createdAt.millisecondsSinceEpoch.toString()
          : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<QRDutySession>> getSession(String sessionId) async {
    try {
      if (!FirestorePaths.isValidDocId(sessionId)) {
        return Failure(NotFoundException(resource: 'QR Duty session'));
      }
      final doc = await _sessionsCollection().doc(sessionId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'QR Duty session'));
      }
      final session = QRDutySession.fromFirestore(doc);
      return Success(session);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Stream<QRDutySession?> watchSession(String sessionId) {
    if (!FirestorePaths.isValidDocId(sessionId)) {
      return Stream.value(null);
    }
    return _sessionsCollection().doc(sessionId).snapshots().map((doc) {
      if (!doc.exists) return null;
      try {
        return QRDutySession.fromFirestore(doc);
      } on FormatException {
        Logger.warn('qr_duty_session.parse', code: 'FORMAT',
            fields: {'sessionId': sessionId, 'exists': doc.exists});
        return null;
      }
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({QRDutySession session, String rawToken})>> createSession({
    required String eventId,
    required DateTime startsAt,
    required DateTime expiresAt,
    int maxScansPerMember = 1,
    List<QRDutyAction> allowedActions = const [QRDutyAction.checkIn],
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(PermissionDeniedException());
      }
      if (expiresAt.isBefore(startsAt) || expiresAt.isAtSameMomentAs(startsAt)) {
        return Failure(ValidationException(
            message: 'Expires at must be after starts at.',
            fieldErrors: {'expiresAt': 'Expires at must be after starts at.'}));
      }
      if (maxScansPerMember < 1) {
        return Failure(ValidationException(
            message: 'Max scans per member must be at least 1.',
            fieldErrors: {'maxScansPerMember': 'Must be at least 1.'}));
      }
      if (allowedActions.isEmpty) {
        return Failure(ValidationException(
            message: 'At least one allowed action is required.',
            fieldErrors: {'allowedActions': 'Must not be empty.'}));
      }

      // Verify event exists.
      final eventDoc = await _firestore.instance
          .collection(FirestorePaths.events)
          .doc(eventId)
          .get();
      if (!eventDoc.exists) {
        return Failure(NotFoundException(resource: 'Event'));
      }

      final rawToken = _generateToken();
      final tokenDigest = _hashToken(rawToken);
      final now = DateTime.now().toUtc();

      final data = {
        'eventId': eventId,
        'createdBy': uid,
        'startsAt': Timestamp.fromDate(startsAt.toUtc()),
        'expiresAt': Timestamp.fromDate(expiresAt.toUtc()),
        'status': QRDutySessionStatus.active.wire,
        'tokenDigest': tokenDigest,
        'maxScansPerMember': maxScansPerMember,
        'allowedActions': allowedActions.map((a) => a.wire).toList(),
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'revision': 0,
        'schemaVersion': 1,
      };

      final docRef = await _sessionsCollection().add(data);
      final createdDoc = await docRef.get();
      final session = QRDutySession.fromFirestore(createdDoc);

      // Return session AND raw token (only time token is exposed).
      return Success((session: session, rawToken: rawToken));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<void>> cancelSession(String sessionId, {required int expectedRevision}) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(sessionId)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _sessionsCollection().doc(sessionId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'QR Duty session'));
      }
      final current = QRDutySession.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Session was modified by another process. Refresh and try again.'));
      }

      await _sessionsCollection().doc(sessionId).update({
        'status': QRDutySessionStatus.cancelled.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });
      return const Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<QRDutyScan>> validateScan({
    required String sessionId,
    required String rawToken,
    required QRDutyAction action,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(sessionId)) {
        return Failure(PermissionDeniedException());
      }

      // 1. Read session and validate read-only criteria.
      final sessionDoc = await _sessionsCollection().doc(sessionId).get();
      if (!sessionDoc.exists) {
        return Failure(NotFoundException(resource: 'QR Duty session'));
      }
      final session = QRDutySession.fromFirestore(sessionDoc);

      // 1. Check session status and time window.
      if (session.status != QRDutySessionStatus.active) {
        return Failure(NotFoundException(resource: 'QR Duty session'));
      }
      final now = DateTime.now().toUtc();
      if (now.isBefore(session.startsAt.toUtc()) || now.isAfter(session.expiresAt.toUtc())) {
        return Failure(UnavailableException(
          message: 'This QR duty session has expired or has not started yet.',
        ));
      }

      // 2. Check allowed actions.
      if (!session.allowedActions.contains(action)) {
        return Failure(PermissionDeniedException(
          message: 'This action is not allowed for this session.',
        ));
      }

      // 3. Verify token digest.
      final tokenDigest = _hashToken(rawToken);
      if (tokenDigest != session.tokenDigest) {
        return Failure(ValidationException(
          message: 'Invalid QR code token.',
          fieldErrors: {'token': 'Invalid QR code token.'},
        ));
      }

      // 4. Check max scans per member for this session (outside transaction to avoid Query in transaction).
      final memberScansSnapshot = await _scansCollection()
          .where('sessionId', isEqualTo: sessionId)
          .where('uid', isEqualTo: uid)
          .where('action', isEqualTo: action.wire)
          .get();
      if (memberScansSnapshot.docs.length >= session.maxScansPerMember) {
        return Failure(ConflictException(
          message: 'Maximum scans per member exceeded for this session.',
        ));
      }

      // 4. Use a transaction for the atomic check-and-write of the scan (duplicate check + write).
      final scan = await _firestore.instance.runTransaction((txn) async {
        // Check for duplicate scan (replay protection).
        final scanId = _scanId(sessionId, uid, action);
        final scanDocRef = _scansCollection().doc(scanId);
        final existingScan = await txn.get(scanDocRef);
        if (existingScan.exists) {
          throw ConflictException(
            message: 'This QR code has already been scanned for this action.',
          );
        }

        // Record the successful scan.
        final serverTime = DateTime.now().toUtc();
        final scan = QRDutyScan(
          scanId: scanId,
          sessionId: sessionId,
          eventId: session.eventId,
          uid: uid,
          action: action,
          serverTime: serverTime,
          result: QRDutyScanResult.success,
        );

        txn.set(_scansCollection().doc(scanId), {
          'sessionId': sessionId,
          'eventId': session.eventId,
          'uid': uid,
          'action': action.wire,
          'serverTime': Timestamp.fromDate(serverTime),
          'result': QRDutyScanResult.success.wire,
          'revision': 0,
          'schemaVersion': 1,
        });

        return scan;
      });

      return Success(scan);
    } on ConflictException catch (e) {
      return Failure(e);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Stream<({List<QRDutyScan> items, String? nextCursor})> watchSessionScans({
    required String sessionId,
    int limit = 50,
  }) {
    if (!FirestorePaths.isValidDocId(sessionId)) {
      return Stream.value((items: <QRDutyScan>[], nextCursor: null));
    }
    var query = _scansCollection()
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('serverTime', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) {
      final scans = <QRDutyScan>[];
      for (final doc in snapshot.docs) {
        try {
          scans.add(QRDutyScan.fromFirestore(doc));
        } on FormatException {
          Logger.warn('qr_duty_scan.parse', code: 'FORMAT',
              fields: {'scanId': doc.id, 'exists': doc.exists});
        }
      }
      return (items: scans, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<QRDutyScan> items, String? nextCursor})>> getSessionScans({
    required String sessionId,
    int limit = 50,
    String? startAfter,
  }) async {
    try {
      if (!FirestorePaths.isValidDocId(sessionId)) {
        return Failure(NotFoundException(resource: 'QR Duty session scans'));
      }
      var query = _scansCollection()
          .where('sessionId', isEqualTo: sessionId)
          .orderBy('serverTime', descending: true)
          .limit(limit + 1);

      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final scans = <QRDutyScan>[];
      for (final doc in snapshot.docs) {
        try {
          scans.add(QRDutyScan.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = scans.length > limit;
      final items = hasMore ? scans.sublist(0, limit) : scans;
      final nextCursor = hasMore
          ? items.last.serverTime.millisecondsSinceEpoch.toString()
          : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}