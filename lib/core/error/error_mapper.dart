/// Maps Firebase/platform exceptions and domain failures into [AppException].
///
/// Preserve cancellation separately from failure. Avoid relying only on message
/// substring matching. Include correlation ID if available, but never personal data.
library;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_exception.dart';

/// Maps a generic error/exception to an [AppException].
///
/// Returns null if the error is a [AppException] already (preserves it).
/// Returns [OperationCancelledException] if the error indicates user cancellation.
AppException? mapToAppException(Object error, StackTrace? stackTrace, {String? correlationId}) {
  if (error is AppException) return error;

  // Firebase Auth errors
  if (error is firebase_auth.FirebaseAuthException) {
    return _mapFirebaseAuthError(error, correlationId);
  }

  // Firestore errors
  if (error is FirebaseException) {
    return _mapFirestoreError(error, correlationId);
  }

  // Standard Dart errors
  if (error is ArgumentError) {
    return ValidationException(
      message: error.message ?? 'Invalid argument.',
      fieldErrors: const {},
      correlationId: correlationId,
    );
  }

  if (error is FormatException) {
    return ValidationException(
      message: error.message,
      fieldErrors: const {},
      correlationId: correlationId,
    );
  }

  if (error is StateError) {
    return UnexpectedException(
      message: error.message,
      correlationId: correlationId,
    );
  }

  // Unknown error
  return UnexpectedException(
    message: 'An unexpected error occurred.',
    correlationId: correlationId,
  );
}

/// Maps FirebaseAuthException to AppException.
AppException _mapFirebaseAuthError(firebase_auth.FirebaseAuthException error, String? correlationId) {
  switch (error.code) {
    case 'invalid-email':
    case 'invalid-credential':
      return ValidationException(
        message: 'Invalid email or password.',
        fieldErrors: {'email': 'Invalid email or password.'},
        correlationId: correlationId,
      );
    case 'user-disabled':
      return PermissionDeniedException(
        message: 'This account has been disabled. Contact your administrator.',
        correlationId: correlationId,
      );
    case 'user-not-found':
    case 'wrong-password':
      // Use generic message to avoid account enumeration.
      return UnauthenticatedException(
        message: 'Invalid email or password.',
        correlationId: correlationId,
      );
    case 'too-many-requests':
      return RateLimitedException(
        message: 'Too many sign-in attempts. Please try again later.',
        retryAfterSeconds: 300,
        correlationId: correlationId,
      );
    case 'network-request-failed':
      return UnavailableException(
        message: 'Network error. Please check your connection.',
        correlationId: correlationId,
      );
    case 'operation-not-allowed':
      return PermissionDeniedException(
        message: 'This sign-in method is not enabled.',
        correlationId: correlationId,
      );
    case 'requires-recent-login':
      return UnauthenticatedException(
        message: 'Please sign in again to continue.',
        correlationId: correlationId,
      );
    case 'credential-already-in-use':
      return ConflictException(
        message: 'This account is already linked to another sign-in method.',
        correlationId: correlationId,
      );
    case 'invalid-verification-code':
    case 'invalid-verification-id':
      return ValidationException(
        message: 'Invalid verification code.',
        fieldErrors: {'code': 'Invalid verification code.'},
        correlationId: correlationId,
      );
    case 'session-expired':
      return UnauthenticatedException(
        message: 'Your session has expired. Please sign in again.',
        correlationId: correlationId,
      );
    default:
      return UnexpectedException(
        message: 'Authentication failed. Please try again.',
        correlationId: correlationId,
      );
  }
}

/// Maps Firestore FirebaseException to AppException. Returns null when the
/// error is a cancellation (not a failure).
AppException? _mapFirestoreError(FirebaseException error, String? correlationId) {
  switch (error.code) {
    case 'permission-denied':
      return PermissionDeniedException(
        message: 'You do not have permission to access this data.',
        correlationId: correlationId,
      );
    case 'not-found':
      return NotFoundException(
        resource: 'Document',
        correlationId: correlationId,
      );
    case 'already-exists':
      return ConflictException(
        message: 'A record with this identifier already exists.',
        correlationId: correlationId,
      );
    case 'resource-exhausted':
      return RateLimitedException(
        message: 'Too many requests. Please try again later.',
        retryAfterSeconds: 60,
        correlationId: correlationId,
      );
    case 'unavailable':
    case 'deadline-exceeded':
      return UnavailableException(
        message: 'Service temporarily unavailable. Please try again.',
        correlationId: correlationId,
      );
    case 'unauthenticated':
      return UnauthenticatedException(
        message: 'Your session has expired. Please sign in again.',
        correlationId: correlationId,
      );
    case 'invalid-argument':
      return ValidationException(
        message: 'Invalid query or data format.',
        fieldErrors: const {},
        correlationId: correlationId,
      );
    case 'failed-precondition':
      return ConflictException(
        message: 'Operation cannot be completed. Please refresh and try again.',
        correlationId: correlationId,
      );
    case 'aborted':
      return ConflictException(
        message: 'Operation was aborted due to a conflict. Please retry.',
        correlationId: correlationId,
      );
    case 'cancelled':
      // This is not a failure - treat as cancellation.
      return null;
    default:
      return UnexpectedException(
        message: 'A database error occurred. Please try again.',
        correlationId: correlationId,
      );
  }
}

/// Marker for user-initiated cancellation (not an error).
class OperationCancelledException implements Exception {
  const OperationCancelledException([this.message]);

  final String? message;

  @override
  String toString() => 'OperationCancelledException: $message';
}