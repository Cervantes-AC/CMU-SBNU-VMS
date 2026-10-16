import 'package:cloud_firestore/cloud_firestore.dart';

enum AnnouncementStatus { draft, published, archived }

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.audienceRule,
    required this.status,
    required this.authorUid,
    required this.publishAt,
    this.expiresAt,
    this.priority = 'normal',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String body;
  final String audienceRule;
  final AnnouncementStatus status;
  final String authorUid;
  final DateTime publishAt;
  final DateTime? expiresAt;
  final String priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get statusLabel => switch (status) {
        AnnouncementStatus.draft => 'Draft',
        AnnouncementStatus.published => 'Published',
        AnnouncementStatus.archived => 'Archived',
      };

  bool get isPublished => status == AnnouncementStatus.published;
  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      audienceRule: data['audienceRule'] as String? ?? 'all',
      status: _parseStatus(data['status']),
      authorUid: data['authorUid'] as String? ?? '',
      publishAt: _parseTimestamp(data['publishAt']) ?? DateTime.now(),
      expiresAt: _parseTimestamp(data['expiresAt']),
      priority: data['priority'] as String? ?? 'normal',
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'audienceRule': audienceRule,
      'status': status.name,
      'authorUid': authorUid,
      'publishAt': publishAt,
      if (expiresAt != null) 'expiresAt': expiresAt,
      'priority': priority,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static AnnouncementStatus _parseStatus(dynamic value) {
    if (value is String) {
      return AnnouncementStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AnnouncementStatus.draft,
      );
    }
    return AnnouncementStatus.draft;
  }

  Announcement copyWith({
    String? id,
    String? title,
    String? body,
    String? audienceRule,
    AnnouncementStatus? status,
    String? authorUid,
    DateTime? publishAt,
    DateTime? expiresAt,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      audienceRule: audienceRule ?? this.audienceRule,
      status: status ?? this.status,
      authorUid: authorUid ?? this.authorUid,
      publishAt: publishAt ?? this.publishAt,
      expiresAt: expiresAt ?? this.expiresAt,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
