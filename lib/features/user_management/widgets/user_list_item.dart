import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

/// List item for a user in the management screen.
class UserListItem extends StatelessWidget {
  const UserListItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  final UserProfile user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _statusColor(user.status).withAlpha(20),
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
                    ? Icon(Icons.person_rounded, size: 24, color: _statusColor(user.status))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(status: user.status.wire, compact: true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.course != null ? '${user.course} · ${user.yearLevel ?? ''}' : user.yearLevel ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 12, color: muted),
                        const SizedBox(width: 4),
                        Text(
                          'Joined: ${DateHelpers.formatDate(user.createdAt)}',
                          style: TextStyle(color: muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  StatusBadge(status: user.role.wire, compact: true),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _roleColor(user.role).withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _roleLabel(user.role),
                      style: TextStyle(
                        color: _roleColor(user.role),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _roleLabel(UserRole role) => switch (role) {
        UserRole.member => 'Member',
        UserRole.officer => 'Officer',
        UserRole.admin => 'Admin',
      };

  static Color _statusColor(AccountStatus status) => switch (status) {
        AccountStatus.approved => const Color(0xFF2E7D4F),
        AccountStatus.pending => const Color(0xFFB7791F),
        AccountStatus.denied => const Color(0xFFB3372C),
        AccountStatus.suspended => const Color(0xFFB3372C),
        AccountStatus.deactivated => const Color(0xFF65736D),
        AccountStatus.blocked => const Color(0xFFB3372C),
      };

  static Color _roleColor(UserRole role) => switch (role) {
        UserRole.member => const Color(0xFF245B4B),
        UserRole.officer => const Color(0xFF2C6E9E),
        UserRole.admin => const Color(0xFFB3372C),
      };
}