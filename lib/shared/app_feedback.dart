import 'package:flutter/material.dart';

import '../core/error/app_exception.dart';

/// Shared feedback helpers mapping typed errors to concise, actionable,
/// safe user messages. Never exposes stack traces, raw SDK messages,
/// document IDs, secrets, or PII.
class AppFeedback {
  AppFeedback._();

  /// Safe user-facing copy for an error category.
  static String messageFor(AppException error) => switch (error) {
        ValidationException() =>
          'Please check the highlighted fields and try again.',
        UnauthenticatedException(:final message) => message,
        PermissionDeniedException() =>
          'You don\'t have permission to do that. If you think this is a mistake, contact your unit administrator.',
        NotFoundException(:final message) => message,
        ConflictException(:final message) => message,
        UnavailableException() =>
          'We couldn\'t reach the server. Check your connection and try again.',
        RateLimitedException() =>
          'Too many attempts. Please wait a moment and try again.',
        UnexpectedException() =>
          'Something went wrong. Please try again, or contact your unit administrator if it continues.',
      };

  static const String genericErrorMessage =
      'Something went wrong. Please try again.';

  /// Shows a success snackbar. Deduplicates consecutive identical messages
  /// for the same Scaffold.
  static void success(BuildContext context, String message) =>
      _show(context, message, Icons.check_circle_rounded, const Color(0xFF2E7D4F));

  static void info(BuildContext context, String message) =>
      _show(context, message, Icons.info_rounded, const Color(0xFF2C6E9E));

  static void error(BuildContext context, AppException error, {String? fallback}) =>
      _show(context, fallback ?? messageFor(error),
          Icons.error_rounded, const Color(0xFFB3372C));

  static void show(BuildContext context, String message) =>
      _show(context, message, Icons.notifications_rounded, null);

  static void _show(
      BuildContext context, String message, IconData icon, Color? color) {
    if (!context.mounted) return;
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, size: 18, color: color ?? scheme.onInverseSurface),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: TextStyle(
                        color: color ?? scheme.onInverseSurface, fontSize: 13)),
              ),
            ],
          ),
        ),
      );
  }
}
