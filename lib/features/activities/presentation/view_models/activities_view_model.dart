import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/activities_repository.dart';
import '../../data/models/activity.dart';

class ActivitiesViewModel extends ChangeNotifier {
  ActivitiesViewModel({required this.repository});

  final ActivitiesRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<Activity> _activities = [];
  List<Activity> _publishedActivities = [];
  Activity? _selectedActivity;

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<Activity> get activities => _activities;
  List<Activity> get publishedActivities => _publishedActivities;
  Activity? get selectedActivity => _selectedActivity;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.activities.listen(
      (activities) {
        _activities = activities;
        _publishedActivities = activities.where((a) => a.isPublished).toList();
        _status = LoadStatus.loaded;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _status = LoadStatus.error;
        _error = e is AppFailure ? e : UnknownFailure();
        notifyListeners();
      },
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void selectActivity(Activity activity) {
    _selectedActivity = activity;
    notifyListeners();
  }

  Future<void> createActivity(Activity activity) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.createActivity(activity);
    if (result.hasData) {
      _activities.add(result.data!);
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> updateActivity(Activity activity) async {
    _status = LoadStatus.loading;
    notifyListeners();

    final result = await repository.updateActivity(activity);
    if (result.hasData) {
      final idx = _activities.indexWhere((a) => a.id == activity.id);
      if (idx >= 0) {
        _activities[idx] = result.data!;
      }
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    _status = LoadStatus.loading;
    notifyListeners();

    final result = await repository.deleteActivity(id);
    if (result.success) {
      _activities.removeWhere((a) => a.id == id);
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> joinActivity(String activityId, String uid) async {
    final result = await repository.participate(activityId, uid);
    if (!result.success) {
      _error = result.error;
      notifyListeners();
    }
  }

  Future<void> leaveActivity(String activityId, String uid) async {
    final result = await repository.withdrawParticipation(activityId, uid);
    if (!result.success) {
      _error = result.error;
      notifyListeners();
    }
  }
}

ActivitiesViewModel createActivitiesViewModel(ActivitiesRepository repository) {
  return ActivitiesViewModel(repository: repository);
}

ActivitiesViewModel activitiesViewModelOf(BuildContext context) {
  return Provider.of<ActivitiesViewModel>(context, listen: false);
}
