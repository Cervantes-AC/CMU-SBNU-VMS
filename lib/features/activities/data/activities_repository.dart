import 'models/activity.dart';

abstract interface class ActivitiesRepository {
  List<Activity> get activities;
  void saveDraft(Activity activity);
  void updateDraft(Activity activity);
  void discardDraft(String activityId);
  void toggleJoinRequest(String activityId);
}

/// Session-only sample source. Replace with a reviewed data source after the
/// product scope, authorization model, and Firebase environment are approved.
class PreviewActivitiesRepository implements ActivitiesRepository {
  final List<Activity> _activities = [
    const Activity(
      id: 'sample-preparedness',
      title: 'Campus preparedness workshop',
      category: ActivityCategory.safety,
      description:
          'Practice campus readiness through a guided preparedness workshop and response drill.',
      scheduleLabel: 'Oct 22 · 9:00 AM',
      venue: 'University Convention Center',
      joinedCount: 24,
      capacity: 40,
    ),
    const Activity(
      id: 'sample-river-cleanup',
      title: 'Community river clean-up',
      category: ActivityCategory.environment,
      description:
          'Join a community clean-up focused on waste reduction and river stewardship.',
      scheduleLabel: 'Oct 26 · 6:30 AM',
      venue: 'Sawaga River access point',
      joinedCount: 18,
      capacity: 30,
    ),
    const Activity(
      id: 'sample-first-aid',
      title: 'First aid skills session',
      category: ActivityCategory.training,
      description:
          'Review basic first aid skills in a supervised training session.',
      scheduleLabel: 'Nov 02 · 1:00 PM',
      venue: 'College of Nursing',
      joinedCount: 12,
      capacity: 24,
    ),
    const Activity(
      id: 'sample-learning-day',
      title: 'Community learning day',
      category: ActivityCategory.community,
      description:
          'Support a community learning activity with volunteers and local partners.',
      scheduleLabel: 'Nov 08 · 8:00 AM',
      venue: 'CMU Main Campus',
      joinedCount: 31,
      capacity: 50,
    ),
  ];

  @override
  List<Activity> get activities => List.unmodifiable(_activities);

  @override
  void saveDraft(Activity activity) => _activities.insert(0, activity);

  @override
  void updateDraft(Activity activity) {
    final index = _activities.indexWhere((item) => item.id == activity.id);
    if (index < 0 || _activities[index].status != ActivityStatus.draft) return;
    _activities[index] = activity;
  }

  @override
  void discardDraft(String activityId) {
    _activities.removeWhere(
      (item) => item.id == activityId && item.status == ActivityStatus.draft,
    );
  }

  @override
  void toggleJoinRequest(String activityId) {
    final index = _activities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (index < 0) return;
    final activity = _activities[index];
    _activities[index] = activity.copyWith(
      joinRequested: !activity.joinRequested,
    );
  }
}
