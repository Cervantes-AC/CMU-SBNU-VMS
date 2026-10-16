enum IncidentPreviewSeverity { low, medium, high }

enum IncidentPreviewStatus { underReview, actionInProgress, resolved }

class IncidentPreviewRecord {
  const IncidentPreviewRecord({
    required this.id,
    required this.category,
    required this.severity,
    required this.status,
  });

  final String id;
  final String category;
  final IncidentPreviewSeverity severity;
  final IncidentPreviewStatus status;
}
