import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityStatus { draft, published, ongoing, completed, cancelled }

enum ActivityCategory { service, training, emergency, outreach, other }

class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.startAt,
    required this.endAt,
    required this.venue,
    required this.organizationId,
    required this.ownerUid,
    required this.capacity,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final ActivityStatus status;
  final ActivityCategory category;
  final DateTime startAt;
  final DateTime endAt;
  final String venue;
  final String organizationId;
  final String ownerUid;
  final int capacity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get statusLabel => switch (status) {
        ActivityStatus.draft => 'Draft',
        ActivityStatus.published => 'Published',
        ActivityStatus.ongoing => 'Ongoing',
        ActivityStatus.completed => 'Completed',
        ActivityStatus.cancelled => 'Cancelled',
      };

  String get scheduleLabel {
    final start = '${startAt.month}/${startAt.day} ${_formatTime(startAt)}';
    final end = _formatTime(endAt);
    return '$start - $end';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${h.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  bool get isPublished => status == ActivityStatus.published;
  bool get isOngoing => status == ActivityStatus.ongoing;
  bool get isCompleted => status == ActivityStatus.completed;

  int get participantCount => 0; // Populated by repository/query

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      status: _parseStatus(data['status']),
      category: _parseCategory(data['category']),
      startAt: _parseTimestamp(data['startAt']) ?? DateTime.now(),
      endAt: _parseTimestamp(data['endAt']) ?? DateTime.now(),
      venue: data['venue'] as String? ?? '',
      organizationId: data['organizationId'] as String? ?? '',
      ownerUid: data['ownerUid'] as String? ?? '',
      capacity: data['capacity'] as int? ?? 0,
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status.name,
      'category': category.name,
      'startAt': startAt,
      'endAt': endAt,
      'venue': venue,
      'organizationId': organizationId,
      'ownerUid': ownerUid,
      'capacity': capacity,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    ActivityStatus? status,
    ActivityCategory? category,
    DateTime? startAt,
    DateTime? endAt,
    String? venue,
    String? organizationId,
    String? ownerUid,
    int? capacity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      venue: venue ?? this.venue,
      organizationId: organizationId ?? this.organizationId,
      ownerUid: ownerUid ?? this.ownerUid,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static ActivityStatus _parseStatus(dynamic value) {
    if (value is String) {
      return ActivityStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ActivityStatus.draft,
      );
    }
    return ActivityStatus.draft;
  }

  static ActivityCategory _parseCategory(dynamic value) {
    if (value is String) {
      return ActivityCategory.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ActivityCategory.other,
      );
    }
    return ActivityCategory.other;
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

class Participation {
  const Participation({
    required this.activityId,
    required this.uid,
    required this.state,
    required this.requestedAt,
    this.decisionBy,
    this.decisionAt,
  });

  final String activityId;
  final String uid;
  final String state; // requested, approved, denied, withdrawn, cancelled
  final DateTime requestedAt;
  final String? decisionBy;
  final DateTime? decisionAt;

  bool get isApproved => state == 'approved';
  bool get isPending => state == 'requested';
  bool get isWithdrawn => state == 'withdrawn';

  factory Participation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Participation(
      activityId: data['activityId'] as String? ?? doc.id,
      uid: data['uid'] as String? ?? '',
      state: data['state'] as String? ?? 'requested',
      requestedAt: _parseTimestamp(data['requestedAt']) ?? DateTime.now(),
      decisionBy: data['decisionBy'] as String?,
      decisionAt: _parseTimestamp(data['decisionAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'activityId': activityId,
      'uid': uid,
      'state': state,
      'requestedAt': requestedAt,
      if (decisionBy != null) 'decisionBy': decisionBy,
      if (decisionAt != null) 'decisionAt': decisionAt,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
