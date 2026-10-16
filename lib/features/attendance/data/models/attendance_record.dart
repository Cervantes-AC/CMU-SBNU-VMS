enum AttendanceStatus { present, absent, excused }

class PreviewAttendanceRecord {
  const PreviewAttendanceRecord({
    required this.displayName,
    required this.status,
  });

  final String displayName;
  final AttendanceStatus status;
}

class PreviewAttendanceCorrection {
  const PreviewAttendanceCorrection({
    required this.participantName,
    required this.previousStatus,
    required this.newStatus,
    required this.reason,
    required this.actorLabel,
    required this.recordedAt,
  });

  final String participantName;
  final AttendanceStatus previousStatus;
  final AttendanceStatus newStatus;
  final String reason;
  final String actorLabel;
  final DateTime recordedAt;
}
