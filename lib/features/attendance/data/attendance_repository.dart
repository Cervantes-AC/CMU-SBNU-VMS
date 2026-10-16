import 'models/attendance_record.dart';

abstract interface class AttendanceRepository {
  List<PreviewAttendanceRecord> rosterFor(String activityId);
  void setStatus(
    String activityId,
    String participantName,
    AttendanceStatus status,
  );
}

/// Fictional, memory-only roster for UI design work.
class PreviewAttendanceRepository implements AttendanceRepository {
  static const _names = [
    'Mika Alvarez',
    'Jon Reyes',
    'Cathy Lim',
    'Aira Santos',
    'Daniel Navarro',
  ];

  final Map<String, Map<String, AttendanceStatus>> _statuses = {
    'sample-preparedness': {
      'Mika Alvarez': AttendanceStatus.present,
      'Cathy Lim': AttendanceStatus.present,
    },
  };

  @override
  List<PreviewAttendanceRecord> rosterFor(String activityId) => [
    for (final name in _names)
      PreviewAttendanceRecord(
        displayName: name,
        status: _statuses[activityId]?[name] ?? AttendanceStatus.absent,
      ),
  ];

  @override
  void setStatus(
    String activityId,
    String participantName,
    AttendanceStatus status,
  ) {
    _statuses.putIfAbsent(activityId, () => {})[participantName] = status;
  }
}
