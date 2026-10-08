// Barrel export for user management feature.
export 'user_management_controller.dart';
export 'user_management_screen.dart';
export 'widgets/user_list_item.dart';
export 'widgets/user_statistics_card.dart';
export 'package:cmu_sbnu_vms/data/models/user.dart';

import 'package:cmu_sbnu_vms/data/models/user.dart';

/// User statistics for dashboard display.
class UserStatistics {
  const UserStatistics({
    required this.total,
    required this.pending,
    required this.approved,
    required this.denied,
    required this.suspended,
    required this.deactivated,
    required this.blocked,
    required this.officers,
    required this.admins,
  });

  final int total;
  final int pending;
  final int approved;
  final int denied;
  final int suspended;
  final int deactivated;
  final int blocked;
  final int officers;
  final int admins;
}

/// User management filter options.
enum UserManagementFilter {
  all('all'),
  pending('pending'),
  approved('approved'),
  denied('denied'),
  suspended('suspended'),
  deactivated('deactivated'),
  blocked('blocked');

  const UserManagementFilter(this.wire);
  final String wire;

  static UserManagementFilter? tryParse(String? raw) {
    if (raw == null) return null;
    for (final f in UserManagementFilter.values) {
      if (f.wire == raw) return f;
    }
    return null;
  }
}

/// User management sort options.
enum UserManagementSort {
  nameAsc('name_asc'),
  nameDesc('name_desc'),
  createdAsc('created_asc'),
  createdDesc('created_desc'),
  statusAsc('status_asc'),
  statusDesc('status_desc'),
  roleAsc('role_asc'),
  roleDesc('role_desc');

  const UserManagementSort(this.wire);
  final String wire;

  static UserManagementSort? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in UserManagementSort.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

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