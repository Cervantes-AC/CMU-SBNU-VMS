import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../data/interfaces/auth_repository.dart';
import '../../shared/app_feedback.dart';

/// Immutable auth view state.
class AuthViewState {
  const AuthViewState({
    this.submitting = false,
    this.errorMessage,
    this.failureCategory,
    this.infoMessage,
    this.resetSent = false,
  });

  /// True while a sign-in or reset request is in flight.
  final bool submitting;

  /// Safe, user-facing failure copy (never an SDK message or PII).
  final String? errorMessage;

  /// Category of the last failure, for UI logic/tests. Never rendered raw.
  final ErrorCategory? failureCategory;

  /// Safe, user-facing info copy (e.g. connected-service hints).
  final String? infoMessage;

  /// True once a password-reset request has been dispatched (the UI shows
  /// an identical response regardless of account existence).
  final bool resetSent;

  AuthViewState copyWith({
    bool? submitting,
    String? errorMessage,
    ErrorCategory? failureCategory,
    String? infoMessage,
    bool? resetSent,
    bool clearError = false,
    bool clearInfo = false,
  }) =>
      AuthViewState(
        submitting: submitting ?? this.submitting,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        infoMessage: clearInfo ? null : infoMessage ?? this.infoMessage,
        resetSent: resetSent ?? this.resetSent,
      );

  @override
  bool operator ==(Object other) =>
      other is AuthViewState &&
      other.submitting == submitting &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.infoMessage == infoMessage &&
      other.resetSent == resetSent;

  @override
  int get hashCode =>
      Object.hash(submitting, errorMessage, failureCategory, infoMessage, resetSent);
}

/// Coordinates sign-in and password-reset user intent against
/// [AuthRepository].
///
/// Never retains the password after the request completes. View state is
/// immutable; screens render it and dispatch intent methods.
class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthViewState _state = const AuthViewState();
  AuthViewState get state => _state;

  bool _disposed = false;

  void _update(AuthViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Signs in. Returns true on success. On failure, sets a safe error
  /// message and returns false. The password is never stored.
  Future<bool> signIn(String email, String password) async {
    if (_state.submitting) return false;
    _update(_state.copyWith(
        submitting: true, clearError: true, clearInfo: true));
    try {
      final result = await _authRepository.signIn(email, password);
      return result.when(
        success: (_) {
          _update(_state.copyWith(submitting: false, clearError: true));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            submitting: false,
            errorMessage: AppFeedback.messageFor(error),
            failureCategory: error.category,
          ));
          return false;
        },
      );
    } finally {
      // Password is released here regardless of outcome.
      if (!_disposed && _state.submitting) {
        _update(_state.copyWith(submitting: false));
      }
    }
  }

  /// Requests a password reset. Always surfaces the same neutral success
  /// copy for valid-looking addresses; real failures show safe retry copy.
  Future<void> sendPasswordReset(String email) async {
    if (_state.submitting) return;
    _update(_state.copyWith(
        submitting: true, clearError: true, clearInfo: true));
    final result = await _authRepository.sendPasswordReset(email);
    if (_disposed) return;
    result.when(
      success: (_) {
        _update(_state.copyWith(submitting: false, resetSent: true));
      },
      failure: (error) {
        _update(_state.copyWith(
          submitting: false,
          errorMessage: AppFeedback.messageFor(error),
          failureCategory: error.category,
        ));
      },
    );
  }

  /// Clears error/info messages without touching the submitting state.
  void clearMessage() {
    if (_disposed) return;
    if (_state.errorMessage == null && _state.infoMessage == null) return;
    _update(_state.copyWith(clearError: true, clearInfo: true));
  }

  /// Signs out and clears user-scoped state. Navigation back to the public
  /// landing page is driven by the session watcher, not this method.
  Future<void> signOut() async {
    final result = await _authRepository.signOut();
    if (_disposed) return;
    result.when(
      success: (_) {},
      failure: (error) {
        _update(_state.copyWith(
          errorMessage: AppFeedback.messageFor(error),
          failureCategory: error.category,
        ));
      },
    );
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
