import '../../shared/result.dart';
import '../models/user.dart';

/// Authentication/session contract.
///
/// Returns auth identity separately from [UserProfile]; this repository does
/// not decide admin authorization. No password storage/logging. Registration
/// exists only if approved (not implemented — no approval recorded).
abstract interface class AuthRepository {
  /// Emits the authenticated UID on sign-in/sign-out/token changes.
  /// Emits `null` when signed out. Never emits profile data.
  Stream<String?> watchSession();

  /// Emits the current profile for [uid]; emits `null` when the profile is
  /// missing or malformed (fail closed — callers must treat null as
  /// "no access"). Clears and stops when [uid] no longer matches the
  /// authenticated session (prevents stale profile after UID change).
  Stream<UserProfile?> watchCurrentProfile(String uid);

  /// Signs in and returns the UID on success.
  ///
  /// Idempotent for repeated identical credentials within a session window
  /// (Firebase Auth handles duplicate sign-in). Errors are typed and safe.
  Future<Result<String>> signIn(String email, String password);

  /// Sends a password-reset request. The result is intentionally identical
  /// for existing and non-existing accounts (no account enumeration).
  Future<Result<void>> sendPasswordReset(String email);

  /// Signs out. Safe to call when already signed out.
  Future<Result<void>> signOut();

  /// Forces a token/session refresh.
  Future<Result<void>> refreshSession();

  /// Current authenticated UID, or null.
  String? get currentUid;
}
