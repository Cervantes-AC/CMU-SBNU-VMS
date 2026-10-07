import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/user_repository.dart';
import '../../data/models/user.dart';
import '../../shared/app_feedback.dart';

/// Immutable profile view state.
class ProfileViewState {
  const ProfileViewState({
    this.loading = false,
    this.saving = false,
    this.profile,
    this.errorMessage,
    this.failureCategory,
    this.successMessage,
  });

  final bool loading;
  final bool saving;
  final UserProfile? profile;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final String? successMessage;

  ProfileViewState copyWith({
    bool? loading,
    bool? saving,
    UserProfile? profile,
    String? errorMessage,
    ErrorCategory? failureCategory,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) => ProfileViewState(
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        profile: profile ?? this.profile,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      );

  @override
  bool operator ==(Object other) =>
      other is ProfileViewState &&
      other.loading == loading &&
      other.saving == saving &&
      other.profile == profile &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.successMessage == successMessage;

  @override
  int get hashCode =>
      Object.hash(loading, saving, profile, errorMessage, failureCategory, successMessage);
}

/// Coordinates profile loading and self-updates against [UserRepository].
///
/// Never allows modification of role, status, uid, createdAt, or hours total.
/// Validation happens client-side for UX; backend rules are authoritative.
class ProfileController extends ChangeNotifier {
  ProfileController({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  ProfileViewState _state = const ProfileViewState();
  ProfileViewState get state => _state;

  bool _disposed = false;

  void _update(ProfileViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the current user's profile.
  Future<void> loadProfile(String uid) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _userRepository.getProfile(uid);
      if (_disposed) return;
      result.when(
        success: (profile) => _update(_state.copyWith(
              loading: false,
              profile: profile,
              clearError: true,
            )),
        failure: (error) => _update(_state.copyWith(
              loading: false,
              errorMessage: AppFeedback.messageFor(error),
              failureCategory: error.category,
            )),
      );
    } catch (error, st) {
      if (_disposed) return;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        loading: false,
        errorMessage: AppFeedback.messageFor(mapped ?? const UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  /// Updates allowed fields (displayName, photoUrl, course, yearLevel, contactNumber).
  Future<bool> updateProfile(Map<String, dynamic> fields) async {
    if (_state.saving) return false;
    final uid = _state.profile?.uid;
    if (uid == null) return false;

    _update(_state.copyWith(saving: true, clearError: true, clearSuccess: true));
    try {
      final result = await _userRepository.updateOwnProfile(
        uid: uid,
        fields: fields,
      );
      if (_disposed) return false;
      return result.when(
        success: (profile) {
          _update(_state.copyWith(
            saving: false,
            profile: profile,
            successMessage: 'Profile updated.',
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            saving: false,
            errorMessage: AppFeedback.messageFor(error),
            failureCategory: error.category,
            clearSuccess: true,
          ));
          return false;
        },
      );
    } catch (error, st) {
      if (_disposed) return false;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        saving: false,
        errorMessage: AppFeedback.messageFor(mapped ?? const UnexpectedException()),
        failureCategory: mapped?.category,
        clearSuccess: true,
      ));
      return false;
    }
  }

  /// Clears transient messages without touching loading/saving state.
  void clearMessages() {
    if (_disposed) return;
    if (_state.errorMessage == null && _state.successMessage == null) return;
    _update(_state.copyWith(clearError: true, clearSuccess: true));
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}