enum AttendanceStatus { present, absent, excused }

class PreviewAttendanceRecord {
  const PreviewAttendanceRecord({
    required this.displayName,
    required this.status,
  });

  final String displayName;
  final AttendanceStatus status;
}
