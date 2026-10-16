class ReportRecord {
  const ReportRecord({
    required this.date,
    required this.program,
    required this.participations,
    required this.serviceHours,
  });

  final DateTime date;
  final String program;
  final int participations;
  final int serviceHours;
}

enum ReportDateRange { last30Days, last90Days, allTime }

extension ReportDateRangeLabel on ReportDateRange {
  String get label => switch (this) {
    ReportDateRange.last30Days => 'Last 30 days',
    ReportDateRange.last90Days => 'Last 90 days',
    ReportDateRange.allTime => 'All sample records',
  };
}
