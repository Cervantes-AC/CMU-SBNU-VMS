import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Parsers/formatters and explicit timezone conversion helpers.
///
/// Storage is UTC; unit-local date-range boundaries require a timezone
/// argument. Intervals are inclusive-start/exclusive-end unless noted.
///
/// Timezone note: this helper implements the unit timezone explicitly
/// (Asia/Manila, UTC+08:00, no DST) without adding a timezone database
/// dependency. If additional zones or DST correctness become required,
/// replace the wall-clock helpers with a dedicated timezone package through
/// a documented decision.
class DateHelpers {
  DateHelpers._();

  static const String _iso8601 = 'yyyy-MM-ddTHH:mm:ssZ';
  static const Duration _manilaOffset = Duration(hours: 8);

  /// Returns the wall-clock instant for [time] in [timezone].
  ///
  /// For 'Asia/Manila' the result carries the zone's wall-clock components;
  /// other zones fall back to device-local components.
  static DateTime _wallClock(DateTime time, String timezone) {
    if (timezone == 'Asia/Manila') return time.toUtc().add(_manilaOffset);
    return time.toLocal();
  }

  /// Converts a wall-clock component triple in [timezone] to a UTC instant.
  static DateTime _utcFromWallClock(DateTime wall, String timezone) {
    if (timezone == 'Asia/Manila') {
      final asUtc = DateTime.utc(wall.year, wall.month, wall.day, wall.hour,
          wall.minute, wall.second);
      return asUtc.subtract(_manilaOffset);
    }
    // Unknown zone: wall components are already device-local.
    return DateTime(wall.year, wall.month, wall.day, wall.hour, wall.minute,
        wall.second)
        .toUtc();
  }

  /// Formats a UTC instant as an ISO-8601 string (UTC, 'Z' suffix).
  static String toIsoUtc(DateTime time) =>
      DateFormat(_iso8601).format(time.toUtc());

  /// Parses an ISO-8601 string; returns null on invalid input.
  static DateTime? tryParseIsoUtc(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value).toUtc();
    } on FormatException {
      return null;
    }
  }

  /// Start of the local calendar day containing [time], as a UTC instant.
  static DateTime startOfDayInZone(DateTime time, String timezone) {
    final wall = _wallClock(time, timezone);
    return _utcFromWallClock(
        DateTime(wall.year, wall.month, wall.day), timezone);
  }

  /// End (exclusive) of the local calendar day containing [time].
  static DateTime endOfDayInZone(DateTime time, String timezone) =>
      startOfDayInZone(time, timezone).add(const Duration(days: 1));

  /// Inclusive-start/exclusive-end range for the local day of [time].
  static ({DateTime start, DateTime end}) dayRange(
          DateTime time, String timezone) =>
      (start: startOfDayInZone(time, timezone),
       end: endOfDayInZone(time, timezone));

  /// Inclusive-start/exclusive-end range for a calendar month in [timezone].
  static ({DateTime start, DateTime end}) monthRange(
      int year, int month, String timezone) {
    final start = DateTime(year, month, 1);
    final end = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return (
      start: _utcFromWallClock(start, timezone),
      end: _utcFromWallClock(end, timezone),
    );
  }

  /// Whether [time] falls inside [start, end).
  static bool isWithin(DateTime time, DateTime start, DateTime end) =>
      !time.isBefore(start) && time.isBefore(end);

  /// Human-friendly local date: "12 Oct 2026".
  static String formatDate(DateTime time,
          {String timezone = AppConstants.unitTimezone}) =>
      DateFormat('d MMM yyyy').format(_wallClock(time, timezone));

  /// Human-friendly local date and time: "12 Oct 2026, 08:30".
  static String formatDateTime(DateTime time,
          {String timezone = AppConstants.unitTimezone}) =>
      DateFormat('d MMM yyyy, HH:mm').format(_wallClock(time, timezone));

  /// Short local time: "08:30".
  static String formatTime(DateTime time,
          {String timezone = AppConstants.unitTimezone}) =>
      DateFormat('HH:mm').format(_wallClock(time, timezone));

  /// Relative label such as "in 3 days" / "2 hours ago". Within a minute
  /// returns "just now".
  static String relative(DateTime time, {DateTime? now}) {
    final ref = now ?? DateTime.now().toUtc();
    final diff = time.toUtc().difference(ref);
    final past = diff.isNegative;
    final d = diff.abs();
    String label;
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) {
      label = '${d.inMinutes} min';
    } else if (d.inHours < 24) {
      label = '${d.inHours} hr';
    } else if (d.inDays < 30) {
      label = '${d.inDays} day${d.inDays == 1 ? '' : 's'}';
    } else if (d.inDays < 365) {
      final months = d.inDays ~/ 30;
      label = '$months month${months == 1 ? '' : 's'}';
    } else {
      final years = d.inDays ~/ 365;
      label = '$years year${years == 1 ? '' : 's'}';
    }
    return past ? '$label ago' : 'in $label';
  }
}
