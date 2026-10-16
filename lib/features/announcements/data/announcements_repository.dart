import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/announcement.dart';

/// Repository contract for announcements.
abstract class AnnouncementsRepository {
  Stream<List<Announcement>> get announcements;
  Stream<List<Announcement>> getPublishedAnnouncements(String audience);
  Future<AppResult<Announcement>> createAnnouncement(Announcement announcement);
  Future<AppResult<Announcement>> updateAnnouncement(Announcement announcement);
  Future<AppResult<void>> archiveAnnouncement(String id);
  Future<AppResult<void>> deleteAnnouncement(String id);
}

/// Preview implementation for development.
class PreviewAnnouncementsRepository implements AnnouncementsRepository {
  PreviewAnnouncementsRepository();

  final List<Announcement> _announcements = [
    Announcement(
      id: 'ann_001',
      title: 'Welcome to SBNu Volunteer Network',
      body:
          'Welcome to the volunteer management system. Explore activities and log your service hours.',
      audienceRule: 'all',
      status: AnnouncementStatus.published,
      authorUid: 'staff_001',
      publishAt: DateTime(2026, 10, 1, 9, 0),
      priority: 'normal',
    ),
    Announcement(
      id: 'ann_002',
      title: 'Tree Planting This Saturday',
      body:
          'Join us for community tree planting at the Botanical Garden. Sign up now!',
      audienceRule: 'all',
      status: AnnouncementStatus.published,
      authorUid: 'staff_002',
      publishAt: DateTime(2026, 11, 3, 8, 0),
      priority: 'high',
    ),
  ];

  @override
  Stream<List<Announcement>> get announcements => Stream.value(_announcements);

  @override
  Stream<List<Announcement>> getPublishedAnnouncements(String audience) =>
      Stream.value(
        _announcements
            .where(
              (a) =>
                  a.isPublished &&
                  (a.audienceRule == 'all' || a.audienceRule == audience),
            )
            .toList(),
      );

  @override
  Future<AppResult<Announcement>> createAnnouncement(
    Announcement announcement,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _announcements.add(announcement);
    return AppResult.data(announcement);
  }

  @override
  Future<AppResult<Announcement>> updateAnnouncement(
    Announcement announcement,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _announcements.indexWhere((a) => a.id == announcement.id);
    if (idx >= 0) {
      _announcements[idx] = announcement;
      return AppResult.data(announcement);
    }
    return AppResult.error(
      const NotFoundFailure(message: 'Announcement not found.'),
    );
  }

  @override
  Future<AppResult<void>> archiveAnnouncement(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _announcements.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      _announcements[idx] = _announcements[idx].copyWith(
        status: AnnouncementStatus.archived,
      );
      return const AppResult.data(null);
    }
    return AppResult.error(
      const NotFoundFailure(message: 'Announcement not found.'),
    );
  }

  @override
  Future<AppResult<void>> deleteAnnouncement(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _announcements.removeWhere((a) => a.id == id);
    return const AppResult.data(null);
  }
}

/// Firestore-backed implementation.
class FirestoreAnnouncementsRepository implements AnnouncementsRepository {
  FirestoreAnnouncementsRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _anns =>
      _firestore.collection('announcements');

  @override
  Stream<List<Announcement>> get announcements => _anns.snapshots().map(
    (s) => s.docs.map((d) => Announcement.fromFirestore(d)).toList(),
  );

  @override
  Stream<List<Announcement>> getPublishedAnnouncements(String audience) => _anns
      .where('status', isEqualTo: 'published')
      .snapshots()
      .map(
        (s) => s.docs
            .map((d) => Announcement.fromFirestore(d))
            .where((a) => a.audienceRule == 'all' || a.audienceRule == audience)
            .toList(),
      );

  @override
  Future<AppResult<Announcement>> createAnnouncement(
    Announcement announcement,
  ) async {
    try {
      await _anns.doc(announcement.id).set(announcement.toFirestore());
      _logger.info(
        'announcement.create',
        fields: {'announcementId': announcement.id},
      );
      return AppResult.data(announcement);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('announcement.create_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<Announcement>> updateAnnouncement(
    Announcement announcement,
  ) async {
    try {
      await _anns.doc(announcement.id).update(announcement.toFirestore());
      return AppResult.data(announcement);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('announcement.update_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> archiveAnnouncement(String id) async {
    try {
      await _anns.doc(id).update({
        'status': 'archived',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('announcement.archive_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> deleteAnnouncement(String id) async {
    try {
      await _anns.doc(id).delete();
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('announcement.delete_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

AnnouncementsRepository createAnnouncementsRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreAnnouncementsRepository(
      firestore: firestore,
      logger: logger,
    );
  }
  return PreviewAnnouncementsRepository();
}

AnnouncementsRepository announcementsRepositoryOf(BuildContext context) {
  return Provider.of<AnnouncementsRepository>(context, listen: false);
}
