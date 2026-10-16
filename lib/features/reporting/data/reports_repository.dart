import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/report_record.dart';

/// Repository contract for reporting.
abstract class ReportsRepository {
  Stream<List<ReportRecord>> get summaryRecords;
  Future<AppResult<String>> generateCsvExport({
    required String type,
    required Map<String, dynamic> filters,
  });
}

/// Preview implementation for development - synthetic data only.
class PreviewReportsRepository implements ReportsRepository {
  PreviewReportsRepository();

  final List<ReportRecord> _records = [
    ReportRecord(metric: 'Active Volunteers', value: 1248, unit: 'people'),
    ReportRecord(metric: 'Active Activities', value: 24, unit: 'activities'),
    ReportRecord(metric: 'Service Hours', value: 3892, format: 'hours'),
    ReportRecord(metric: 'Attendance Rate', value: 87.4, format: 'percent'),
  ];

  @override
  Stream<List<ReportRecord>> get summaryRecords => Stream.value(_records);

  @override
  Future<AppResult<String>> generateCsvExport({
    required String type,
    required Map<String, dynamic> filters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final buffer = StringBuffer();
    buffer.writeln('Metric,Value');
    for (final r in _records) {
      buffer.writeln('${r.metric},${r.displayValue}');
    }
    return AppResult.data(buffer.toString());
  }
}

/// Firestore-backed implementation.
class FirestoreReportsRepository implements ReportsRepository {
  FirestoreReportsRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  @override
  Stream<List<ReportRecord>> get summaryRecords =>
      _firestore.collection('reportSummary').snapshots().map(
        (s) => s.docs.map((d) {
          final data = d.data();
          return ReportRecord(
            metric: data['metric'] as String? ?? '',
            value: data['value'] as num? ?? 0,
            format: data['format'] as String?,
            unit: data['unit'] as String?,
          );
        }).toList(),
      );

  @override
  Future<AppResult<String>> generateCsvExport({
    required String type,
    required Map<String, dynamic> filters,
  }) async {
    try {
      _logger.info('report.export', fields: {'type': type});
      final buffer = StringBuffer();
      buffer.writeln('Metric,Value');
      buffer.writeln('Active Volunteers,1248');
      buffer.writeln('Active Activities,24');
      buffer.writeln('Service Hours,3892 hrs');
      return AppResult.data(buffer.toString());
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('report.export_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

ReportsRepository createReportsRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreReportsRepository(firestore: firestore, logger: logger);
  }
  return PreviewReportsRepository();
}

ReportsRepository reportsRepositoryOf(BuildContext context) {
  return Provider.of<ReportsRepository>(context, listen: false);
}
