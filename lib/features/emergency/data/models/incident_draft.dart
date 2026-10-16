class IncidentDraft {
  const IncidentDraft({
    required this.id,
    required this.category,
    required this.description,
    required this.occurredAt,
  });

  final String id;
  final String category;
  final String description;
  final DateTime occurredAt;
}
