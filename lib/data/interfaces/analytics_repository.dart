import '../../shared/result.dart';
import '../models/analytics.dart';

/// Analytics repository contract.
///
/// Metrics are precomputed server-side (via scheduled functions) and stored
/// in a dedicated analytics collection. The client only fetches precomputed
/// aggregates — never computes them client-side.
abstract interface class AnalyticsRepository {
  /// Fetches a single metric with optional time-series data.
  Future<Result<AnalyticsMetricResult>> getMetric({
    required AnalyticsMetric metric,
    AnalyticsGranularity granularity = AnalyticsGranularity.month,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  /// Fetches multiple metrics at once (dashboard summary).
  Future<Result<List<AnalyticsMetricResult>>> getDashboardMetrics({
    List<AnalyticsMetric>? metrics,
    AnalyticsGranularity granularity = AnalyticsGranularity.month,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  /// Fetches time-series data for a specific metric.
  Future<Result<List<AnalyticsDataPoint>>> getTimeSeries({
    required AnalyticsMetric metric,
    required AnalyticsGranularity granularity,
    required DateTime dateFrom,
    required DateTime dateTo,
  });
}