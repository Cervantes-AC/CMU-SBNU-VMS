import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/data/models/event.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

/// Card widget displaying an event summary.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final isFull = event.isFull;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
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
                                event.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(status: event.status.wire),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: muted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.venue,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: muted, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14, color: muted),
                            const SizedBox(width: 6),
                            Text(
                              _formatDateRange(event),
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                          ],
                        ),
                        if (event.capacity != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.people_outline,
                                  size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                'Capacity: ${event.attendeesCount}/${event.capacity}',
                                style: TextStyle(
                                  color: isFull
                                      ? AppTheme.danger
                                      : muted,
                                  fontSize: 13,
                                  fontWeight: isFull ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                              if (isFull) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.danger.withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'FULL',
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
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (event.description != null && event.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  event.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted, fontSize: 13, height: 1.4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateRange(Event event) {
    final start = DateHelpers.formatDateTime(event.start);
    final end = DateHelpers.formatTime(event.end);
    if (DateHelpers.isWithin(event.start, event.start, event.end)) {
      // Same day
      return '$start – $end';
    }
    // Multi-day
    final endDate = DateHelpers.formatDateTime(event.end);
    return '$start – $endDate';
  }
}