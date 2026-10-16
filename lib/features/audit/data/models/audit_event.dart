import 'package:cloud_firestore/cloud_firestore.dart';

class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.actorUid,
    required this.action,
    required this.recordType,
    required this.recordId,
    required this.occurredAt,
    required this.outcome,
    this.changedFields,
  });

  final String id;
  final String actorUid;
  final String action;
  final String recordType;
  final String recordId;
  final DateTime occurredAt;
  final String outcome; // success, failure, denied
  final Map<String, dynamic>? changedFields;

  factory AuditEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AuditEvent(
      id: doc.id,
      actorUid: data['actorUid'] as String? ?? '',
      action: data['action'] as String? ?? '',
      recordType: data['recordType'] as String? ?? '',
      recordId: data['recordId'] as String? ?? '',
      occurredAt: _parseTimestamp(data['occurredAt']) ?? DateTime.now(),
      outcome: data['outcome'] as String? ?? 'success',
      changedFields: data['changedFields'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'actorUid': actorUid,
      'action': action,
      'recordType': recordType,
      'recordId': recordId,
      'occurredAt': occurredAt,
      'outcome': outcome,
      if (changedFields != null) 'changedFields': changedFields,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
