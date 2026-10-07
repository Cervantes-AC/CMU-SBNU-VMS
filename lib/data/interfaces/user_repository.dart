import '../../shared/result.dart';
import '../models/user.dart';

/// User profile repository contract.
///
/// Reads are scoped to the requesting UID; writes enforce the self-editable
/// field allowlist. No caller-supplied actor UID is trusted — the repository
/// receives the authenticated UID from the session.
abstract interface class UserRepository {
  /// Emits the current profile for [uid]; emits `null` when missing or
  /// malformed. The stream stops when the signed-in UID changes.
  Stream<UserProfile?> watchProfile(String uid);

  /// One-shot read for initialization.
  Future<Result<UserProfile>> getProfile(String uid);

  /// Updates a subset of the profile restricted to `selfEditableFields`.
  /// Returns the updated profile on success.
  Future<Result<UserProfile>> updateOwnProfile({
    required String uid,
    required Map<String, dynamic> fields,
  });

  /// Admin-only: updates role/status/revision. Not exposed to member flows.
  Future<Result<UserProfile>> updateProfileAdmin({
    required String uid,
    required Map<String, dynamic> fields,
    required int expectedRevision,
  });

  /// Searches the member directory with pagination. Returns a minimal
  /// projection (displayName, directoryStatus, unitLabel) suitable for
  /// officer/admin rosters. Members may not call this.
  Future<Result<({List<UserProfile> items, String? nextCursor})>> searchMembers({
    String? query,
    int limit = 20,
    String? startAfter,
  });
}