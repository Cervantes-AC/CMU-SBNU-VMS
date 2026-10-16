import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/activity.dart';

/// Repository contract for activities.
abstract class ActivitiesRepository {
  Stream<List<Activity>> get activities;
  Stream<List<Activity>> get publishedActivities;
  Stream<Activity?> getActivityById(String id);
  Future<AppResult<Activity>> createActivity(Activity activity);
  Future<AppResult<Activity>> updateActivity(Activity activity);
  Future<AppResult<void>> deleteActivity(String id);
  Future<AppResult<void>> participate(String activityId, String uid);
  Future<AppResult<void>> withdrawParticipation(String activityId, String uid);
  Stream<List<Participation>> getParticipationForActivity(String activityId);
  Stream<List<Activity>> getMyActivities(String uid);
}

/// Preview (local-only) implementation for development.
class PreviewActivitiesRepository implements ActivitiesRepository {
  PreviewActivitiesRepository();

  final List<Activity> _activities = [
    Activity(
      id: 'act_001',
      title: 'Community Tree Planting',
      description: 'Help plant native trees around campus to support reforestation.',
      status: ActivityStatus.published,
      category: ActivityCategory.service,
      startAt: DateTime(2026, 11, 5, 8, 0),
      endAt: DateTime(2026, 11, 5, 12, 0),
      venue: 'CMU Botanical Garden',
      organizationId: 'org_001',
      ownerUid: 'staff_001',
      capacity: 50,
    ),
    Activity(
      id: 'act_002',
      title: 'Disaster Preparedness Training',
      description: 'Learn basic emergency response and first aid skills.',
      status: ActivityStatus.published,
      category: ActivityCategory.training,
      startAt: DateTime(2026, 11, 12, 9, 0),
      endAt: DateTime(2026, 11, 12, 16, 0),
      venue: 'SBNU Training Hall',
      organizationId: 'org_001',
      ownerUid: 'staff_002',
      capacity: 30,
    ),
    Activity(
      id: 'act_003',
      title: 'Food Drive for Barangay Partners',
      description: 'Collect and distribute relief goods to partner communities.',
      status: ActivityStatus.published,
      category: ActivityCategory.outreach,
      startAt: DateTime(2026, 11, 20, 8, 0),
      endAt: DateTime(2026, 11, 20, 17, 0),
      venue: 'University Covered Court',
      organizationId: 'org_002',
      ownerUid: 'staff_003',
      capacity: 40,
    ),
  ];

  @override
  Stream<List<Activity>> get activities => Stream.value(_activities);

  @override
  Stream<List<Activity>> get publishedActivities =>
      Stream.value(_activities.where((a) => a.isPublished).toList());

  @override
  Stream<Activity?> getActivityById(String id) =>
      Stream.value(_activities.firstWhere((a) => a.id == id, orElse: () => _activities.first));

  @override
  Future<AppResult<Activity>> createActivity(Activity activity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _activities.add(activity);
    return AppResult.data(activity);
  }

  @override
  Future<AppResult<Activity>> updateActivity(Activity activity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _activities.indexWhere((a) => a.id == activity.id);
    if (idx >= 0) {
      _activities[idx] = activity;
      return AppResult.data(activity);
    }
    return AppResult.error(const NotFoundFailure(message: 'Activity not found.'));
  }

  @override
  Future<AppResult<void>> deleteActivity(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _activities.removeWhere((a) => a.id == id);
    return const AppResult.data(null);
  }

  @override
  Future<AppResult<void>> participate(String activityId, String uid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AppResult.data(null);
  }

  @override
  Future<AppResult<void>> withdrawParticipation(String activityId, String uid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AppResult.data(null);
  }

  @override
  Stream<List<Participation>> getParticipationForActivity(String activityId) =>
      Stream.value([]);

  @override
  Stream<List<Activity>> getMyActivities(String uid) => Stream.value([]);
}

/// Firestore-backed implementation (used when Firebase is configured).
class FirestoreActivitiesRepository implements ActivitiesRepository {
  FirestoreActivitiesRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _activities =>
      _firestore.collection('activities');

  @override
  Stream<List<Activity>> get activities =>
      _activities.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList());

  @override
  Stream<List<Activity>> get publishedActivities =>
      _activities.where('status', isEqualTo: 'published').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList(),
      );

  @override
  Stream<Activity?> getActivityById(String id) =>
      _activities.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        return Activity.fromFirestore(doc);
      });

  @override
  Future<AppResult<Activity>> createActivity(Activity activity) async {
    try {
      await _activities.doc(activity.id).set(activity.toFirestore());
      _logger.info('activity.create', fields: {'activityId': activity.id});
      return AppResult.data(activity);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('activity.create_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<Activity>> updateActivity(Activity activity) async {
    try {
      await _activities.doc(activity.id).update(activity.toFirestore());
      return AppResult.data(activity);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('activity.update_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> deleteActivity(String id) async {
    try {
      await _activities.doc(id).delete();
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('activity.delete_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> participate(String activityId, String uid) async {
    try {
      await _activities.doc(activityId).collection('participation').doc(uid).set({
        'activityId': activityId,
        'uid': uid,
        'state': 'requested',
        'requestedAt': FieldValue.serverTimestamp(),
      });
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('activity.participate_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> withdrawParticipation(String activityId, String uid) async {
    try {
      await _activities.doc(activityId).collection('participation').doc(uid).delete();
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('activity.withdraw_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Stream<List<Participation>> getParticipationForActivity(String activityId) =>
      _activities.doc(activityId).collection('participation').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Participation.fromFirestore(doc)).toList(),
      );

  @override
  Stream<List<Activity>> getMyActivities(String uid) =>
      _activities.where('ownerUid', isEqualTo: uid).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList(),
      );
}

ActivitiesRepository createActivitiesRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreActivitiesRepository(firestore: firestore, logger: logger);
  }
  return PreviewActivitiesRepository();
}

ActivitiesRepository activitiesRepositoryOf(BuildContext context) {
  return Provider.of<ActivitiesRepository>(context, listen: false);
}
