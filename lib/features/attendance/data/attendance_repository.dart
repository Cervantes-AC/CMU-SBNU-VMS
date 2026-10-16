import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/attendance_record.dart';

/// Repository contract for attendance.
abstract class AttendanceRepository {
  Stream<List<AttendanceRecord>> getAttendanceForActivity(String activityId);
  Stream<List<AttendanceRecord>> getMyAttendance(String uid);
  Future<AppResult<void>> recordAttendance(AttendanceRecord record);
  Future<AppResult<void>> correctAttendance(
    String activityId,
    String uid, {
    required String newStatus,
    required String reason,
    required String correctedBy,
  });
  Stream<List<AttendanceRecord>> getAllAttendance();
}

/// Preview implementation for development.
class PreviewAttendanceRepository implements AttendanceRepository {
  PreviewAttendanceRepository();

  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      activityId: 'act_001',
      uid: 'vol_001',
      status: AttendanceStatus.present,
      recordedBy: 'staff_001',
      recordedAt: DateTime(2026, 11, 5, 8, 30),
      source: 'manual',
    ),
    AttendanceRecord(
      activityId: 'act_001',
      uid: 'vol_002',
      status: AttendanceStatus.present,
      recordedBy: 'staff_001',
      recordedAt: DateTime(2026, 11, 5, 8, 35),
      source: 'manual',
    ),
  ];

  @override
  Stream<List<AttendanceRecord>> getAttendanceForActivity(String activityId) =>
      Stream.value(_records.where((r) => r.activityId == activityId).toList());

  @override
  Stream<List<AttendanceRecord>> getMyAttendance(String uid) =>
      Stream.value(_records.where((r) => r.uid == uid).toList());

  @override
  Future<AppResult<void>> recordAttendance(AttendanceRecord record) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _records.add(record);
    return const AppResult.data(null);
  }

  @override
  Future<AppResult<void>> correctAttendance(
    String activityId,
    String uid, {
    required String newStatus,
    required String reason,
    required String correctedBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _records.indexWhere(
      (r) => r.activityId == activityId && r.uid == uid,
    );
    if (idx >= 0) {
      final old = _records[idx];
      _records[idx] = AttendanceRecord(
        activityId: old.activityId,
        uid: old.uid,
        status: newStatus == 'present'
            ? AttendanceStatus.present
            : AttendanceStatus.absent,
        recordedBy: old.recordedBy,
        recordedAt: old.recordedAt,
        source: old.source,
        correctionReason: reason,
        correctedAt: DateTime.now(),
        correctedBy: correctedBy,
      );
      return const AppResult.data(null);
    }
    return AppResult.error(
      const NotFoundFailure(message: 'Attendance record not found.'),
    );
  }

  @override
  Stream<List<AttendanceRecord>> getAllAttendance() => Stream.value(_records);
}

/// Firestore-backed implementation.
class FirestoreAttendanceRepository implements AttendanceRepository {
  FirestoreAttendanceRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  @override
  Stream<List<AttendanceRecord>> getAttendanceForActivity(String activityId) =>
      _firestore
          .collection('activities')
          .doc(activityId)
          .collection('attendance')
          .snapshots()
          .map(
            (s) =>
                s.docs.map((d) => AttendanceRecord.fromFirestore(d)).toList(),
          );

  @override
  Stream<List<AttendanceRecord>> getMyAttendance(String uid) => _firestore
      .collectionGroup('attendance')
      .where('uid', isEqualTo: uid)
      .orderBy('recordedAt', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => AttendanceRecord.fromFirestore(d)).toList(),
      );

  @override
  Future<AppResult<void>> recordAttendance(AttendanceRecord record) async {
    try {
      await _firestore
          .collection('activities')
          .doc(record.activityId)
          .collection('attendance')
          .doc(record.uid)
          .set(record.toFirestore());
      _logger.info(
        'attendance.recorded',
        fields: {'activityId': record.activityId, 'uid': record.uid},
      );
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('attendance.record_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> correctAttendance(
    String activityId,
    String uid, {
    required String newStatus,
    required String reason,
    required String correctedBy,
  }) async {
    try {
      final ref = _firestore
          .collection('activities')
          .doc(activityId)
          .collection('attendance')
          .doc(uid);
      await ref.update({
        'status': newStatus,
        'correctionReason': reason,
        'correctedAt': FieldValue.serverTimestamp(),
        'correctedBy': correctedBy,
      });
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('attendance.correct_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Stream<List<AttendanceRecord>> getAllAttendance() => _firestore
      .collectionGroup('attendance')
      .snapshots()
      .map(
        (s) => s.docs.map((d) => AttendanceRecord.fromFirestore(d)).toList(),
      );
}

AttendanceRepository createAttendanceRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreAttendanceRepository(firestore: firestore, logger: logger);
  }
  return PreviewAttendanceRepository();
}

AttendanceRepository attendanceRepositoryOf(BuildContext context) {
  return Provider.of<AttendanceRepository>(context, listen: false);
}
