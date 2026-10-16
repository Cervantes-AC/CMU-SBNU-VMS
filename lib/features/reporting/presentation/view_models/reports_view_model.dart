import 'package:flutter/foundation.dart';

import '../../data/models/report_record.dart';
import '../../data/reports_repository.dart';

class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel(this._repository);

  static const programs = [
    'All programs',
    'Safety',
    'Environment',
    'Community',
    'Training',
  ];

  final ReportsRepository _repository;
  String _program = 'All programs';
  ReportDateRange _dateRange = ReportDateRange.last90Days;

  String get program => _program;
  ReportDateRange get dateRange => _dateRange;

  List<ReportRecord> get filteredRecords {
    final now = DateTime.now();
    final cutoff = switch (_dateRange) {
      ReportDateRange.last30Days => now.subtract(const Duration(days: 30)),
      ReportDateRange.last90Days => now.subtract(const Duration(days: 90)),
      ReportDateRange.allTime => DateTime(2000),
    };
    return _repository.records
        .where(
          (record) =>
              !record.date.isBefore(cutoff) &&
              (_program == 'All programs' || record.program == _program),
        )
        .toList();
  }

  int get participations =>
      filteredRecords.fold(0, (total, record) => total + record.participations);

  int get serviceHours =>
      filteredRecords.fold(0, (total, record) => total + record.serviceHours);

  Map<String, int> get hoursByProgram {
    final result = <String, int>{};
    for (final record in filteredRecords) {
      result.update(
        record.program,
        (hours) => hours + record.serviceHours,
        ifAbsent: () => record.serviceHours,
      );
    }
    return result;
  }

  void setProgram(String value) {
    if (_program == value || !programs.contains(value)) return;
    _program = value;
    notifyListeners();
  }

  void setDateRange(ReportDateRange value) {
    if (_dateRange == value) return;
    _dateRange = value;
    notifyListeners();
  }
}
