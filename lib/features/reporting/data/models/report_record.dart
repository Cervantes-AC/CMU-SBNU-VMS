class ReportRecord {
  const ReportRecord({
    required this.metric,
    required this.value,
    this.format,
    this.unit,
  });

  final String metric;
  final num value;
  final String? format;
  final String? unit;

  String get displayValue {
    if (format == 'percent') return '${value}%';
    if (format == 'hours') return '${value} hrs';
    if (format == 'currency') return '₱${value}';
    return value.toString();
  }
}
