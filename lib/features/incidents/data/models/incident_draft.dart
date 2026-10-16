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

  IncidentDraft copyWith({
    String? category,
    String? description,
    DateTime? occurredAt,
  }) => IncidentDraft(
    id: id,
    category: category ?? this.category,
    description: description ?? this.description,
    occurredAt: occurredAt ?? this.occurredAt,
  );
}
