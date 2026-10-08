import '../../shared/result.dart';
import '../models/report.dart';

/// Report repository contract.
///
/// Handles report generation, scheduling, and export. Reports are generated
/// server-side via trusted functions; the client only requests and polls for
/// completion. The client never constructs report data directly.
abstract interface class ReportRepository {
  /// Submits a report generation request. Returns a report ID for polling.
  Future<Result<String>> requestReport(ReportRequest request);

  /// Polls the status of a report generation request.
  Future<Result<ReportResult>> getReportStatus(String reportId);

  /// Gets a paginated list of past reports for the current user.
  Future<Result<({List<ReportResult> items, String? nextCursor})>> getReportHistory({
    int limit = 20,
    String? startAfter,
  });

  /// Deletes a generated report file (if permitted by retention policy).
  Future<Result<void>> deleteReport(String reportId);
}