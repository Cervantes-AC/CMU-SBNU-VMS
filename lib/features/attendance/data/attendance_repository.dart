import 'models/attendance_record.dart';

abstract interface class AttendanceRepository {
  List<PreviewAttendanceRecord> rosterFor(String activityId);
  List<PreviewAttendanceCorrection> correctionsFor(String activityId);
  void setStatus(
    String activityId,
    String participantName,
    AttendanceStatus status,
    String reason,
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
  final Map<String, List<PreviewAttendanceCorrection>> _corrections = {};

  @override
  List<PreviewAttendanceRecord> rosterFor(String activityId) => [
    for (final name in _names)
      PreviewAttendanceRecord(
        displayName: name,
        status: _statuses[activityId]?[name] ?? AttendanceStatus.absent,
      ),
  ];

  @override
  List<PreviewAttendanceCorrection> correctionsFor(String activityId) =>
      List.unmodifiable(_corrections[activityId] ?? const []);

  @override
  void setStatus(
    String activityId,
    String participantName,
    AttendanceStatus status,
    String reason,
  ) {
    final statuses = _statuses.putIfAbsent(activityId, () => {});
    final previous = statuses[participantName] ?? AttendanceStatus.absent;
    if (previous == status) return;
    statuses[participantName] = status;
    _corrections
        .putIfAbsent(activityId, () => [])
        .insert(
          0,
          PreviewAttendanceCorrection(
            participantName: participantName,
            previousStatus: previous,
            newStatus: status,
            reason: reason,
            actorLabel: 'Preview coordinator',
            recordedAt: DateTime.now(),
          ),
        );
  }
}
