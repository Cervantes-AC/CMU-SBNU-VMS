import 'package:cloud_firestore/cloud_firestore.dart';

/// Event lifecycle status wire values.
enum EventStatus {
  draft('draft'),
  published('published'),
  open('open'),
  full('full'),
  completed('completed'),
  canceled('canceled');

  const EventStatus(this.wire);
  final String wire;

  static EventStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in EventStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// Event audience.
enum EventAudience {
  all('all'),
  members('members'),
  officers('officers'),
  admins('admins');

  const EventAudience(this.wire);
  final String wire;

  static EventAudience? tryParse(String? raw) {
    if (raw == null) return null;
    for (final a in EventAudience.values) {
      if (a.wire == raw) return a;
    }
    return null;
  }
}

/// Event model.
class Event {
  const Event({
    required this.eventId,
    required this.title,
    required this.venue,
    required this.start,
    required this.end,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.capacity,
    this.attendeesCount = 0,
    this.waitlistCount = 0,
    this.audience = EventAudience.all,
    this.imageUrl,
    this.isFeatured = false,
    this.revision = 0,
    this.schemaVersion = 1,
  });

  final String eventId;
  final String title;
  final String? description;
  final String venue;
  final DateTime start;
  final DateTime end;
  final int? capacity;
  final int attendeesCount;
  final int waitlistCount;
  final EventStatus status;
  final EventAudience audience;
  final String? imageUrl;
  final bool isFeatured;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int revision;
  final int schemaVersion;

  bool get isFull => capacity != null && attendeesCount >= capacity!;
  bool get hasEnded => DateTime.now().toUtc().isAfter(end.toUtc());
  bool get isActive => status == EventStatus.open || status == EventStatus.published;

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Event(
      eventId: doc.id,
      title: data['title'] as String,
      venue: data['venue'] as String,
      start: (data['start'] as Timestamp).toDate().toUtc(),
      end: (data['end'] as Timestamp).toDate().toUtc(),
      status: EventStatus.tryParse(data['status'] as String?) ?? EventStatus.draft,
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate().toUtc(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate().toUtc(),
      description: data['description'] as String?,
      capacity: data['capacity'] as int?,
      attendeesCount: data['attendeesCount'] as int? ?? 0,
      waitlistCount: data['waitlistCount'] as int? ?? 0,
      audience: EventAudience.tryParse(data['audience'] as String?) ?? EventAudience.all,
      imageUrl: data['imageUrl'] as String?,
      isFeatured: data['isFeatured'] as bool? ?? false,
      revision: data['revision'] as int? ?? 0,
      schemaVersion: data['schemaVersion'] as int? ?? 1,
    );
  }
}