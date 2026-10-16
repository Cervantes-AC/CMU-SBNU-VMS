import 'models/report_record.dart';

abstract interface class ReportsRepository {
  List<ReportRecord> get records;
}

class PreviewReportsRepository implements ReportsRepository {
  PreviewReportsRepository() : _records = _buildSampleRecords(DateTime.now());

  final List<ReportRecord> _records;

  @override
  List<ReportRecord> get records => List.unmodifiable(_records);
}

List<ReportRecord> _buildSampleRecords(DateTime now) {
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
      ReportRecord(
        date: now.subtract(Duration(days: sample.$4)),
        program: sample.$1,
        participations: sample.$2,
        serviceHours: sample.$3,
      ),
  ];
}
