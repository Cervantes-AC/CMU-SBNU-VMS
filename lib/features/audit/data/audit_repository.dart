import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/audit_event.dart';

/// Repository contract for audit events.
abstract class AuditRepository {
  Stream<List<AuditEvent>> get events;
  Future<AppResult<void>> writeEvent({
    required String actorUid,
    required String action,
    required String recordType,
    required String recordId,
    required String outcome,
    Map<String, dynamic>? changedFields,
  });
}

/// Preview implementation - synthetic audit events only.
class SampleAuditPreviewRepository implements AuditRepository {
  SampleAuditPreviewRepository();

  final List<AuditEvent> _events = [
    AuditEvent(
      id: 'audit_001',
      actorUid: 'admin_001',
      action: 'role_assigned',
      recordType: 'account',
      recordId: 'vol_001',
      occurredAt: DateTime(2026, 10, 1, 9, 0),
      outcome: 'success',
      changedFields: {'role': 'volunteer'},
    ),
    AuditEvent(
      id: 'audit_002',
      actorUid: 'staff_001',
      action: 'incident_resolved',
      recordType: 'incident',
      recordId: 'inc_001',
      occurredAt: DateTime(2026, 10, 15, 14, 0),
      outcome: 'success',
    ),
  ];

  @override
  Stream<List<AuditEvent>> get events => Stream.value(_events);

  @override
  Future<AppResult<void>> writeEvent({
    required String actorUid,
    required String action,
    required String recordType,
    required String recordId,
    required String outcome,
    Map<String, dynamic>? changedFields,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _events.add(
      AuditEvent(
        id: 'audit_${DateTime.now().millisecondsSinceEpoch}',
        actorUid: actorUid,
        action: action,
        recordType: recordType,
        recordId: recordId,
        occurredAt: DateTime.now(),
        outcome: outcome,
        changedFields: changedFields,
      ),
    );
    return const AppResult.data(null);
  }
}

/// Firestore-backed implementation (restricted access).
class FirestoreAuditRepository implements AuditRepository {
  FirestoreAuditRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _events =>
      _firestore.collection('auditEvents');

  @override
  Stream<List<AuditEvent>> get events => _events
      .orderBy('occurredAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => AuditEvent.fromFirestore(d)).toList());

  @override
  Future<AppResult<void>> writeEvent({
    required String actorUid,
    required String action,
    required String recordType,
    required String recordId,
    required String outcome,
    Map<String, dynamic>? changedFields,
  }) async {
    try {
      await _events.add({
        'actorUid': actorUid,
        'action': action,
        'recordType': recordType,
        'recordId': recordId,
        'occurredAt': FieldValue.serverTimestamp(),
        'outcome': outcome,
        'changedFields': ?changedFields,
      });
      _logger.security(
        'audit.write',
        fields: {
          'action': action,
          'recordType': recordType,
          'outcome': outcome,
        },
      );
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('audit.write_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

AuditRepository createAuditRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreAuditRepository(firestore: firestore, logger: logger);
  }
  return SampleAuditPreviewRepository();
}

AuditRepository auditRepositoryOf(BuildContext context) {
  return Provider.of<AuditRepository>(context, listen: false);
}
