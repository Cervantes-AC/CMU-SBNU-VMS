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
    if (stackTrace != null) {
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
        result[entry.key] = entry.value;
      }
    }
    return result;
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
        key.contains('key');
  }
}
