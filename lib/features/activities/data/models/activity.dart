enum ActivityCategory { environment, safety, training, community }

enum ActivityStatus { draft, published }

class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.category,
    required this.scheduleLabel,
    required this.venue,
    required this.joinedCount,
    required this.capacity,
    this.description = '',
    this.status = ActivityStatus.published,
    this.joinRequested = false,
  });

  final String id;
  final String title;
  final ActivityCategory category;
  final String scheduleLabel;
  final String venue;
  final int joinedCount;
  final int capacity;
  final String description;
  final ActivityStatus status;
  final bool joinRequested;

  Activity copyWith({
    int? joinedCount,
    String? description,
    ActivityStatus? status,
    bool? joinRequested,
  }) => Activity(
    id: id,
    title: title,
    category: category,
    scheduleLabel: scheduleLabel,
    venue: venue,
    joinedCount: joinedCount ?? this.joinedCount,
    capacity: capacity,
    description: description ?? this.description,
    status: status ?? this.status,
    joinRequested: joinRequested ?? this.joinRequested,
  );
}
