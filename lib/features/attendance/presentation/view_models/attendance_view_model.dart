import 'package:flutter/foundation.dart';

import '../../data/attendance_repository.dart';
import '../../data/models/attendance_record.dart';

class AttendanceViewModel extends ChangeNotifier {
  AttendanceViewModel(this._repository);

  final AttendanceRepository _repository;
  String _activityId = 'sample-preparedness';

  String get activityId => _activityId;
  List<PreviewAttendanceRecord> get roster =>
      _repository.rosterFor(_activityId);
  int get presentCount => roster
      .where((record) => record.status == AttendanceStatus.present)
      .length;

  void selectActivity(String activityId) {
    if (_activityId == activityId) return;
    _activityId = activityId;
    notifyListeners();
  }

  void setStatus(String participantName, AttendanceStatus status) {
    _repository.setStatus(_activityId, participantName, status);
    notifyListeners();
  }
}
