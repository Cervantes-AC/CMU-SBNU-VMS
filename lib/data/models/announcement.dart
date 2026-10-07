import 'package:cloud_firestore/cloud_firestore.dart';

/// Announcement priority.
enum AnnouncementPriority {
  low('low'),
  normal('normal'),
  high('high'),
  urgent('urgent');

  const AnnouncementPriority(this.wire);
  final String wire;

  static AnnouncementPriority? tryParse(String? raw) {
    if (raw == null) return null;
    for (final p in AnnouncementPriority.values) {
      if (p.wire == raw) return p;
    }
    return null;
  }
}

/// Announcement audience.
enum AnnouncementAudience {
  all('all'),
  members('members'),
  officers('officers'),
  admins('admins');

  const AnnouncementAudience(this.wire);
  final String wire;

  static AnnouncementAudience? tryParse(String? raw) {
    if (raw == null) return null;
    for (final a in AnnouncementAudience.values) {
      if (a.wire == raw) return a;
    }
    return null;
  }
}

/// Announcement status.
enum AnnouncementStatus {
  draft('draft'),
  published('published'),
  expired('expired');

  const AnnouncementStatus(this.wire);
  final String wire;

  static AnnouncementStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in AnnouncementStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// Announcement model.
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    required this.audience,
    required this.publishAt,
    required this.expiresAt,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.revision = 0,
    this.schemaVersion = 1,
  });

  final String id;
  final String title;
  final String body;
  final AnnouncementPriority priority;
  final AnnouncementAudience audience;
  final DateTime publishAt;
  final DateTime expiresAt;
  final AnnouncementStatus status;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int revision;
  final int schemaVersion;

  bool get isPublished => status == AnnouncementStatus.published;
  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt.toUtc());
  bool get isVisible => isPublished && !isExpired;

  factory Announcement.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Announcement(
      id: doc.id,
      title: data['title'] as String,
      body: data['body'] as String,
      priority: AnnouncementPriority.tryParse(data['priority'] as String?) ?? AnnouncementPriority.normal,
      audience: AnnouncementAudience.tryParse(data['audience'] as String?) ?? AnnouncementAudience.all,
      publishAt: (data['publishAt'] as Timestamp).toDate().toUtc(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate().toUtc(),
      status: AnnouncementStatus.tryParse(data['status'] as String?) ?? AnnouncementStatus.draft,
      imageUrl: data['imageUrl'] as String?,
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate().toUtc(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate().toUtc(),
      revision: data['revision'] as int? ?? 0,
      schemaVersion: data['schemaVersion'] as int? ?? 1,
    );
  }
}