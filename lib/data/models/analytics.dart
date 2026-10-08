/// Analytics metric type.
enum AnalyticsMetric {
  totalMembers('total_members'),
  activeMembers('active_members'),
  totalEvents('total_events'),
  eventsThisMonth('events_this_month'),
  totalIncidents('total_incidents'),
  incidentsThisMonth('incidents_this_month'),
  attendanceRate('attendance_rate'),
  averageAttendance('average_attendance'),
  totalServiceHours('total_service_hours'),
  serviceHoursThisMonth('service_hours_this_month'),
  incidentResolutionRate('incident_resolution_rate'),
  averageResolutionTimeHours('average_resolution_time_hours');

  const AnalyticsMetric(this.wire);
  final String wire;

  static AnalyticsMetric? tryParse(String? raw) {
    if (raw == null) return null;
    for (final m in AnalyticsMetric.values) {
      if (m.wire == raw) return m;
    }
    return null;
  }
}

/// Time granularity for analytics.
enum AnalyticsGranularity {
  day('day'),
  week('week'),
  month('month'),
  year('year');

  const AnalyticsGranularity(this.wire);
  final String wire;

  static AnalyticsGranularity? tryParse(String? raw) {
    if (raw == null) return null;
    for (final g in AnalyticsGranularity.values) {
      if (g.wire == raw) return g;
    }
    return null;
  }
}

/// Analytics data point.
class AnalyticsDataPoint {
  const AnalyticsDataPoint({
    required this.timestamp,
    required this.value,
  });

  final DateTime timestamp;
  final double value;
}

/// Analytics metric result.
class AnalyticsMetricResult {
  const AnalyticsMetricResult({
    required this.metric,
    required this.currentValue,
    this.previousValue,
    this.changePercent,
    this.dataPoints = const [],
  });

  final AnalyticsMetric metric;
  final double currentValue;
  final double? previousValue;
  final double? changePercent;
  final List<AnalyticsDataPoint> dataPoints;

  bool get hasComparison => previousValue != null;
}