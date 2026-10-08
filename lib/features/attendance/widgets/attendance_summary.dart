import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/data/models/attendance.dart';

/// A summary card showing attendance statistics for an event.
///
/// Displays counts for each attendance status and total attendees.
/// Used in officer dashboards and event detail screens.
class AttendanceSummary extends StatelessWidget {
  const AttendanceSummary({
    super.key,
    required this.records,
    this.compact = false,
  });

  final List<Attendance> records;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final counts = _calculateCounts(records);
    final total = records.length;

    if (total == 0) {
      return _emptyState(context);
    }

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 16,
        vertical: compact ? 6 : 10,
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: compact ? 18 : 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Attendance Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatsRow(context, counts, total),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 16,
        vertical: compact ? 6 : 10,
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: compact ? 18 : 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'No attendance records yet',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: compact ? 13 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, _AttendanceCounts counts, int total) {
    final stats = [
      _StatItem(
        label: 'Total',
        value: total.toString(),
        color: Theme.of(context).colorScheme.primary,
        icon: Icons.people_rounded,
      ),
      _StatItem(
        label: 'Present',
        value: counts.present.toString(),
        color: Colors.green,
        icon: Icons.check_circle_outline,
      ),
      _StatItem(
        label: 'Late',
        value: counts.late.toString(),
        color: Colors.orange,
        icon: Icons.access_time_outlined,
      ),
      _StatItem(
        label: 'Absent',
        value: counts.absent.toString(),
        color: Colors.red,
        icon: Icons.cancel_outlined,
      ),
      _StatItem(
        label: 'Excused',
        value: counts.excused.toString(),
        color: Colors.blue,
        icon: Icons.event_busy_outlined,
      ),
    ];

    if (compact) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats
              .map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _CompactStatCard(stat: s),
                  ))
              .toList(),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: stats.map((s) => _StatCard(stat: s)).toList(),
    );
  }

  _AttendanceCounts _calculateCounts(List<Attendance> records) {
    var present = 0;
    var late = 0;
    var absent = 0;
    var excused = 0;

    for (final r in records) {
      switch (r.status) {
        case AttendanceStatus.present:
          present++;
        case AttendanceStatus.late:
          late++;
        case AttendanceStatus.absent:
          absent++;
        case AttendanceStatus.excused:
          excused++;
      }
    }

    return _AttendanceCounts(
      present: present,
      late: late,
      absent: absent,
      excused: excused,
    );
  }
}

class _AttendanceCounts {
  const _AttendanceCounts({
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  final int present;
  final int late;
  final int absent;
  final int excused;
}

class _StatItem {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _StatItem stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: stat.color.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: stat.color.withAlpha(50)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(stat.icon, color: stat.color, size: 24),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: TextStyle(
              color: stat.color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompactStatCard extends StatelessWidget {
  const _CompactStatCard({required this.stat});

  final _StatItem stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: stat.color.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: stat.color.withAlpha(50)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(stat.icon, color: stat.color, size: 18),
          const SizedBox(height: 4),
          Text(
            stat.value,
            style: TextStyle(
              color: stat.color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            stat.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}