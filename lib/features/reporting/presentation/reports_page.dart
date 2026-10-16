import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    children: [
      Text(
        'Insights and analytics',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFFAA7C10),
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Service impact',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      const Text(
        'Illustrative metrics for interface review. These values do not describe actual CMU–SBNU activity.',
        style: TextStyle(color: Color(0xFF748078), height: 1.4),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF0D7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Synthetic report data · Real reports require an approved scope, bounded query, and export policy.',
          style: TextStyle(fontSize: 11, color: Color(0xFF6E581F)),
        ),
      ),
      const SizedBox(height: 14),
      const Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _ReportMetric(
            value: '124',
            label: 'Participants',
            icon: Icons.groups_outlined,
            tint: Color(0xFFE5EFE7),
            color: Color(0xFF196142),
          ),
          _ReportMetric(
            value: '386',
            label: 'Service hours',
            icon: Icons.schedule,
            tint: Color(0xFFFBF0D7),
            color: Color(0xFFA9790D),
          ),
          _ReportMetric(
            value: '12',
            label: 'Activities',
            icon: Icons.event_outlined,
            tint: Color(0xFFE6F0F3),
            color: Color(0xFF306478),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Text(
        'Hours by program',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 10),
      const _BarChart(),
      const SizedBox(height: 18),
      OutlinedButton.icon(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Report export not connected'),
            content: const Text(
              'This preview does not export volunteer data. Report scope, field allowlists, access logging, and output expiry must be approved before export is implemented.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
        icon: const Icon(Icons.file_download_outlined),
        label: const Text('Review export requirements'),
      ),
    ],
  );
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.value,
    required this.label,
    required this.icon,
    required this.tint,
    required this.color,
  });
  final String value;
  final String label;
  final IconData icon;
  final Color tint;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - 60) / 3,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Color(0xFF748078)),
            ),
          ],
        ),
      ),
    ),
  );
}

class _BarChart extends StatelessWidget {
  const _BarChart();
  static const _data = [
    ('Safety', 0.78),
    ('Environment', 0.58),
    ('Community', 0.91),
    ('Training', 0.43),
  ];

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final item in _data)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(item.$1, style: const TextStyle(fontSize: 11)),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: item.$2,
                        minHeight: 9,
                        color: const Color(0xFF27724D),
                        backgroundColor: const Color(0xFFE9EEE9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(item.$2 * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
