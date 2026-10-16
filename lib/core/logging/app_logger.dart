/// Privacy-safe logging interface for the CMU–SBNU VMS app.
///
/// Log event names, environment, app version, request/correlation ID, and
/// safe failure codes. Exclude private narrative, exact location, secrets,
/// and unnecessary identifiers.
abstract class AppLogger {
  void info(String event, {Map<String, dynamic>? fields});
  void warning(String event, {Map<String, dynamic>? fields});
  void error(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? fields,
  });
  void security(String event, {Map<String, dynamic>? fields});
}

/// No-op logger used when no concrete logging backend is configured.
class NoOpAppLogger implements AppLogger {
  const NoOpAppLogger();

  @override
  void info(String event, {Map<String, dynamic>? fields}) {}

  @override
  void warning(String event, {Map<String, dynamic>? fields}) {}

  @override
  void error(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? fields,
  }) {}

  @override
  void security(String event, {Map<String, dynamic>? fields}) {}
}

/// Console logger for development. Only safe fields are logged.
///
/// Stack traces are only emitted in debug mode to avoid leaking internal
/// implementation details in release builds. Sensitive keys are always
/// redacted.
class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger();

  @override
  void info(String event, {Map<String, dynamic>? fields}) {
    final safeFields = _sanitize(fields);
    // ignore: avoid_print
    print('[INFO] $event ${safeFields.isNotEmpty ? safeFields : ''}');
  }

  @override
  void warning(String event, {Map<String, dynamic>? fields}) {
    final safeFields = _sanitize(fields);
    // ignore: avoid_print
    print('[WARN] $event ${safeFields.isNotEmpty ? safeFields : ''}');
  }

  @override
  void error(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? fields,
  }) {
    final safeFields = _sanitize(fields);
    // ignore: avoid_print
    print('[ERROR] $event error=$error fields=$safeFields');
    // Stack traces can leak internal paths and logic; only emit in debug.
    if (stackTrace != null && _isDebug) {
      // ignore: avoid_print
      print(stackTrace.toString());
    }
  }

  @override
  void security(String event, {Map<String, dynamic>? fields}) {
    final safeFields = _sanitize(fields);
    // ignore: avoid_print
    print('[SECURITY] $event ${safeFields.isNotEmpty ? safeFields : ''}');
  }

  Map<String, dynamic> _sanitize(Map<String, dynamic>? fields) {
    if (fields == null) return {};
    final result = <String, dynamic>{};
    for (final entry in fields.entries) {
      final key = entry.key.toLowerCase();
      // Strip known sensitive keys.
      if (_isSensitiveKey(key)) {
        result[entry.key] = '[REDACTED]';
      } else {
        result[entry.key] = _sanitizeValue(entry.value);
      }
    }
    return result;
  }

  dynamic _sanitizeValue(dynamic value) {
    if (value is String) {
      // Never log values that look like tokens, emails, or UIDs even under
      // non-sensitive keys.
      if (_looksSensitive(value)) return '[REDACTED]';
    }
    if (value is Map) {
      return _sanitize(Map<String, dynamic>.from(value));
    }
    if (value is List) {
      return value.map(_sanitizeValue).toList();
    }
    return value;
  }

  bool _isSensitiveKey(String key) {
    return key.contains('password') ||
        key.contains('token') ||
        key.contains('secret') ||
        key.contains('narrative') ||
        key.contains('location') ||
        key.contains('lat') ||
        key.contains('lng') ||
        key.contains('email') ||
        key.contains('phone') ||
        key.contains('uid') ||
        key.contains('key') ||
        key.contains('credential') ||
        key.contains('authorization') ||
        key.contains('cookie');
  }

  /// Heuristic: a string that looks like a token, email, UID, or secret.
  bool _looksSensitive(String value) {
    if (value.isEmpty) return false;
    // Email-like.
    if (value.contains('@') && value.contains('.')) return true;
    // UID-like: short alphanumeric with underscores, e.g. vol_001, act_001.
    if (RegExp(r'^[a-z]+_[0-9]+$').hasMatch(value)) return true;
    // Token-like: long base64/hex strings.
    if (value.length > 24 && RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value)) {
      return true;
    }
    return false;
  }

  bool get _isDebug {
    // Avoid importing dart:io here; use kDebugMode from foundation.
    bool debug = false;
    assert(debug = true);
    return debug;
  }
}
