/// Domain/app error types with stable codes/categories.
///
/// Keep technical cause privately for redacted diagnostics; user-facing text
/// must be produced by the mapper. Do not retain request payloads in exception
/// objects.
sealed class AppException implements Exception {
  const AppException({
    required this.code,
    required this.category,
    required this.message,
    this.correlationId,
  });

  /// Stable error code for programmatic handling.
  final String code;

  /// High-level category for UX mapping.
  final ErrorCategory category;

  /// Developer-facing message (not for direct user display).
  final String message;

  /// Optional correlation ID for log tracing.
  final String? correlationId;

  @override
  String toString() => 'AppException($code, $category, $message)';
}

/// High-level error categories for UX mapping.
enum ErrorCategory {
  /// Input validation failed.
  validation,

  /// User is not authenticated.
  unauthenticated,

  /// User lacks permission for the operation.
  permissionDenied,

  /// Requested resource not found.
  notFound,

  /// Resource conflict (e.g., duplicate, concurrent modification).
  conflict,

  /// Service temporarily unavailable (network, backend down).
  unavailable,

  /// Rate limit exceeded.
  rateLimited,

  /// Unexpected/internal failure.
  unexpected,
}

/// Validation error with field-level details.
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    required this.fieldErrors,
    super.correlationId,
  }) : super(code: 'VALIDATION_ERROR', category: ErrorCategory.validation);

  /// Map of field name to error message.
  final Map<String, String> fieldErrors;
}

/// Unauthenticated - session expired or invalid.
class UnauthenticatedException extends AppException {
  const UnauthenticatedException({
    super.message = 'Session expired. Please sign in again.',
    super.correlationId,
  }) : super(code: 'UNAUTHENTICATED', category: ErrorCategory.unauthenticated);
}

/// Permission denied - user lacks required role/status.
class PermissionDeniedException extends AppException {
  const PermissionDeniedException({
    super.message = 'You do not have permission to perform this action.',
    super.correlationId,
  }) : super(code: 'PERMISSION_DENIED', category: ErrorCategory.permissionDenied);
}

/// Resource not found.
class NotFoundException extends AppException {
  NotFoundException({required String resource, super.correlationId})
      : super(
          code: 'NOT_FOUND',
          category: ErrorCategory.notFound,
          message: '$resource not found.',
        );
}

/// Resource conflict (duplicate, version mismatch).
class ConflictException extends AppException {
  const ConflictException({
    super.message = 'A conflict occurred. Please refresh and try again.',
    super.correlationId,
  }) : super(code: 'CONFLICT', category: ErrorCategory.conflict);
}

/// Service unavailable (offline, backend error).
class UnavailableException extends AppException {
  const UnavailableException({
    super.message = 'Service temporarily unavailable. Please try again later.',
    super.correlationId,
  }) : super(code: 'UNAVAILABLE', category: ErrorCategory.unavailable);
}

/// Rate limit exceeded.
class RateLimitedException extends AppException {
  const RateLimitedException({
    super.message = 'Too many requests. Please wait and try again.',
    this.retryAfterSeconds,
    super.correlationId,
  }) : super(code: 'RATE_LIMITED', category: ErrorCategory.rateLimited);

  /// Optional seconds until retry allowed.
  final int? retryAfterSeconds;
}

/// Unexpected/internal error.
class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.correlationId,
  }) : super(code: 'UNEXPECTED', category: ErrorCategory.unexpected);
}