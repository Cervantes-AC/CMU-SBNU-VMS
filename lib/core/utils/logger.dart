import 'package:flutter/foundation.dart';

/// Structured log levels with a redaction boundary.
///
/// Never log user-entered text, email, phone, location, auth/FCM tokens,
/// document payloads, or exception causes containing data. Log only the
/// operation name, safe error code/category, and correlation ID.
enum LogLevel { debug, info, warning, error }

class Logger {
  Logger._();

  /// Keys whose values must never appear in logs.
  static const Set<String> sensitiveKeys = {
    'email',
    'password',
    'token',
    'idToken',
    'accessToken',
    'refreshToken',
    'fcmToken',
    'phone',
    'location',
    'latitude',
    'longitude',
    'authorization',
    'cookie',
    'apiKey',
    'secret',
    'credential',
    'displayName',
    'description',
    'narrative',
    'body',
  };

  static bool _enabled = kDebugMode;

  /// Toggle console output (tests disable this).
  static void setEnabled(bool enabled) => _enabled = enabled;

  /// Redacts a value if its key is sensitive; otherwise returns a short
  /// string representation.
  static String redactKey(String key, Object? value) {
    if (sensitiveKeys.contains(key)) return '<redacted>';
    if (value == null) return 'null';
    final s = value.toString();
    return s.length > 120 ? '${s.substring(0, 120)}…' : s;
  }

  /// Redacts a full map by key.
  static Map<String, String> redactMap(Map<String, Object?> fields) =>
      {for (final e in fields.entries) e.key: redactKey(e.key, e.value)};

  static void log(
    LogLevel level,
    String operation, {
    String? code,
    String? correlationId,
    Map<String, Object?> fields = const {},
  }) {
    // All output is gated: release builds must never print to system logs
    // without an approved, reviewed crash-reporting destination.
    if (!_enabled) return;
    final buffer = StringBuffer('[${level.name}] $operation');
    if (code != null) buffer.write(' code=$code');
    if (correlationId != null) buffer.write(' corr=$correlationId');
    final safe = redactMap(fields);
    if (safe.isNotEmpty) buffer.write(' fields=$safe');
    debugPrint(buffer.toString());
  }

  static void debug(String operation, {Map<String, Object?> fields = const {}}) =>
      log(LogLevel.debug, operation, fields: fields);

  static void info(String operation,
          {String? correlationId, Map<String, Object?> fields = const {}}) =>
      log(LogLevel.info, operation, correlationId: correlationId, fields: fields);

  static void warn(String operation,
          {String? code, String? correlationId, Map<String, Object?> fields = const {}}) =>
      log(LogLevel.warning,
          operation, code: code, correlationId: correlationId, fields: fields);

  /// Logs a caught error by safe code/category only — never the cause text,
  /// which may contain data.
  static void error(String operation, Object error,
          {String? correlationId, Map<String, Object?> fields = const {}}) =>
      log(LogLevel.error, operation,
          code: error.runtimeType.toString(),
          correlationId: correlationId,
          fields: fields);
}
