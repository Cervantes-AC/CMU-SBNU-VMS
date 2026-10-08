import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/data/models/attendance.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'attendance_status_picker.dart';

/// A row displaying a member's attendance status in the officer roster.
///
/// Shows member name, role badge, status picker (for officers), and source.
/// Tap handling for status changes is delegated to [onStatusChanged].
class AttendanceMemberRow extends StatelessWidget {
  const AttendanceMemberRow({
    super.key,
    required this.attendance,
    required this.memberName,
    required this.memberRole,
    this.onStatusChanged,
    this.showStatusPicker = false,
    this.compact = false,
  });

  final Attendance attendance;
  final String memberName;
  final UserRole memberRole;
  final ValueChanged<AttendanceStatus>? onStatusChanged;
  final bool showStatusPicker;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE1E8E1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Member avatar/initial
          CircleAvatar(
            radius: compact ? 16 : 20,
            backgroundColor: const Color(0xFF245B4B).withAlpha(20),
            child: Text(
              memberName.isNotEmpty ? memberName[0].toUpperCase() : '?',
              style: TextStyle(
                color: const Color(0xFF245B4B),
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: compact ? 10 : 12),
          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  memberName,
                  style: TextStyle(
                    fontSize: compact ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _RoleBadge(role: memberRole, compact: compact),
                    const SizedBox(width: 8),
                    Text(
                      attendance.source.wire.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: compact ? 10 : 11,
                        color: muted,
                      ),
                    ),
                    if (attendance.correctedAt != null) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.edit_outlined, size: compact ? 10 : 12, color: Colors.orange),
                      const SizedBox(width: 2),
                      Text(
                        'Corrected',
                        style: TextStyle(
                          fontSize: compact ? 10 : 11,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Status picker or display
          if (showStatusPicker && onStatusChanged != null)
            AttendanceStatusPicker(
              currentStatus: attendance.status,
              onChanged: onStatusChanged!,
              compact: compact,
            )
          else
            _StatusDisplay(status: attendance.status, compact: compact),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role, this.compact = false});

  final UserRole role;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (role) {
      UserRole.admin => (const Color(0xFFB3372C), 'ADMIN'),
      UserRole.officer => (const Color(0xFF245B4B), 'OFFICER'),
      UserRole.member => (const Color(0xFF65736D), 'MEMBER'),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 8 : 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _StatusDisplay extends StatelessWidget {
  const _StatusDisplay({required this.status, this.compact = false});

  final AttendanceStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      AttendanceStatus.present => (Colors.green, 'Present'),
      AttendanceStatus.late => (Colors.orange, 'Late'),
      AttendanceStatus.absent => (Colors.red, 'Absent'),
      AttendanceStatus.excused => (Colors.blue, 'Excused'),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}