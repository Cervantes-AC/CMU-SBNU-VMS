class AuditEventPreview {
  const AuditEventPreview({
    required this.action,
    required this.recordType,
    required this.targetLabel,
    required this.actorLabel,
    required this.outcome,
    required this.timestampLabel,
    required this.changedFieldsSummary,
  });

  final String action;
  final String recordType;
  final String targetLabel;
  final String actorLabel;
  final String outcome;
  final String timestampLabel;
  final String changedFieldsSummary;
}
