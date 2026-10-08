import '../../shared/result.dart';
import '../models/user.dart';
import 'package:cmu_sbnu_vms/features/user_management/user_management.dart';

/// User management repository contract.
///
/// Provides admin-only operations for user management. All mutations
/// require admin role (enforced by backend rules).
abstract interface class UserManagementRepository {
  /// Emits a paginated list of users with optional filtering.
  Stream<({List<UserProfile> items, String? nextCursor})> watchUsers({
    UserManagementFilter? statusFilter,
    UserManagementSort? sort,
    int limit = 20,
  });

  /// One-shot fetch of users with optional filtering.
  Future<Result<({List<UserProfile> items, String? nextCursor})>> getUsers({
    UserManagementFilter? statusFilter,
    UserManagementSort? sort,
    int limit = 20,
    String? startAfter,
  });

  /// Fetches a single user by UID.
  Future<Result<UserProfile>> getUser(String uid);

  /// Updates a user's status (admin only).
  Future<Result<UserManagementActionResult>> updateUserStatus({
    required String uid,
    required AccountStatus newStatus,
    required int expectedRevision,
  });

  /// Updates a user's role (admin only).
  Future<Result<UserManagementActionResult>> updateUserRole({
    required String uid,
    required UserRole newRole,
    required int expectedRevision,
  });

  /// Updates multiple fields for a user (admin only).
  Future<Result<UserManagementActionResult>> updateUser({
    required String uid,
    required Map<String, dynamic> fields,
    required int expectedRevision,
  });

  /// Deactivates a user (admin only).
  Future<Result<UserManagementActionResult>> deactivateUser(String uid);

  /// Reactivates a deactivated user (admin only).
  Future<Result<UserManagementActionResult>> reactivateUser(String uid);

  /// Searches users by name or email.
  Future<Result<({List<UserProfile> items, String? nextCursor})>> searchUsers({
    required String searchQuery,
    int limit = 20,
    String? startAfter,
  });

  /// Gets user statistics for dashboard.
  Future<Result<UserStatistics>> getUserStatistics();
}