import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/incident_repository.dart';
import '../models/incident.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for incidents.
class IncidentRepositoryImpl implements IncidentRepository {
  IncidentRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _incidentsCollection() =>
      _firestore.instance.collection(FirestorePaths.incidents);

  @override
  Stream<({List<Incident> items, String? nextCursor})> watchIncidents({
    String? reporterUid,
    String? assigneeUid,
    IncidentStatus? statusFilter,
    int limit = 20,
  }) {
    var query = _incidentsCollection().orderBy('createdAt', descending: true).limit(limit);

    // Apply filters based on role/access (simplified - in practice, rules handle this)
    // This is for UI filtering; actual access control is in Firestore rules.
    if (reporterUid != null) {
      query = query.where('reporterUid', isEqualTo: reporterUid);
    }
    if (assigneeUid != null) {
      query = query.where('assignedTo', isEqualTo: assigneeUid);
    }
    if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter.wire);
    }

    return query.snapshots().map((snapshot) {
      final incidents = <Incident>[];
      for (final doc in snapshot.docs) {
        try {
          incidents.add(Incident.fromFirestore(doc));
        } on FormatException {
          Logger.warn('incident.parse', code: 'FORMAT',
              fields: {'incidentId': doc.id, 'exists': doc.exists});
        }
      }
      return (items: incidents, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<Incident> items, String? nextCursor})>> getIncidents({
    String? reporterUid,
    String? assigneeUid,
    IncidentStatus? statusFilter,
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      var query = _incidentsCollection().orderBy('createdAt', descending: true).limit(limit + 1);

      if (reporterUid != null) {
        query = query.where('reporterUid', isEqualTo: reporterUid);
      }
      if (assigneeUid != null) {
        query = query.where('assignedTo', isEqualTo: assigneeUid);
      }
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.wire);
      }
      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final incidents = <Incident>[];
      for (final doc in snapshot.docs) {
        try {
          incidents.add(Incident.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = incidents.length > limit;
      final items = hasMore ? incidents.sublist(0, limit) : incidents;
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
  Future<Result<Incident>> getIncident(String incidentId) async {
    try {
      if (!FirestorePaths.isValidDocId(incidentId)) {
        return Failure(NotFoundException(resource: 'Incident'));
      }
      final doc = await _incidentsCollection().doc(incidentId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Incident'));
      }
      final incident = Incident.fromFirestore(doc);
      return Success(incident);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Stream<Incident?> watchIncident(String incidentId) {
    if (!FirestorePaths.isValidDocId(incidentId)) {
      return Stream.value(null);
    }
    return _incidentsCollection().doc(incidentId).snapshots().map((doc) {
      if (!doc.exists) return null;
      try {
        return Incident.fromFirestore(doc);
      } on FormatException {
        Logger.warn('incident.parse', code: 'FORMAT',
            fields: {'incidentId': incidentId, 'exists': doc.exists});
        return null;
      }
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<Incident>> createIncident(IncidentDraft draft) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }

      final now = DateTime.now().toUtc();
      final data = {
        'reporterUid': uid,
        'category': draft.category.wire,
        'severity': draft.severity.wire,
        'status': IncidentStatus.open.wire,
        'description': draft.description,
        'location': draft.location,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'revision': 0,
        'schemaVersion': 1,
      };

      final docRef = await _incidentsCollection().add(data);
      final createdDoc = await docRef.get();
      final incident = Incident.fromFirestore(createdDoc);
      return Success(incident);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Incident>> updateIncident({
    required String incidentId,
    required IncidentDraft draft,
    required int expectedRevision,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(incidentId)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _incidentsCollection().doc(incidentId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Incident'));
      }
      final current = Incident.fromFirestore(doc);

      // Check authorization: reporter can update their own, officers/admins can update any
      if (current.reporterUid != uid) {
        return Failure(PermissionDeniedException());
      }

      // Only allow updates for open/acknowledged incidents (not resolved/closed)
      if (!current.isOpen) {
        return Failure(ValidationException(
            message: 'Cannot update a closed incident.',
            fieldErrors: {'status': 'Incident is closed.'}));
      }

      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Incident was modified by another process. Refresh and try again.'));
      }

      await _incidentsCollection().doc(incidentId).update({
        'category': draft.category.wire,
        'severity': draft.severity.wire,
        'description': draft.description,
        'location': draft.location,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _incidentsCollection().doc(incidentId).get();
      final incident = Incident.fromFirestore(freshDoc);
      return Success(incident);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Incident>> transitionStatus({
    required String incidentId,
    required IncidentStatus newStatus,
    required int expectedRevision,
    String? resolution,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(incidentId)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _incidentsCollection().doc(incidentId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Incident'));
      }
      final current = Incident.fromFirestore(doc);

      // Authorization: officers/admins can transition status
      // (In practice, check role via UserRepository or custom claims)
      // For now, allow if user is the reporter or assignee
      if (current.reporterUid != uid && current.assignedTo != uid) {
        return Failure(PermissionDeniedException());
      }

      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Incident was modified by another process. Refresh and try again.'));
      }

      final updates = <String, dynamic>{
        'status': newStatus.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      };
      if (resolution != null) {
        updates['resolution'] = resolution;
      }
      if (newStatus == IncidentStatus.resolved || newStatus == IncidentStatus.closed) {
        updates['assignedTo'] = uid;
      }

      await _incidentsCollection().doc(incidentId).update(updates);

      final freshDoc = await _incidentsCollection().doc(incidentId).get();
      final incident = Incident.fromFirestore(freshDoc);
      return Success(incident);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<Incident>> assignIncident({
    required String incidentId,
    required String assigneeUid,
    required int expectedRevision,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(incidentId) || !FirestorePaths.isValidDocId(assigneeUid)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _incidentsCollection().doc(incidentId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Incident'));
      }
      final current = Incident.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Incident was modified by another process. Refresh and try again.'));
      }

      await _incidentsCollection().doc(incidentId).update({
        'assignedTo': assigneeUid,
        'status': IncidentStatus.acknowledged.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _incidentsCollection().doc(incidentId).get();
      final incident = Incident.fromFirestore(freshDoc);
      return Success(incident);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}