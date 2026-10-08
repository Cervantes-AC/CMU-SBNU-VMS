import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/user_management/user_management.dart';

/// Statistics card for user management dashboard.
class UserStatisticsCard extends StatelessWidget {
  const UserStatisticsCard({
    super.key,
    required this.statistics,
  });

  final UserStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            _StatGrid(statistics: statistics),
          ],
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.statistics});

  final UserStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Total',
                value: statistics.total.toString(),
                color: const Color(0xFF65736D),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                label: 'Approved',
                value: statistics.approved.toString(),
                color: const Color(0xFF2E7D4F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                label: 'Pending',
                value: statistics.pending.toString(),
                color: const Color(0xFFB7791F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Denied',
                value: statistics.denied.toString(),
                color: const Color(0xFFB3372C),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                label: 'Suspended',
                value: statistics.suspended.toString(),
                color: const Color(0xFFB7791F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                label: 'Deactivated',
                value: statistics.deactivated.toString(),
                color: const Color(0xFF65736D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Blocked',
                value: statistics.blocked.toString(),
                color: const Color(0xFFB3372C),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                label: 'Officers',
                value: statistics.officers.toString(),
                color: const Color(0xFF2C6E9E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                label: 'Admins',
                value: statistics.admins.toString(),
                color: const Color(0xFFB3372C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}