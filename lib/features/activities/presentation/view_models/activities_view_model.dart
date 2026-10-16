import 'package:flutter/foundation.dart';

import '../../data/activities_repository.dart';
import '../../data/models/activity.dart';

class ActivitiesViewModel extends ChangeNotifier {
  ActivitiesViewModel(this._repository);

  final ActivitiesRepository _repository;
  ActivityCategory? _categoryFilter;

  List<Activity> get activities => _repository.activities;
  ActivityCategory? get categoryFilter => _categoryFilter;

  List<Activity> get visibleActivities {
    final all = activities;
    if (_categoryFilter == null) return all;
    return all
        .where((activity) => activity.category == _categoryFilter)
        .toList();
  }

  void setCategoryFilter(ActivityCategory? category) {
    if (_categoryFilter == category) return;
    _categoryFilter = category;
    notifyListeners();
  }

  void createDraft({
    required String title,
    required ActivityCategory category,
    required String venue,
  }) {
    final id = 'local-${DateTime.now().microsecondsSinceEpoch}';
    _repository.saveDraft(
      Activity(
        id: id,
        title: title.trim(),
        category: category,
        scheduleLabel: 'Schedule to be set',
        venue: venue.trim(),
        joinedCount: 0,
        capacity: 20,
        status: ActivityStatus.draft,
      ),
    );
    notifyListeners();
  }

  void toggleJoinRequest(String activityId) {
    _repository.toggleJoinRequest(activityId);
    notifyListeners();
  }
}
