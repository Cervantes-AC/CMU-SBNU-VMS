import 'package:cloud_firestore/cloud_firestore.dart';

enum IncidentStatus { submitted, underReview, actionInProgress, resolved, reopened, closed, rejected, duplicate }

enum IncidentSeverity { low, medium, high, critical }

class Incident {
  const Incident({
    required this.id,
    required this.reporterUid,
    required this.organizationId,
    required this.category,
    required this.narrative,
    required this.severity,
    required this.status,
    required this.occurredAt,
    required this.reportedAt,
    this.locationShared = false,
    this.latitude,
    this.longitude,
    this.locationLabel,
    this.assignedUid,
    this.version = 1,
    this.duplicateOf,
    this.retentionExpiresAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String reporterUid;
  final String organizationId;
  final String category;
  final String narrative;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final DateTime occurredAt;
  final DateTime reportedAt;
  final bool locationShared;
  final double? latitude;
  final double? longitude;
  final String? locationLabel;
  final String? assignedUid;
  final int version;
  final String? duplicateOf;
  final DateTime? retentionExpiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get statusLabel => switch (status) {
        IncidentStatus.submitted => 'Submitted',
        IncidentStatus.underReview => 'Under Review',
        IncidentStatus.actionInProgress => 'Action in Progress',
        IncidentStatus.resolved => 'Resolved',
        IncidentStatus.reopened => 'Reopened',
        IncidentStatus.closed => 'Closed',
        IncidentStatus.rejected => 'Rejected',
        IncidentStatus.duplicate => 'Duplicate',
      };

  String get severityLabel => switch (severity) {
        IncidentSeverity.low => 'Low',
        IncidentSeverity.medium => 'Medium',
        IncidentSeverity.high => 'High',
        IncidentSeverity.critical => 'Critical',
      };

  factory Incident.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Incident(
      id: doc.id,
      reporterUid: data['reporterUid'] as String? ?? '',
      organizationId: data['organizationId'] as String? ?? '',
      category: data['category'] as String? ?? '',
      narrative: data['narrative'] as String? ?? '',
      severity: _parseSeverity(data['severity']),
      status: _parseStatus(data['status']),
      occurredAt: _parseTimestamp(data['occurredAt']) ?? DateTime.now(),
      reportedAt: _parseTimestamp(data['reportedAt']) ?? DateTime.now(),
      locationShared: data['locationShared'] as bool? ?? false,
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      locationLabel: data['locationLabel'] as String?,
      assignedUid: data['assignedUid'] as String?,
      version: data['version'] as int? ?? 1,
      duplicateOf: data['duplicateOf'] as String?,
      retentionExpiresAt: _parseTimestamp(data['retentionExpiresAt']),
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reporterUid': reporterUid,
      'organizationId': organizationId,
      'category': category,
      'narrative': narrative,
      'severity': severity.name,
      'status': status.name,
      'occurredAt': occurredAt,
      'reportedAt': reportedAt,
      'locationShared': locationShared,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationLabel != null) 'locationLabel': locationLabel,
      if (assignedUid != null) 'assignedUid': assignedUid,
      'version': version,
      if (duplicateOf != null) 'duplicateOf': duplicateOf,
      if (retentionExpiresAt != null) 'retentionExpiresAt': retentionExpiresAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static IncidentSeverity _parseSeverity(dynamic value) {
    if (value is String) {
      return IncidentSeverity.values.firstWhere(
        (e) => e.name == value,
        orElse: () => IncidentSeverity.low,
      );
    }
    return IncidentSeverity.low;
  }

  static IncidentStatus _parseStatus(dynamic value) {
    if (value is String) {
      return IncidentStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => IncidentStatus.submitted,
      );
    }
    return IncidentStatus.submitted;
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

class IncidentHistoryEvent {
  const IncidentHistoryEvent({
    required this.id,
    required this.incidentId,
    required this.fromStatus,
    required this.toStatus,
    required this.actorUid,
    required this.eventAt,
    this.note,
    this.actionType,
  });

  final String id;
  final String incidentId;
  final String? fromStatus;
  final String? toStatus;
  final String actorUid;
  final DateTime eventAt;
  final String? note;
  final String? actionType;

  factory IncidentHistoryEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IncidentHistoryEvent(
      id: doc.id,
      incidentId: data['incidentId'] as String? ?? '',
      fromStatus: data['fromStatus'] as String?,
      toStatus: data['toStatus'] as String?,
      actorUid: data['actorUid'] as String? ?? '',
      eventAt: _parseTimestamp(data['eventAt']) ?? DateTime.now(),
      note: data['note'] as String?,
      actionType: data['actionType'] as String?,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
