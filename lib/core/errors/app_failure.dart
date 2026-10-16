import 'package:equatable/equatable.dart';

/// Base class for all safe typed failures in the app.
///
/// Failures carry no secrets, incident narratives, precise location, or
/// hotline verification material. They are safe to display to the user and
/// to log in privacy-safe logs.
abstract class AppFailure extends Equatable {
  /// A short, user-safe message. Never include private data here.
  final String message;

  /// Whether this failure is safe to retry automatically.
  final bool isRetryable;

  const AppFailure({required this.message, this.isRetryable = false});

  @override
  List<Object?> get props => [message, isRetryable];
}

/// The app could not connect to its configured backend services.
class ServiceUnavailableFailure extends AppFailure {
  const ServiceUnavailableFailure({
    super.message = 'Service unavailable.',
    super.isRetryable = true,
  });
}

/// The requested resource was not found.
class NotFoundFailure extends AppFailure {
  const NotFoundFailure({super.message = 'Item not found.'});
}

/// The user is not authenticated.
class UnauthenticatedFailure extends AppFailure {
  const UnauthenticatedFailure({super.message = 'Please sign in to continue.'});
}

/// The user does not have permission for this action.
class PermissionDeniedFailure extends AppFailure {
  const PermissionDeniedFailure({
    super.message = 'You are not authorized to do this.',
  });
}

/// The request was invalid (bad input, conflict, precondition failed).
class InvalidRequestFailure extends AppFailure {
  const InvalidRequestFailure({
    super.message = 'Invalid request.',
    super.isRetryable = false,
  });
}

/// A network or connectivity problem occurred.
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'Network error. Please check your connection.',
    super.isRetryable = true,
  });
}

/// A Firebase-specific error translated into a safe typed failure.
class FirebaseFailure extends AppFailure {
  const FirebaseFailure({
    required super.message,
    super.isRetryable = false,
    this.originalCode,
  });

  /// The original Firebase error code, safe to log but never show to users.
  final String? originalCode;
}

/// A generic unexpected failure.
class UnknownFailure extends AppFailure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.isRetryable = true,
  });
}
