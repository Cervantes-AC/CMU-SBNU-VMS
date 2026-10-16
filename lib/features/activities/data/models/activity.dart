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
    String? title,
    ActivityCategory? category,
    String? scheduleLabel,
    String? venue,
    int? joinedCount,
    int? capacity,
    String? description,
    ActivityStatus? status,
    bool? joinRequested,
  }) => Activity(
    id: id,
    title: title ?? this.title,
    category: category ?? this.category,
    scheduleLabel: scheduleLabel ?? this.scheduleLabel,
    venue: venue ?? this.venue,
    joinedCount: joinedCount ?? this.joinedCount,
    capacity: capacity ?? this.capacity,
    description: description ?? this.description,
    status: status ?? this.status,
    joinRequested: joinRequested ?? this.joinRequested,
  );
}
