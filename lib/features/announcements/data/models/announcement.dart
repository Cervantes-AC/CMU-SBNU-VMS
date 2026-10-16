enum AnnouncementKind { general, activity, reminder, draft }

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.dateLabel,
    required this.kind,
    this.isDraft = false,
    this.isArchived = false,
  });

  final String id;
  final String title;
  final String message;
  final String audience;
  final String dateLabel;
  final AnnouncementKind kind;
  final bool isDraft;
  final bool isArchived;

  Announcement copyWith({
    String? title,
    String? message,
    String? audience,
    String? dateLabel,
    bool? isArchived,
  }) => Announcement(
    id: id,
    title: title ?? this.title,
    message: message ?? this.message,
    audience: audience ?? this.audience,
    dateLabel: dateLabel ?? this.dateLabel,
    kind: kind,
    isDraft: isDraft,
    isArchived: isArchived ?? this.isArchived,
  );
}
