import '../../shared/result.dart';
import '../models/announcement.dart';

/// Announcement repository contract.
///
/// Queries are typed and paginated; no unbounded collection downloads.
/// Only authorized roles may create/update/publish announcements.
abstract interface class AnnouncementRepository {
  /// Emits a paged list of visible announcements for the current user.
  /// Filtered by audience and publish/expire dates.
  Stream<({List<Announcement> items, String? nextCursor})> watchAnnouncements({
    int limit = 20,
  });

  /// One-shot fetch of visible announcements.
  Future<Result<({List<Announcement> items, String? nextCursor})>> getAnnouncements({
    int limit = 20,
    String? startAfter,
  });

  /// Fetches a single announcement by ID.
  Future<Result<Announcement>> getAnnouncement(String id);

  /// Emits a single announcement by ID (for detail screens).
  Stream<Announcement?> watchAnnouncement(String id);

  /// Creates a new announcement (officer/admin only).
  Future<Result<Announcement>> createAnnouncement(AnnouncementDraft draft);

  /// Updates an existing announcement (officer/admin only).
  Future<Result<Announcement>> updateAnnouncement({
    required String id,
    required AnnouncementDraft draft,
    required int expectedRevision,
  });

  /// Publishes a draft announcement (officer/admin only).
  Future<Result<Announcement>> publishAnnouncement(String id, {required int expectedRevision});

  /// Unpublishes/archives an announcement (officer/admin only).
  Future<Result<Announcement>> unpublishAnnouncement(String id, {required int expectedRevision});
}

/// Draft announcement data for create/update (excludes server-generated fields).
class AnnouncementDraft {
  const AnnouncementDraft({
    required this.title,
    required this.body,
    required this.priority,
    required this.audience,
    required this.publishAt,
    required this.expiresAt,
    this.imageUrl,
  });

  final String title;
  final String body;
  final AnnouncementPriority priority;
  final AnnouncementAudience audience;
  final DateTime publishAt;
  final DateTime expiresAt;
  final String? imageUrl;
}