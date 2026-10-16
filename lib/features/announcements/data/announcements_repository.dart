import 'models/announcement.dart';

abstract interface class AnnouncementsRepository {
  List<Announcement> get announcements;
  void saveDraft(Announcement announcement);
  void updateDraft(Announcement announcement);
  void setDraftArchived(String announcementId, bool archived);
}

/// In-memory sample source. It never publishes or delivers messages.
class PreviewAnnouncementsRepository implements AnnouncementsRepository {
  final List<Announcement> _announcements = [
    const Announcement(
      id: 'sample-orientation',
      title: 'Volunteer orientation schedule',
      message:
          'Welcome session dates and preparation notes for new volunteers.',
      audience: 'Unit members',
      dateLabel: 'Sample · Oct 14',
      kind: AnnouncementKind.general,
    ),
    const Announcement(
      id: 'sample-workshop',
      title: 'Preparedness workshop registration',
      message:
          'A sample training notice for the upcoming campus preparedness workshop.',
      audience: 'Activity participants',
      dateLabel: 'Sample · Oct 12',
      kind: AnnouncementKind.activity,
    ),
    const Announcement(
      id: 'sample-reflection',
      title: 'Service reflection submissions',
      message:
          'Reminder to review your learning notes after a completed activity.',
      audience: 'All volunteers',
      dateLabel: 'Sample · Oct 08',
      kind: AnnouncementKind.reminder,
    ),
  ];

  @override
  List<Announcement> get announcements => List.unmodifiable(_announcements);

  @override
  void saveDraft(Announcement announcement) {
    if (!announcement.isDraft || announcement.isArchived) return;
    _announcements.insert(0, announcement);
  }

  @override
  void updateDraft(Announcement announcement) {
    final index = _announcements.indexWhere(
      (item) => item.id == announcement.id,
    );
    if (index < 0 || !_announcements[index].isDraft) return;
    _announcements[index] = announcement;
  }

  @override
  void setDraftArchived(String announcementId, bool archived) {
    final index = _announcements.indexWhere(
      (item) => item.id == announcementId,
    );
    if (index < 0 || !_announcements[index].isDraft) return;
    _announcements[index] = _announcements[index].copyWith(
      isArchived: archived,
    );
  }
}
