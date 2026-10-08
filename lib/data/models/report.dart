import 'package:cloud_firestore/cloud_firestore.dart';

/// Report type.
enum ReportType {
  attendanceSummary('attendance_summary'),
  eventParticipation('event_participation'),
  incidentSummary('incident_summary'),
  memberActivity('member_activity'),
  serviceHours('service_hours');

  const ReportType(this.wire);
  final String wire;

  static ReportType? tryParse(String? raw) {
    if (raw == null) return null;
    for (final t in ReportType.values) {
      if (t.wire == raw) return t;
    }
    return null;
  }
}

/// Report format.
enum ReportFormat {
  pdf('pdf'),
  csv('csv'),
  xlsx('xlsx');

  const ReportFormat(this.wire);
  final String wire;

  static ReportFormat? tryParse(String? raw) {
    if (raw == null) return null;
    for (final f in ReportFormat.values) {
      if (f.wire == raw) return f;
    }
    return null;
  }
}

/// Report request parameters.
class ReportRequest {
  const ReportRequest({
    required this.type,
    required this.format,
    required this.dateFrom,
    required this.dateTo,
    this.eventIds,
    this.memberIds,
    this.officerIds,
  });

  final ReportType type;
  final ReportFormat format;
  final DateTime dateFrom;
  final DateTime dateTo;
  final List<String>? eventIds;
  final List<String>? memberIds;
  final List<String>? officerIds;
}

/// Report result.
class ReportResult {
  const ReportResult({
    required this.type,
    required this.format,
    required this.generatedAt,
    required this.recordCount,
    this.downloadUrl,
    this.expiresAt,
    this.requestedBy,
    this.status = 'completed',
  });

  final ReportType type;
  final ReportFormat format;
  final DateTime generatedAt;
  final int recordCount;
  final String? downloadUrl;
  final DateTime? expiresAt;
  final String? requestedBy;
  final String status;

  factory ReportResult.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ReportResult(
      type: ReportType.tryParse(data['type'] as String?) ?? ReportType.attendanceSummary,
      format: ReportFormat.tryParse(data['format'] as String?) ?? ReportFormat.pdf,
      generatedAt: (data['generatedAt'] as Timestamp).toDate().toUtc(),
      recordCount: data['recordCount'] as int? ?? 0,
      downloadUrl: data['downloadUrl'] as String?,
      expiresAt: data['expiresAt'] != null ? (data['expiresAt'] as Timestamp).toDate().toUtc() : null,
      requestedBy: data['requestedBy'] as String?,
      status: data['status'] as String? ?? 'completed',
    );
  }
}