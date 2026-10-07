import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/data/models/announcement.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

/// Card widget displaying an announcement summary.
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onTap,
  });

  final Announcement announcement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final isExpired = announcement.isExpired;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _priorityColor(announcement.priority).withAlpha(100),
          width: isExpired ? 0 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                announcement.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(
                              status: announcement.status.wire,
                              compact: false,
                            ),
                          ],
                        ),
                        if (announcement.priority != AnnouncementPriority.low) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _priorityColor(announcement.priority)
                                  .withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _priorityLabel(announcement.priority),
                              style: TextStyle(
                                color: _priorityColor(announcement.priority),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14, color: muted),
                            const SizedBox(width: 6),
                            Text(
                              'Published: ${DateHelpers.formatDate(announcement.publishAt)}',
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                          ],
                        ),
                        if (!isExpired) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.schedule_outlined,
                                  size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                'Expires: ${DateHelpers.formatDate(announcement.expiresAt)}',
                                style: TextStyle(color: muted, fontSize: 13),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.danger.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'EXPIRED',
                              style: TextStyle(
                                color: AppTheme.danger,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                announcement.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: muted, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _priorityColor(AnnouncementPriority priority) => switch (priority) {
        AnnouncementPriority.urgent => AppTheme.danger,
        AnnouncementPriority.high => const Color(0xFFB7791F),
        AnnouncementPriority.normal => AppTheme.seed,
        AnnouncementPriority.low => const Color(0xFF65736D),
      };

  static String _priorityLabel(AnnouncementPriority priority) => switch (priority) {
        AnnouncementPriority.urgent => 'URGENT',
        AnnouncementPriority.high => 'HIGH',
        AnnouncementPriority.normal => 'NORMAL',
        AnnouncementPriority.low => 'LOW',
      };
}