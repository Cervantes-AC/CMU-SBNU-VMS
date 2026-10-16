import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/reports_repository.dart';
import '../../data/models/report_record.dart';

class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel({required this.repository});

  final ReportsRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<ReportRecord> _records = [];
  String? _csvContent;

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<ReportRecord> get records => _records;
  String? get csvContent => _csvContent;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.summaryRecords.listen(
      (records) {
        _records = records;
        _status = LoadStatus.loaded;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _status = LoadStatus.error;
        _error = e is AppFailure ? e : UnknownFailure();
        notifyListeners();
      },
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> generateExport({
    required String type,
    required Map<String, dynamic> filters,
  }) async {
    _status = LoadStatus.loading;
    notifyListeners();

    final result = await repository.generateCsvExport(
      type: type,
      filters: filters,
    );
    if (result.hasData) {
      _csvContent = result.data;
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }
}

ReportsViewModel createReportsViewModel(ReportsRepository repository) {
  return ReportsViewModel(repository: repository);
}

ReportsViewModel reportsViewModelOf(BuildContext context) {
  return Provider.of<ReportsViewModel>(context, listen: false);
}
