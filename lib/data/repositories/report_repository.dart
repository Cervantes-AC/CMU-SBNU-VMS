import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../shared/result.dart';
import '../interfaces/report_repository.dart';
import '../models/report.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for reports.
class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _reportsCollection() =>
      _firestore.instance.collection(FirestorePaths.reports);

  CollectionReference<Map<String, dynamic>> _reportRequestsCollection() =>
      _firestore.instance.collection(FirestorePaths.reportRequests);

  @override
  Future<Result<String>> requestReport(ReportRequest request) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }

      // Validate date range
      if (request.dateTo.isBefore(request.dateFrom) || request.dateTo.isAtSameMomentAs(request.dateFrom)) {
        return Failure(ValidationException(
            message: 'End date must be after start date.',
            fieldErrors: {'dateTo': 'End date must be after start date.'}));
      }

      final now = DateTime.now().toUtc();
      final requestId = _firestore.instance.collection(FirestorePaths.reportRequests).doc().id;

      await _reportRequestsCollection().doc(requestId).set({
        'requestId': requestId,
        'requestedBy': uid,
        'type': request.type.wire,
        'format': request.format.wire,
        'dateFrom': Timestamp.fromDate(request.dateFrom.toUtc()),
        'dateTo': Timestamp.fromDate(request.dateTo.toUtc()),
        'eventIds': request.eventIds ?? [],
        'memberIds': request.memberIds ?? [],
        'officerIds': request.officerIds ?? [],
        'status': 'pending',
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'revision': 0,
        'schemaVersion': 1,
      });

      return Success(requestId);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<ReportResult>> getReportStatus(String reportId) async {
    try {
      if (!FirestorePaths.isValidDocId(reportId)) {
        return Failure(NotFoundException(resource: 'Report'));
      }

      final doc = await _reportsCollection().doc(reportId).get();
      if (!doc.exists) {
        // Check if still in request queue
        final requestDoc = await _reportRequestsCollection().doc(reportId).get();
        if (!requestDoc.exists) {
          return Failure(NotFoundException(resource: 'Report'));
        }
        final requestData = requestDoc.data()!;
        return Success(ReportResult(
          type: ReportType.tryParse(requestData['type'] as String?) ?? ReportType.attendanceSummary,
          format: ReportFormat.tryParse(requestData['format'] as String?) ?? ReportFormat.pdf,
          generatedAt: DateTime.now().toUtc(),
          recordCount: 0,
          downloadUrl: null,
          expiresAt: null,
        ));
      }

      final report = ReportResult.fromFirestore(doc);
      return Success(report);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<({List<ReportResult> items, String? nextCursor})>> getReportHistory({
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }

      var query = _reportsCollection()
          .where('requestedBy', isEqualTo: uid)
          .orderBy('generatedAt', descending: true)
          .limit(limit + 1);

      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final reports = <ReportResult>[];
      for (final doc in snapshot.docs) {
        try {
          reports.add(ReportResult.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = reports.length > limit;
      final items = hasMore ? reports.sublist(0, limit) : reports;
      final nextCursor = hasMore
          ? items.last.generatedAt.millisecondsSinceEpoch.toString()
          : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<void>> deleteReport(String reportId) async {
    try {
      final uid = _currentUid;
      if (uid == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(reportId)) {
        return Failure(PermissionDeniedException());
      }

      final doc = await _reportsCollection().doc(reportId).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Report'));
      }
      final report = ReportResult.fromFirestore(doc);
      if (report.requestedBy != uid) {
        // In a real implementation, check if user is admin
        return Failure(PermissionDeniedException());
      }

      await _reportsCollection().doc(reportId).delete();
      return const Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}