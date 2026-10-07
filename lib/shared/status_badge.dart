import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Displays a known account/event/attendance/incident state with text plus
/// color/icon so meaning is not conveyed by color alone. Unknown values
/// show a neutral label. Contains no transition policy.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.label,
    this.compact = false,
  });

  /// Raw status wire value (e.g. 'approved', 'pending', 'canceled').
  final String status;

  /// Override label; defaults to a humanized status.
  final String? label;

  /// Icon-only presentation on narrow rows (icon + semantics still present).
  final bool compact;

  static const Map<String, IconData> _icons = {
    'approved': Icons.check_circle_rounded,
    'active': Icons.check_circle_rounded,
    'published': Icons.campaign_rounded,
    'present': Icons.how_to_reg_rounded,
    'completed': Icons.task_alt_rounded,
    'pending': Icons.hourglass_top_rounded,
    'draft': Icons.edit_note_rounded,
    'scheduled': Icons.schedule_rounded,
    'late': Icons.schedule_rounded,
    'denied': Icons.cancel_rounded,
    'suspended': Icons.pause_circle_rounded,
    'deactivated': Icons.block_rounded,
    'blocked': Icons.block_rounded,
    'rejected': Icons.cancel_rounded,
    'canceled': Icons.cancel_rounded,
    'absent': Icons.person_off_rounded,
    'closed': Icons.lock_rounded,
    'open': Icons.radio_button_checked_rounded,
    'in_progress': Icons.play_circle_rounded,
    'acknowledged': Icons.done_rounded,
  };

  static String humanize(String status) {
    if (status.isEmpty) return 'Unknown';
    final words = status.replaceAll('_', ' ').toLowerCase();
    return words[0].toUpperCase() + words.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = AppTheme.statusColor(status, brightness);
    final icon = _icons[status] ?? Icons.question_mark_rounded;
    final text = label ?? humanize(status);
    final semantics = 'Status: $text';

    if (compact) {
      return Tooltip(
        message: text,
        child: Semantics(
          label: semantics,
          child: Icon(icon, size: 16, color: color),
        ),
      );
    }

    return Semantics(
      label: semantics,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withAlpha(22),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withAlpha(70)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
