import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/data/models/attendance.dart';

/// A compact dropdown/button picker for selecting attendance status.
///
/// Shows the current status with a colored badge. Tapping opens a menu
/// to select a new status. The [onChanged] callback receives the new status.
class AttendanceStatusPicker extends StatelessWidget {
  const AttendanceStatusPicker({
    super.key,
    required this.currentStatus,
    required this.onChanged,
    this.compact = false,
    this.tooltip = 'Change attendance status',
  });

  final AttendanceStatus currentStatus;
  final ValueChanged<AttendanceStatus> onChanged;
  final bool compact;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(currentStatus);
    return Tooltip(
      message: tooltip,
      child: PopupMenuButton<AttendanceStatus>(
        onSelected: onChanged,
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) {
          return [
            for (final status in AttendanceStatus.values)
              PopupMenuItem<AttendanceStatus>(
                value: status,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _statusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(_statusLabel(status)),
                  ],
                ),
              ),
          ];
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 10,
            vertical: compact ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(20),
            borderRadius: BorderRadius.circular(compact ? 10 : 12),
            border: Border.all(color: statusColor.withAlpha(70)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _statusLabel(currentStatus),
                style: TextStyle(
                  color: statusColor,
                  fontSize: compact ? 10 : 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: compact ? 14 : 16,
                color: statusColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _statusColor(AttendanceStatus status) => switch (status) {
        AttendanceStatus.present => Colors.green,
        AttendanceStatus.late => Colors.orange,
        AttendanceStatus.absent => Colors.red,
        AttendanceStatus.excused => Colors.blue,
      };

  static String _statusLabel(AttendanceStatus status) => switch (status) {
        AttendanceStatus.present => 'Present',
        AttendanceStatus.late => 'Late',
        AttendanceStatus.absent => 'Absent',
        AttendanceStatus.excused => 'Excused',
      };
}