import 'models/audit_event_preview.dart';

abstract interface class AuditPreviewRepository {
  List<AuditEventPreview> get events;
}

class SampleAuditPreviewRepository implements AuditPreviewRepository {
  static const _events = [
    AuditEventPreview(
      action: 'attendance.correction.recorded',
      recordType: 'Attendance record',
      targetLabel: 'Fictional activity roster',
      actorLabel: 'Synthetic coordinator role',
      outcome: 'Illustrative success state',
      timestampLabel: 'Sample timestamp omitted',
      changedFieldsSummary: 'attendanceStatus: absent → present',
    ),
    AuditEventPreview(
      action: 'incident.status.changed',
      recordType: 'Incident record',
      targetLabel: 'Fictional incident',
      actorLabel: 'Synthetic reviewer role',
      outcome: 'Illustrative success state',
      timestampLabel: 'Sample timestamp omitted',
      changedFieldsSummary: 'status: underReview → actionInProgress',
    ),
    AuditEventPreview(
      action: 'hotline.verification.reviewed',
      recordType: 'Hotline entry',
      targetLabel: 'Fictional hotline entry',
      actorLabel: 'Synthetic verifier role',
      outcome: 'Illustrative pending state',
      timestampLabel: 'Sample timestamp omitted',
      changedFieldsSummary: 'verificationState: pendingVerification',
    ),
  ];

  @override
  List<AuditEventPreview> get events => _events;
}
