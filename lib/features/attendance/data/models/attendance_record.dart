import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent, excused }

class AttendanceRecord {
  const AttendanceRecord({
    required this.activityId,
    required this.uid,
    required this.status,
    required this.recordedBy,
    required this.recordedAt,
    this.source = 'manual',
    this.qrPayload,
    this.correctionReason,
    this.correctedAt,
    this.correctedBy,
  });

  final String activityId;
  final String uid;
  final AttendanceStatus status;
  final String recordedBy;
  final DateTime recordedAt;
  final String source; // manual, qr
  final String? qrPayload;
  final String? correctionReason;
  final DateTime? correctedAt;
  final String? correctedBy;

  String get statusLabel => switch (status) {
    AttendanceStatus.present => 'Present',
    AttendanceStatus.absent => 'Absent',
    AttendanceStatus.excused => 'Excused',
  };

  bool get isCorrected => correctedAt != null;

  factory AttendanceRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AttendanceRecord(
      activityId: data['activityId'] as String? ?? doc.id,
      uid: data['uid'] as String? ?? '',
      status: _parseStatus(data['status']),
      recordedBy: data['recordedBy'] as String? ?? '',
      recordedAt: _parseTimestamp(data['recordedAt']) ?? DateTime.now(),
      source: data['source'] as String? ?? 'manual',
      qrPayload: data['qrPayload'] as String?,
      correctionReason: data['correctionReason'] as String?,
      correctedAt: _parseTimestamp(data['correctedAt']),
      correctedBy: data['correctedBy'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'activityId': activityId,
      'uid': uid,
      'status': status.name,
      'recordedBy': recordedBy,
      'recordedAt': recordedAt,
      'source': source,
      if (qrPayload != null) 'qrPayload': qrPayload,
      if (correctionReason != null) 'correctionReason': correctionReason,
      if (correctedAt != null) 'correctedAt': correctedAt,
      if (correctedBy != null) 'correctedBy': correctedBy,
    };
  }

  static AttendanceStatus _parseStatus(dynamic value) {
    if (value is String) {
      return AttendanceStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AttendanceStatus.present,
      );
    }
    return AttendanceStatus.present;
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
