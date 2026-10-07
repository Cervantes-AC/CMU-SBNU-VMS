import '../../shared/result.dart';
import '../models/attendance.dart';

/// Attendance repository contract.
///
/// Queries are typed and paginated. Only authorized roles may record/correct.
/// Caller does not supply actor UID — the repository derives it from the session.
abstract interface class AttendanceRepository {
  /// Emits a paged list of attendance records for an event (officer/admin only).
  Stream<({List<Attendance> items, String? nextCursor})> watchEventAttendance({
    required String eventId,
    int limit = 50,
  });

  /// One-shot fetch of attendance records for an event (officer/admin only).
  Future<Result<({List<Attendance> items, String? nextCursor})>> getEventAttendance({
    required String eventId,
    int limit = 50,
    String? startAfter,
  });

  /// Emits the current user's attendance record for an event.
  Stream<Attendance?> watchMyAttendance(String eventId);

  /// One-shot fetch of the current user's attendance record for an event.
  Future<Result<Attendance?>> getMyAttendance(String eventId);

  /// Records attendance via QR scan or manual entry (officer/admin or self via QR).
  /// Idempotent per (eventId, uid) — returns existing record on duplicate.
  Future<Result<Attendance>> recordAttendance({
    required String eventId,
    required AttendanceStatus status,
    required AttendanceSource source,
  });

  /// Corrects an existing attendance record (officer/admin only).
  /// Requires revision for optimistic concurrency.
  Future<Result<Attendance>> correctAttendance({
    required String attendanceId,
    required AttendanceStatus newStatus,
    required int expectedRevision,
  });

  /// Gets attendance summary for an event (counts by status).
  Future<Result<AttendanceSummary>> getAttendanceSummary(String eventId);
}

/// Summary of attendance counts for an event.
class AttendanceSummary {
  const AttendanceSummary({
    required this.total,
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  final int total;
  final int present;
  final int late;
  final int absent;
  final int excused;
}