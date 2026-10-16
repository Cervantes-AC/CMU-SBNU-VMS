import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/attendance_repository.dart';
import '../../data/models/attendance_record.dart';

class AttendanceViewModel extends ChangeNotifier {
  AttendanceViewModel({required this.repository});

  final AttendanceRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<AttendanceRecord> _records = [];
  List<AttendanceRecord> _myRecords = [];

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<AttendanceRecord> get records => _records;
  List<AttendanceRecord> get myRecords => _myRecords;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.getAllAttendance().listen(
      (records) {
        _records = records;
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

    repository.getMyAttendance('current_user').listen((records) {
      _myRecords = records;
      notifyListeners();
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> recordAttendance(AttendanceRecord record) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.recordAttendance(record);
    if (result.success) {
      _records.add(record);
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> correctAttendance(
    String activityId,
    String uid, {
    required String newStatus,
    required String reason,
    required String correctedBy,
  }) async {
    _status = LoadStatus.loading;
    notifyListeners();

    final result = await repository.correctAttendance(
      activityId,
      uid,
      newStatus: newStatus,
      reason: reason,
      correctedBy: correctedBy,
    );
    if (result.success) {
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }
}

AttendanceViewModel createAttendanceViewModel(AttendanceRepository repository) {
  return AttendanceViewModel(repository: repository);
}

AttendanceViewModel attendanceViewModelOf(BuildContext context) {
  return Provider.of<AttendanceViewModel>(context, listen: false);
}
