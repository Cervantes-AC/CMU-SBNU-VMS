import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../shared/result.dart';
import '../interfaces/analytics_repository.dart';
import '../models/analytics.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads for analytics metrics.
///
/// Metrics are precomputed by server-side scheduled functions and stored in
/// the analytics collection. This repository only reads — never writes.
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _analyticsCollection() =>
      _firestore.instance.collection(FirestorePaths.analytics);

  @override
  Future<Result<AnalyticsMetricResult>> getMetric({
    required AnalyticsMetric metric,
    AnalyticsGranularity granularity = AnalyticsGranularity.month,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }

      // Build query for the specific metric
      var query = _analyticsCollection()
          .where('metric', isEqualTo: metric.wire)
          .where('granularity', isEqualTo: granularity.wire)
          .orderBy('timestamp', descending: true)
          .limit(1);

      if (dateFrom != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(dateFrom.toUtc()));
      }
      if (dateTo != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(dateTo.toUtc()));
      }

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        return Success(AnalyticsMetricResult(
          metric: metric,
          currentValue: 0,
          dataPoints: [],
        ));
      }

      final doc = snapshot.docs.first;
      final data = doc.data();
      final currentValue = (data['value'] as num?)?.toDouble() ?? 0;
      final previousValue = (data['previousValue'] as num?)?.toDouble();
      final changePercent = previousValue != null && previousValue != 0
          ? ((currentValue - previousValue) / previousValue) * 100
          : null;

      // Fetch historical data points for the chart
      final historyQuery = _firestore.instance
          .collection('${FirestorePaths.analytics}/${doc.id}/history')
          .orderBy('timestamp', descending: true)
          .limit(30);
      final historySnapshot = await historyQuery.get();
      final dataPoints = <AnalyticsDataPoint>[];
      for (final histDoc in historySnapshot.docs) {
        try {
          final histData = histDoc.data();
          dataPoints.add(AnalyticsDataPoint(
            timestamp: (histData['timestamp'] as Timestamp).toDate().toUtc(),
            value: (histData['value'] as num).toDouble(),
          ));
        } on FormatException {
          // Skip malformed entries.
        }
      }

      return Success(AnalyticsMetricResult(
        metric: metric,
        currentValue: currentValue,
        previousValue: previousValue,
        changePercent: changePercent,
        dataPoints: dataPoints,
      ));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<List<AnalyticsMetricResult>>> getDashboardMetrics({
    List<AnalyticsMetric>? metrics,
    AnalyticsGranularity granularity = AnalyticsGranularity.month,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }

      final requestedMetrics = metrics ?? AnalyticsMetric.values;
      final results = <AnalyticsMetricResult>[];

      for (final metric in requestedMetrics) {
        final result = await getMetric(
          metric: metric,
          granularity: granularity,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
        if (result.isSuccess) {
          results.add(result.valueOrNull!);
        } else {
          // Add zero metric for failed fetches
          results.add(AnalyticsMetricResult(
            metric: metric,
            currentValue: 0,
          ));
        }
      }

      return Success(results);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<List<AnalyticsDataPoint>>> getTimeSeries({
    required AnalyticsMetric metric,
    required AnalyticsGranularity granularity,
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }

      final query = _firestore.instance
          .collection('${FirestorePaths.analytics}/')
          .where('metric', isEqualTo: metric.wire)
          .where('granularity', isEqualTo: granularity.wire)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(dateFrom.toUtc()))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(dateTo.toUtc()))
          .orderBy('timestamp', descending: false);

      final snapshot = await query.get();
      final dataPoints = <AnalyticsDataPoint>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          dataPoints.add(AnalyticsDataPoint(
            timestamp: (data['timestamp'] as Timestamp).toDate().toUtc(),
            value: (data['value'] as num).toDouble(),
          ));
        } on FormatException {
          // Skip malformed entries.
        }
      }

      return Success(dataPoints);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}