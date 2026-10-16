import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  static const _programs = [
    'All programs',
    'Safety',
    'Environment',
    'Community',
    'Training',
  ];

  final List<_ReportRecord> _records = _sampleReports();
  String _program = 'All programs';
  _DateRange _dateRange = _DateRange.last90Days;

  List<_ReportRecord> get _filteredRecords {
    final cutoff = switch (_dateRange) {
      _DateRange.last30Days => DateTime.now().subtract(
        const Duration(days: 30),
      ),
      _DateRange.last90Days => DateTime.now().subtract(
        const Duration(days: 90),
      ),
      _DateRange.allTime => DateTime(2000),
    };
    return _records
        .where(
          (record) =>
              !record.date.isBefore(cutoff) &&
              (_program == 'All programs' || record.program == _program),
        )
        .toList();
  }

  int get _participations => _filteredRecords.fold(
    0,
    (total, record) => total + record.participations,
  );

  int get _serviceHours =>
      _filteredRecords.fold(0, (total, record) => total + record.serviceHours);

  Map<String, int> get _hoursByProgram {
    final result = <String, int>{};
    for (final record in _filteredRecords) {
      result.update(
        record.program,
        (hours) => hours + record.serviceHours,
        ifAbsent: () => record.serviceHours,
      );
    }
    return result;
  }

  Future<void> _copyCsv() async {
    final rows = <List<String>>[
      ['Filter', 'Value'],
      ['Date range', _dateRange.label],
      ['Program', _program],
      [],
      ['Metric', 'Sample value'],
      ['Volunteer participations', '$_participations'],
      ['Service hours', '$_serviceHours'],
      ['Activities', '${_filteredRecords.length}'],
      [],
      ['Activity date', 'Program', 'Participations', 'Service hours'],
      for (final record in _filteredRecords)
        [
          DateFormat('yyyy-MM-dd').format(record.date),
          record.program,
          '${record.participations}',
          '${record.serviceHours}',
        ],
    ];
    final csv = rows.map((row) => row.map(_escapeCsv).join(',')).join('\n');
    await Clipboard.setData(ClipboardData(text: '$csv\n'));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Filtered synthetic report copied as CSV.'),
        ),
      );
  }

  String _escapeCsv(String value) {
    if (!value.contains(',') && !value.contains('"') && !value.contains('\n')) {
      return value;
    }
    return '"${value.replaceAll('"', '""')}"';
  }

  @override
  Widget build(BuildContext context) {
    final hoursByProgram = _hoursByProgram;
    return ListView(
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
            'Synthetic report data · Filters and totals run locally. Real reports require an approved scope, bounded query, and export policy.',
            style: TextStyle(fontSize: 11, color: Color(0xFF6E581F)),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<_DateRange>(
          initialValue: _dateRange,
          decoration: const InputDecoration(
            labelText: 'Date range',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final value in _DateRange.values)
              DropdownMenuItem(value: value, child: Text(value.label)),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _dateRange = value);
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _program,
          decoration: const InputDecoration(
            labelText: 'Program',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final value in _programs)
              DropdownMenuItem(value: value, child: Text(value)),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _program = value);
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 520 ? 3 : 2;
            final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ReportMetric(
                  width: width,
                  value: '$_participations',
                  label: 'Volunteer participations',
                  icon: Icons.groups_outlined,
                  tint: const Color(0xFFE5EFE7),
                  color: const Color(0xFF196142),
                ),
                _ReportMetric(
                  width: width,
                  value: '$_serviceHours',
                  label: 'Service hours',
                  icon: Icons.schedule,
                  tint: const Color(0xFFFBF0D7),
                  color: const Color(0xFFA9790D),
                ),
                _ReportMetric(
                  width: width,
                  value: '${_filteredRecords.length}',
                  label: 'Activities',
                  icon: Icons.event_outlined,
                  tint: const Color(0xFFE6F0F3),
                  color: const Color(0xFF306478),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        Text(
          'Hours by program',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        if (hoursByProgram.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No synthetic records match these filters.'),
            ),
          )
        else
          _BarChart(data: hoursByProgram),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: _copyCsv,
          icon: const Icon(Icons.copy_all_outlined),
          label: const Text('Copy filtered synthetic CSV'),
        ),
      ],
    );
  }
}

enum _DateRange { last30Days, last90Days, allTime }

extension on _DateRange {
  String get label => switch (this) {
    _DateRange.last30Days => 'Last 30 days',
    _DateRange.last90Days => 'Last 90 days',
    _DateRange.allTime => 'All sample records',
  };
}

typedef _ReportRecord = ({
  DateTime date,
  String program,
  int participations,
  int serviceHours,
});

List<_ReportRecord> _sampleReports() {
  final now = DateTime.now();
  const samples = [
    ('Safety', 10, 32, 2),
    ('Environment', 12, 36, 5),
    ('Community', 8, 24, 8),
    ('Training', 9, 27, 10),
    ('Safety', 11, 33, 12),
    ('Environment', 10, 30, 14),
    ('Community', 13, 39, 16),
    ('Training', 9, 27, 20),
    ('Safety', 12, 36, 23),
    ('Environment', 10, 30, 27),
    ('Community', 11, 33, 35),
    ('Training', 9, 39, 50),
  ];
  return [
    for (final sample in samples)
      (
        date: now.subtract(Duration(days: sample.$4)),
        program: sample.$1,
        participations: sample.$2,
        serviceHours: sample.$3,
      ),
  ];
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.width,
    required this.value,
    required this.label,
    required this.icon,
    required this.tint,
    required this.color,
  });

  final double width;
  final String value;
  final String label;
  final IconData icon;
  final Color tint;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
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
  const _BarChart({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    final maxHours = data.values.reduce((a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final entry in data.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: entry.value / maxHours,
                          minHeight: 9,
                          color: const Color(0xFF27724D),
                          backgroundColor: const Color(0xFFE9EEE9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${entry.value}h',
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
}
