import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/event_repository.dart';
import '../models/event.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for events and join requests.
class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _eventsCollection() =>
      _firestore.instance.collection(FirestorePaths.events);

  CollectionReference<Map<String, dynamic>> _joinRequestsCollection() =>
      _firestore.instance.collection(FirestorePaths.eventJoinRequests);

  @override
  Stream<({List<Event> items, String? nextCursor})> watchEvents({
    String? audienceFilter,
    int limit = 20,
  }) {
    var query = _eventsCollection()
        .where('status', isEqualTo: EventStatus.published.wire)
        .orderBy('start')
        .limit(limit);

    if (audienceFilter != null) {
      query = query.where('audience', isEqualTo: audienceFilter);
    }

    return query.snapshots().map((snapshot) {
      final events = <Event>[];
      for (final doc in snapshot.docs) {
        try {
          events.add(Event.fromFirestore(doc));
        } on FormatException {
          Logger.warn('event.parse', code: 'FORMAT',
              fields: {'eventId': doc.id, 'exists': doc.exists});
        }
      }
      return (items: events, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<Event> items, String? nextCursor})>> getEvents({
    String? audienceFilter,
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      var query = _eventsCollection()
          .where('status', isEqualTo: EventStatus.published.wire)
          .orderBy('start')
          .limit(limit + 1);

      if (audienceFilter != null) {
        query = query.where('audience', isEqualTo: audienceFilter);
      }
      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final events = <Event>[];
      for (final doc in snapshot.docs) {
        try {
          events.add(Event.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = events.length > limit;
      final items = hasMore ? events.sublist(0, limit) : events;
      final nextCursor = hasMore
          ? (items.last.start.toUtc().millisecondsSinceEpoch.toString())
          : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<Event>> getEvent(String eventId) async {
    try {
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(NotFoundException(resource: 'Event'));
      }
      final doc = await _eventsCollection().doc(eventId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Event'));
      }
      final event = Event.fromFirestore(doc);
      return Success(event);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Stream<Event?> watchEvent(String eventId) {
    if (!FirestorePaths.isValidDocId(eventId)) {
      return Stream.value(null);
    }
    return _eventsCollection().doc(eventId).snapshots().map((doc) {
      if (!doc.exists) return null;
      try {
        return Event.fromFirestore(doc);
      } on FormatException {
        Logger.warn('event.parse', code: 'FORMAT',
            fields: {'eventId': eventId, 'exists': doc.exists});
        return null;
      }
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<Event>> createEvent(EventDraft draft) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (draft.end.isBefore(draft.start) || draft.end.isAtSameMomentAs(draft.start)) {
        return Failure(ValidationException(
            message: 'Event end must be after start.',
            fieldErrors: {'end': 'End must be after start.'}));
      }

      final now = DateTime.now().toUtc();
      final data = {
        'title': draft.title,
        'venue': draft.venue,
        'description': draft.description,
        'start': Timestamp.fromDate(draft.start.toUtc()),
        'end': Timestamp.fromDate(draft.end.toUtc()),
        'capacity': draft.capacity,
        'audience': draft.audience.wire,
        'imageUrl': draft.imageUrl,
        'isFeatured': draft.isFeatured,
        'status': EventStatus.draft.wire,
        'createdBy': _currentUid,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'revision': 0,
        'schemaVersion': 1,
        'attendeesCount': 0,
        'waitlistCount': 0,
      };

      final docRef = await _eventsCollection().add(data);
      final createdDoc = await docRef.get();
      final event = Event.fromFirestore(createdDoc);
      return Success(event);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<Event>> updateEvent({
    required String eventId,
    required EventDraft draft,
    required int expectedRevision,
  }) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(PermissionDeniedException());
      }
      if (draft.end.isBefore(draft.start) || draft.end.isAtSameMomentAs(draft.start)) {
        return Failure(ValidationException(
            message: 'Event end must be after start.',
            fieldErrors: {'end': 'End must be after start.'}));
      }

      final doc = await _eventsCollection().doc(eventId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Event'));
      }
      final current = Event.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Event was modified by another process. Refresh and try again.'));
      }

      await _eventsCollection().doc(eventId).update({
        'title': draft.title,
        'venue': draft.venue,
        'description': draft.description,
        'start': Timestamp.fromDate(draft.start.toUtc()),
        'end': Timestamp.fromDate(draft.end.toUtc()),
        'capacity': draft.capacity,
        'audience': draft.audience.wire,
        'imageUrl': draft.imageUrl,
        'isFeatured': draft.isFeatured,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _eventsCollection().doc(eventId).get();
      final event = Event.fromFirestore(freshDoc);
      return Success(event);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<void>> cancelEvent(String eventId, {required int expectedRevision}) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _eventsCollection().doc(eventId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Event'));
      }
      final current = Event.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Event was modified by another process. Refresh and try again.'));
      }

      await _eventsCollection().doc(eventId).update({
        'status': EventStatus.canceled.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });
      return const Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<void>> requestJoin(String eventId) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Failure(PermissionDeniedException());
      }

      // Check event exists and is joinable.
      final eventDoc = await _eventsCollection().doc(eventId).get();
      if (!eventDoc.exists) {
        return Failure(NotFoundException(resource: 'Event'));
      }
      final event = Event.fromFirestore(eventDoc);
      if (event.status != EventStatus.published && event.status != EventStatus.open) {
        return Failure(ValidationException(
            message: 'This event is not open for registration.',
            fieldErrors: {'event': 'Event not open for registration.'}));
      }

      // Create join request with deterministic ID.
      final uid = _currentUid; // non-null because we returned early above
      final requestId = _joinRequestId(eventId, uid);
      final requestDoc = _joinRequestsCollection().doc(requestId);

      // Check if request already exists.
      final existing = await requestDoc.get();
      if (existing.exists) {
        return Failure(ConflictException(
            message: 'You have already requested to join this event.'));
      }

      await requestDoc.set({
        'eventId': eventId,
        'uid': _currentUid,
        'status': JoinRequestStatus.pending.wire,
        'createdAt': FirestoreService.serverTimestamp(),
        'revision': 0,
      });

      return Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<void>> reviewJoinRequest({
    required String eventId,
    required String requesterUid,
    required JoinRequestDecision decision,
  }) async {
    try {
      if (_currentUid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(eventId) ||
          !FirestorePaths.isValidDocId(requesterUid)) {
        return Failure(PermissionDeniedException());
      }

      final requestId = _joinRequestId(eventId, requesterUid);
      final requestDoc = _joinRequestsCollection().doc(requestId);
      final existing = await requestDoc.get();
      if (!existing.exists) {
        return Failure(NotFoundException(resource: 'Join request'));
      }

      await requestDoc.update({
        'status': decision.wire,
        'reviewedBy': _currentUid,
        'reviewedAt': FirestoreService.serverTimestamp(),
        'revision': FieldValue.increment(1),
      });

      // If approved, increment attendeesCount on event (transaction would be better).
      if (decision == JoinRequestDecision.approved) {
        await _eventsCollection().doc(eventId).update({
          'attendeesCount': FieldValue.increment(1),
        });
      }
      return Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<JoinRequestStatus?>> getJoinRequestStatus(String eventId) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Success(null);
      }
      if (!FirestorePaths.isValidDocId(eventId)) {
        return Success(null);
      }

      final requestId = _joinRequestId(eventId, uid);
      final requestDoc = await _joinRequestsCollection().doc(requestId).get();
      if (!requestDoc.exists) {
        return Success(null);
      }
      final status = JoinRequestStatus.tryParse(requestDoc.data()?['status']);
      return Success(status);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  String _joinRequestId(String eventId, String uid) {
    // Deterministic ID: composite string (Firestore allows up to 1500 chars).
    return '$eventId\u0000$uid';
  }
}