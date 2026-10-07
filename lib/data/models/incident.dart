import 'package:cloud_firestore/cloud_firestore.dart';

/// Incident category.
enum IncidentCategory {
  safety('safety'),
  medical('medical'),
  behavioral('behavioral'),
  facility('facility'),
  other('other');

  const IncidentCategory(this.wire);
  final String wire;

  static IncidentCategory? tryParse(String? raw) {
    if (raw == null) return null;
    for (final c in IncidentCategory.values) {
      if (c.wire == raw) return c;
    }
    return null;
  }
}

/// Incident severity.
enum IncidentSeverity {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const IncidentSeverity(this.wire);
  final String wire;

  static IncidentSeverity? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in IncidentSeverity.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// Incident status.
enum IncidentStatus {
  open('open'),
  acknowledged('acknowledged'),
  inProgress('in_progress'),
  resolved('resolved'),
  closed('closed');

  const IncidentStatus(this.wire);
  final String wire;

  static IncidentStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in IncidentStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// Incident model.
class Incident {
  const Incident({
    required this.incidentId,
    required this.reporterUid,
    required this.category,
    required this.severity,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.assignedTo,
    this.resolution,
    this.revision = 0,
    this.schemaVersion = 1,
  });

  final String incidentId;
  final String reporterUid;
  final IncidentCategory category;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final String description;
  final String? location;
  final String? assignedTo;
  final String? resolution;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int revision;
  final int schemaVersion;

  factory Incident.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Incident(
      incidentId: doc.id,
      reporterUid: data['reporterUid'] as String,
      category: IncidentCategory.tryParse(data['category'] as String?) ?? IncidentCategory.other,
      severity: IncidentSeverity.tryParse(data['severity'] as String?) ?? IncidentSeverity.medium,
      status: IncidentStatus.tryParse(data['status'] as String?) ?? IncidentStatus.open,
      description: data['description'] as String,
      location: data['location'] as String?,
      assignedTo: data['assignedTo'] as String?,
      resolution: data['resolution'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate().toUtc(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate().toUtc(),
      revision: data['revision'] as int? ?? 0,
      schemaVersion: data['schemaVersion'] as int? ?? 1,
    );
  }

  bool get isOpen => status == IncidentStatus.open || status == IncidentStatus.acknowledged || status == IncidentStatus.inProgress;
}