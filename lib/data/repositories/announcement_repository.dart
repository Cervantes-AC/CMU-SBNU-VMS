import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/announcement_repository.dart';
import '../models/announcement.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for announcements.
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _announcementsCollection() =>
      _firestore.instance.collection(FirestorePaths.announcements);

  @override
  Stream<({List<Announcement> items, String? nextCursor})> watchAnnouncements({
    int limit = 20,
  }) {
    final now = DateTime.now().toUtc();
    final nowMillis = Timestamp.fromDate(now).millisecondsSinceEpoch;

    var query = _announcementsCollection()
        .where('status', isEqualTo: AnnouncementStatus.published.wire)
        .where('publishAt', isLessThanOrEqualTo: nowMillis)
        .where('expiresAt', isGreaterThan: nowMillis)
        .orderBy('publishAt', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) {
      final announcements = <Announcement>[];
      for (final doc in snapshot.docs) {
        try {
          announcements.add(Announcement.fromFirestore(doc));
        } on FormatException {
          Logger.warn('announcement.parse', code: 'FORMAT',
              fields: {'id': doc.id, 'exists': doc.exists});
        }
      }
      return (items: announcements, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<Announcement> items, String? nextCursor})>> getAnnouncements({
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final nowMillis = Timestamp.fromDate(now).millisecondsSinceEpoch;

      var query = _announcementsCollection()
          .where('status', isEqualTo: AnnouncementStatus.published.wire)
          .where('publishAt', isLessThanOrEqualTo: nowMillis)
          .where('expiresAt', isGreaterThan: nowMillis)
          .orderBy('publishAt', descending: true)
          .limit(limit + 1);

      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final announcements = <Announcement>[];
      for (final doc in snapshot.docs) {
        try {
          announcements.add(Announcement.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = announcements.length > limit;
      final items = hasMore ? announcements.sublist(0, limit) : announcements;
      final nextCursor = hasMore
          ? items.last.publishAt.millisecondsSinceEpoch.toString()
          : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Announcement>> getAnnouncement(String id) async {
    try {
      if (!FirestorePaths.isValidDocId(id)) {
        return Failure(NotFoundException(resource: 'Announcement'));
      }
      final doc = await _announcementsCollection().doc(id).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Announcement'));
      }
      final announcement = Announcement.fromFirestore(doc);
      return Success(announcement);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Stream<Announcement?> watchAnnouncement(String id) {
    if (!FirestorePaths.isValidDocId(id)) {
      return Stream.value(null);
    }
    return _announcementsCollection().doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      try {
        return Announcement.fromFirestore(doc);
      } on FormatException {
        Logger.warn('announcement.parse', code: 'FORMAT',
            fields: {'id': id, 'exists': doc.exists});
        return null;
      }
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<Announcement>> createAnnouncement(AnnouncementDraft draft) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (draft.expiresAt.isBefore(draft.publishAt) || draft.expiresAt.isAtSameMomentAs(draft.publishAt)) {
        return Failure(ValidationException(
            message: 'Expires at must be after publish at.',
            fieldErrors: {'expiresAt': 'Expires at must be after publish at.'}));
      }

      final now = DateTime.now().toUtc();
      final data = {
        'title': draft.title,
        'body': draft.body,
        'priority': draft.priority.wire,
        'audience': draft.audience.wire,
        'publishAt': Timestamp.fromDate(draft.publishAt.toUtc()),
        'expiresAt': Timestamp.fromDate(draft.expiresAt.toUtc()),
        'status': AnnouncementStatus.draft.wire,
        'imageUrl': draft.imageUrl,
        'createdBy': _currentUid,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'revision': 0,
        'schemaVersion': 1,
      };

      final docRef = await _announcementsCollection().add(data);
      final createdDoc = await docRef.get();
      final announcement = Announcement.fromFirestore(createdDoc);
      return Success(announcement);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Announcement>> updateAnnouncement({
    required String id,
    required AnnouncementDraft draft,
    required int expectedRevision,
  }) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(id)) {
        return Failure(PermissionDeniedException());
      }
      if (draft.expiresAt.isBefore(draft.publishAt) || draft.expiresAt.isAtSameMomentAs(draft.publishAt)) {
        return Failure(ValidationException(
            message: 'Expires at must be after publish at.',
            fieldErrors: {'expiresAt': 'Expires at must be after publish at.'}));
      }

      final doc = await _announcementsCollection().doc(id).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Announcement'));
      }
      final current = Announcement.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Announcement was modified by another process. Refresh and try again.'));
      }

      await _announcementsCollection().doc(id).update({
        'title': draft.title,
        'body': draft.body,
        'priority': draft.priority.wire,
        'audience': draft.audience.wire,
        'publishAt': Timestamp.fromDate(draft.publishAt.toUtc()),
        'expiresAt': Timestamp.fromDate(draft.expiresAt.toUtc()),
        'imageUrl': draft.imageUrl,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _announcementsCollection().doc(id).get();
      final announcement = Announcement.fromFirestore(freshDoc);
      return Success(announcement);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Announcement>> publishAnnouncement(String id, {required int expectedRevision}) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(id)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _announcementsCollection().doc(id).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Announcement'));
      }
      final current = Announcement.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Announcement was modified by another process. Refresh and try again.'));
      }
      if (current.status == AnnouncementStatus.published) {
        return Failure(ValidationException(
            message: 'Announcement is already published.',
            fieldErrors: {'status': 'Already published.'}));
      }

      await _announcementsCollection().doc(id).update({
        'status': AnnouncementStatus.published.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _announcementsCollection().doc(id).get();
      final announcement = Announcement.fromFirestore(freshDoc);
      return Success(announcement);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Announcement>> unpublishAnnouncement(String id, {required int expectedRevision}) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(id)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _announcementsCollection().doc(id).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Announcement'));
      }
      final current = Announcement.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Announcement was modified by another process. Refresh and try again.'));
      }
      if (current.status != AnnouncementStatus.published) {
        return Failure(ValidationException(
            message: 'Announcement is not published.',
            fieldErrors: {'status': 'Not published.'}));
      }

      await _announcementsCollection().doc(id).update({
        'status': AnnouncementStatus.expired.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _announcementsCollection().doc(id).get();
      final announcement = Announcement.fromFirestore(freshDoc);
      return Success(announcement);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}