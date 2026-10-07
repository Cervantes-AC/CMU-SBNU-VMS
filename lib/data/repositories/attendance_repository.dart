import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/attendance_repository.dart';
import '../models/attendance.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for attendance records.
class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _attendanceCollection() =>
      _firestore.instance.collection(FirestorePaths.attendance);

  @override
  Stream<({List<Attendance> items, String? nextCursor})> watchEventAttendance({
    required String eventId,
    int limit = 50,
  }) {
    if (!FirestorePaths.isValidDocId(eventId)) {
      return Stream.value((items: <Attendance>[], nextCursor: null));
    }
    var query = _attendanceCollection()
        .where('eventId', isEqualTo: eventId)
        .orderBy('recordedAt', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) {
      final records = <Attendance>[];
      for (final doc in snapshot.docs) {
        try {
          records.add(Attendance.fromFirestore(doc));
        } on FormatException {
          Logger.warn('attendance.parse', code: 'FORMAT',
              fields: {'attendanceId': doc.id, 'exists': doc.exists});
        }
      }
      return (items: records, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<Attendance> items, String? nextCursor})>> getEventAttendance({
    required String eventId,
    int limit = 50,
    String? startAfter,
  }) async {
    try {
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(NotFoundException(resource: 'Event attendance'));
      }
      var query = _attendanceCollection()
          .where('eventId', isEqualTo: eventId)
          .orderBy('recordedAt', descending: true)
          .limit(limit + 1);

      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final records = <Attendance>[];
      for (final doc in snapshot.docs) {
        try {
          records.add(Attendance.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = records.length > limit;
      final items = hasMore ? records.sublist(0, limit) : records;
      final nextCursor = hasMore
          ? items.last.recordedAt.millisecondsSinceEpoch.toString()
          : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Stream<Attendance?> watchMyAttendance(String eventId) {
    final uid = _currentUid;
    if (uid == null || !FirestorePaths.isValidDocId(eventId)) {
      return Stream.value(null);
    }
    return _attendanceCollection()
        .where('eventId', isEqualTo: eventId)
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      try {
        return Attendance.fromFirestore(snapshot.docs.first);
      } on FormatException {
        return null;
      }
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<Attendance?>> getMyAttendance(String eventId) async {
    try {
      final uid = _currentUid;
      if (uid == null || !FirestorePaths.isValidDocId(eventId)) {
        return Success(null);
      }
      final query = await _attendanceCollection()
          .where('eventId', isEqualTo: eventId)
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        return Success(null);
      }
      final record = Attendance.fromFirestore(query.docs.first);
      return Success(record);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Attendance>> recordAttendance({
    required String eventId,
    required AttendanceStatus status,
    required AttendanceSource source,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(PermissionDeniedException());
      }

      // Deterministic ID: eventId\0uid
      final attendanceId = '$eventId\u0000$uid';
      final docRef = _attendanceCollection().doc(attendanceId);

      final existing = await docRef.get();
      if (existing.exists) {
        // Idempotent: return existing record.
        final existingRecord = Attendance.fromFirestore(existing);
        return Success(existingRecord);
      }

      final now = DateTime.now().toUtc();
      final record = Attendance(
        attendanceId: attendanceId,
        eventId: eventId,
        uid: uid,
        status: status,
        source: source,
        recordedAt: now,
        recordedBy: uid,
      );

      await docRef.set({
        'eventId': eventId,
        'uid': uid,
        'status': status.wire,
        'source': source.wire,
        'recordedAt': Timestamp.fromDate(now),
        'recordedBy': uid,
        'revision': 0,
        'schemaVersion': 1,
      });

      return Success(record);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Attendance>> correctAttendance({
    required String attendanceId,
    required AttendanceStatus newStatus,
    required int expectedRevision,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(attendanceId)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _attendanceCollection().doc(attendanceId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Attendance record'));
      }
      final current = Attendance.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Attendance record was modified by another process. Refresh and try again.'));
      }

      final now = DateTime.now().toUtc();
      await _attendanceCollection().doc(attendanceId).update({
        'status': newStatus.wire,
        'source': AttendanceSource.correction.wire,
        'correctedAt': Timestamp.fromDate(now),
        'correctedBy': uid,
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _attendanceCollection().doc(attendanceId).get();
      final corrected = Attendance.fromFirestore(freshDoc);
      return Success(corrected);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<AttendanceSummary>> getAttendanceSummary(String eventId) async {
    try {
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(NotFoundException(resource: 'Event attendance'));
      }
      final snapshot = await _attendanceCollection()
          .where('eventId', isEqualTo: eventId)
          .get();

      var total = 0;
      var present = 0;
      var late = 0;
      var absent = 0;
      var excused = 0;

      for (final doc in snapshot.docs) {
        try {
          final record = Attendance.fromFirestore(doc);
          total++;
          switch (record.status) {
            case AttendanceStatus.present:
              present++;
              break;
            case AttendanceStatus.late:
              late++;
              break;
            case AttendanceStatus.absent:
              absent++;
              break;
            case AttendanceStatus.excused:
              excused++;
              break;
          }
        } on FormatException {
          // Skip malformed.
        }
      }

      return Success(AttendanceSummary(
        total: total,
        present: present,
        late: late,
        absent: absent,
        excused: excused,
      ));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}