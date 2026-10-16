/// Simple client-side rate limiter to help prevent rapid repeated actions
/// (e.g. resubmitting SOS, repeated sign-in attempts, QR rescans).
///
/// This is a client-side UX guard only. It does not replace server-side or
/// Firestore-Rules rate limiting, which is the authoritative boundary.
class RateLimiter {
  RateLimiter();

  final Map<String, List<DateTime>> _stamps = {};

  /// Records an attempt for [key] and returns whether it is allowed.
  ///
  /// [windowSeconds] is the lookback window; [maxAttempts] is the max number
  /// of attempts allowed within that window.
  bool record(String key, {int windowSeconds = 60, int maxAttempts = 5}) {
    final now = DateTime.now();
    final windowStart = now.subtract(Duration(seconds: windowSeconds));

    final history = _stamps.putIfAbsent(key, () => <DateTime>[]);
    // Remove timestamps outside the window.
    history.removeWhere((t) => t.isBefore(windowStart));

    if (history.length >= maxAttempts) {
      return false;
    }

    history.add(now);
    return true;
  }

  /// Returns the seconds remaining before [key] can be retried, or 0 if
  /// immediately allowed.
  int secondsRemaining(
    String key, {
    int windowSeconds = 60,
    int maxAttempts = 5,
  }) {
    final now = DateTime.now();
    final windowStart = now.subtract(Duration(seconds: windowSeconds));
    final history = _stamps[key];
    if (history == null || history.isEmpty) return 0;
    final valid = history.where((t) => !t.isBefore(windowStart)).toList()
      ..sort();
    if (valid.length < maxAttempts) return 0;
    final oldest = valid.first;
    final allowedAt = oldest.add(Duration(seconds: windowSeconds));
    final remaining = allowedAt.difference(now).inSeconds;
    return remaining.clamp(0, windowSeconds);
  }

  /// Clears all history (e.g. on sign-out).
  void clear() {
    _stamps.clear();
  }
}

/// A shared rate limiter instance for UI-level guards. Prefer injecting a
/// per-feature limiter where different windows are needed.
final appRateLimiter = RateLimiter();
