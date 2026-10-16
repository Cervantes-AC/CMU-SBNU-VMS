import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/incident.dart';

/// Repository contract for incidents.
abstract class IncidentsRepository {
  Stream<List<Incident>> get incidents;
  Stream<List<Incident>> getMyIncidents(String uid);
  Stream<Incident?> getIncidentById(String id);
  Stream<List<IncidentHistoryEvent>> getHistory(String incidentId);
  Future<AppResult<Incident>> submitIncident(Incident incident);
  Future<AppResult<Incident>> updateIncidentStatus(
    String id, {
    required IncidentStatus newStatus,
    required String actorUid,
    String? note,
    String? actionType,
  });
  Future<AppResult<void>> assignIncident(
    String id,
    String assignedUid,
    String actorUid,
  );
}

/// Preview implementation for development.
class PreviewIncidentsRepository implements IncidentsRepository {
  PreviewIncidentsRepository();

  final List<Incident> _incidents = [
    Incident(
      id: 'inc_001',
      reporterUid: 'vol_001',
      organizationId: 'org_001',
      category: 'Safety',
      narrative: 'Slippery floor near the cafeteria entrance.',
      severity: IncidentSeverity.medium,
      status: IncidentStatus.submitted,
      occurredAt: DateTime(2026, 10, 15, 12, 0),
      reportedAt: DateTime(2026, 10, 15, 12, 30),
      locationShared: false,
    ),
    Incident(
      id: 'inc_002',
      reporterUid: 'vol_002',
      organizationId: 'org_002',
      category: 'Facility',
      narrative: 'Broken lighting in the north wing corridor.',
      severity: IncidentSeverity.low,
      status: IncidentStatus.underReview,
      occurredAt: DateTime(2026, 10, 14, 18, 0),
      reportedAt: DateTime(2026, 10, 14, 18, 45),
      locationShared: true,
      latitude: 14.6667,
      longitude: 121.05,
      locationLabel: 'North Wing',
    ),
  ];

  @override
  Stream<List<Incident>> get incidents => Stream.value(_incidents);

  @override
  Stream<List<Incident>> getMyIncidents(String uid) =>
      Stream.value(_incidents.where((i) => i.reporterUid == uid).toList());

  @override
  Stream<Incident?> getIncidentById(String id) => Stream.value(
    _incidents.firstWhere((i) => i.id == id, orElse: () => _incidents.first),
  );

  @override
  Stream<List<IncidentHistoryEvent>> getHistory(String incidentId) =>
      Stream.value([]);

  @override
  Future<AppResult<Incident>> submitIncident(Incident incident) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _incidents.add(incident);
    return AppResult.data(incident);
  }

  @override
  Future<AppResult<Incident>> updateIncidentStatus(
    String id, {
    required IncidentStatus newStatus,
    required String actorUid,
    String? note,
    String? actionType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _incidents.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      final old = _incidents[idx];
      _incidents[idx] = Incident(
        id: old.id,
        reporterUid: old.reporterUid,
        organizationId: old.organizationId,
        category: old.category,
        narrative: old.narrative,
        severity: old.severity,
        status: newStatus,
        occurredAt: old.occurredAt,
        reportedAt: old.reportedAt,
        locationShared: old.locationShared,
        latitude: old.latitude,
        longitude: old.longitude,
        locationLabel: old.locationLabel,
        assignedUid: old.assignedUid,
        version: old.version + 1,
        duplicateOf: old.duplicateOf,
        retentionExpiresAt: old.retentionExpiresAt,
      );
      return AppResult.data(_incidents[idx]);
    }
    return AppResult.error(
      const NotFoundFailure(message: 'Incident not found.'),
    );
  }

  @override
  Future<AppResult<void>> assignIncident(
    String id,
    String assignedUid,
    String actorUid,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AppResult.data(null);
  }
}

/// Firestore-backed implementation.
class FirestoreIncidentsRepository implements IncidentsRepository {
  FirestoreIncidentsRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _incidents =>
      _firestore.collection('incidents');

  @override
  Stream<List<Incident>> get incidents => _incidents.snapshots().map(
    (s) => s.docs.map((d) => Incident.fromFirestore(d)).toList(),
  );

  @override
  Stream<List<Incident>> getMyIncidents(String uid) => _incidents
      .where('reporterUid', isEqualTo: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => Incident.fromFirestore(d)).toList());

  @override
  Stream<Incident?> getIncidentById(String id) =>
      _incidents.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        return Incident.fromFirestore(doc);
      });

  @override
  Stream<List<IncidentHistoryEvent>> getHistory(String incidentId) => _incidents
      .doc(incidentId)
      .collection('history')
      .snapshots()
      .map(
        (s) =>
            s.docs.map((d) => IncidentHistoryEvent.fromFirestore(d)).toList(),
      );

  @override
  Future<AppResult<Incident>> submitIncident(Incident incident) async {
    try {
      await _incidents.doc(incident.id).set(incident.toFirestore());
      _logger.info(
        'incident.submit',
        fields: {
          'incidentId': incident.id,
          'reporterUid': incident.reporterUid,
        },
      );
      return AppResult.data(incident);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('incident.submit_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<Incident>> updateIncidentStatus(
    String id, {
    required IncidentStatus newStatus,
    required String actorUid,
    String? note,
    String? actionType,
  }) async {
    try {
      final docRef = _incidents.doc(id);
      final doc = await docRef.get();
      if (!doc.exists) {
        return AppResult.error(
          const NotFoundFailure(message: 'Incident not found.'),
        );
      }

      final current = Incident.fromFirestore(doc);
      await docRef.update({
        'status': newStatus.name,
        'version': current.version + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Append history
      await docRef.collection('history').add({
        'incidentId': id,
        'fromStatus': current.status.name,
        'toStatus': newStatus.name,
        'actorUid': actorUid,
        'eventAt': FieldValue.serverTimestamp(),
        'note': note,
        'actionType': actionType,
      });

      final updated = Incident.fromFirestore(await docRef.get());
      return AppResult.data(updated);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('incident.status_update_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> assignIncident(
    String id,
    String assignedUid,
    String actorUid,
  ) async {
    try {
      await _incidents.doc(id).update({
        'assignedUid': assignedUid,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('incident.assign_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

IncidentsRepository createIncidentsRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreIncidentsRepository(firestore: firestore, logger: logger);
  }
  return PreviewIncidentsRepository();
}

IncidentsRepository incidentsRepositoryOf(BuildContext context) {
  return Provider.of<IncidentsRepository>(context, listen: false);
}
