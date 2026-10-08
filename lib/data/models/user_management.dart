import '../models/user.dart';

/// User management action result.
class UserManagementActionResult {
  const UserManagementActionResult({
    required this.success,
    this.message,
    this.updatedUser,
  });

  final bool success;
  final String? message;
  final UserProfile? updatedUser;
}