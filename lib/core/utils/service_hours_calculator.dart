/// Pure deterministic service-hour calculation from approved attendance/duty
/// facts.
///
/// Never accepts a user-maintained total as source of truth. Policy:
/// - Source facts: check-in/check-out timestamps (UTC).
/// - Overnight events count the full elapsed duration.
/// - Zero/negative durations yield 0.
/// - Result rounds down to the nearest 0.25 hour (15 minutes).
/// - Maximum single record: 24 hours (anything longer is clamped and flagged).
class ServiceHoursCalculator {
  ServiceHoursCalculator._();

  static const double maxHoursPerRecord = 24.0;
  static const Duration minIncrement = Duration(minutes: 15);

  /// Computes hours from [checkIn]/[checkOut]. Returns 0 when facts are
  /// missing or the interval is non-positive.
  static double compute({
    required DateTime? checkIn,
    required DateTime? checkOut,
  }) {
    if (checkIn == null || checkOut == null) return 0;
    final start = checkIn.toUtc();
    final end = checkOut.toUtc();
    if (!end.isAfter(start)) return 0;
    var duration = end.difference(start);
    if (duration > const Duration(days: 1)) {
      duration = const Duration(days: 1);
    }
    return clampToIncrement(duration);
  }

  /// Sums deduplicated record facts (each record counted once) for a member
  /// over an optional [from]/[to] (inclusive start, exclusive end) window.
  static double total(
    Iterable<({DateTime? checkIn, DateTime? checkOut})> records, {
    DateTime? from,
    DateTime? to,
  }) {
    var sum = 0.0;
    for (final r in records) {
      if (r.checkIn == null || r.checkOut == null) continue;
      // Skip records entirely outside the window.
      if (from != null && r.checkOut!.toUtc().isBefore(from.toUtc())) continue;
      if (to != null && !r.checkIn!.toUtc().isBefore(to.toUtc())) continue;
      sum += compute(checkIn: r.checkIn, checkOut: r.checkOut);
    }
    return double.parse(sum.toStringAsFixed(2));
  }

  /// Rounds a duration down to the nearest 15-minute increment and converts
  /// to hours, capped at [maxHoursPerRecord].
  static double clampToIncrement(Duration duration) {
    if (duration <= Duration.zero) return 0;
    final minutes = duration.inMinutes;
    final floored = minutes - (minutes % minIncrement.inMinutes);
    var hours = floored / 60.0;
    if (hours > maxHoursPerRecord) hours = maxHoursPerRecord;
    return double.parse(hours.toStringAsFixed(2));
  }

  /// Formats hours for display: "7.5 h" / "7.25 h".
  static String format(double hours) => '${hours.toStringAsFixed(2)} h';
}
