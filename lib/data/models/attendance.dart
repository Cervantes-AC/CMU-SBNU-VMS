import 'package:cloud_firestore/cloud_firestore.dart';

/// Attendance status wire values.
enum AttendanceStatus {
  present('present'),
  late('late'),
  absent('absent'),
  excused('excused');

  const AttendanceStatus(this.wire);
  final String wire;

  static AttendanceStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in AttendanceStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// Attendance source (how the record was created).
enum AttendanceSource {
  qrScan('qr_scan'),
  manual('manual'),
  correction('correction');

  const AttendanceSource(this.wire);
  final String wire;

  static AttendanceSource? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in AttendanceSource.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// Attendance record model.
class Attendance {
  const Attendance({
    required this.attendanceId,
    required this.eventId,
    required this.uid,
    required this.status,
    required this.source,
    required this.recordedAt,
    required this.recordedBy,
    this.correctedAt,
    this.correctedBy,
    this.revision = 0,
    this.schemaVersion = 1,
  });

  final String attendanceId;
  final String eventId;
  final String uid;
  final AttendanceStatus status;
  final AttendanceSource source;
  final DateTime recordedAt;
  final String recordedBy;
  final DateTime? correctedAt;
  final String? correctedBy;
  final int revision;
  final int schemaVersion;

  factory Attendance.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Attendance(
      attendanceId: doc.id,
      eventId: data['eventId'] as String,
      uid: data['uid'] as String,
      status: AttendanceStatus.tryParse(data['status'] as String?) ?? AttendanceStatus.present,
      source: AttendanceSource.tryParse(data['source'] as String?) ?? AttendanceSource.manual,
      recordedAt: (data['recordedAt'] as Timestamp).toDate().toUtc(),
      recordedBy: data['recordedBy'] as String,
      correctedAt: data['correctedAt'] != null
          ? (data['correctedAt'] as Timestamp).toDate().toUtc()
          : null,
      correctedBy: data['correctedBy'] as String?,
      revision: data['revision'] as int? ?? 0,
      schemaVersion: data['schemaVersion'] as int? ?? 1,
    );
  }
}