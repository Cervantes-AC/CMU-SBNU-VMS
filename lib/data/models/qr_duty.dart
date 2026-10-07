import 'package:cloud_firestore/cloud_firestore.dart';

/// QR Duty session status.

/// QR Duty session status.
enum QRDutySessionStatus {
  active('active'),
  expired('expired'),
  cancelled('cancelled');

  const QRDutySessionStatus(this.wire);
  final String wire;

  static QRDutySessionStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in QRDutySessionStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

/// QR Duty action (check-in or check-out).
enum QRDutyAction {
  checkIn('check_in'),
  checkOut('check_out');

  const QRDutyAction(this.wire);
  final String wire;

  static QRDutyAction? tryParse(String? raw) {
    if (raw == null) return null;
    for (final a in QRDutyAction.values) {
      if (a.wire == raw) return a;
    }
    return null;
  }
}

/// QR Duty scan result.
enum QRDutyScanResult {
  success('success'),
  invalidToken('invalid_token'),
  expiredSession('expired_session'),
  duplicateScan('duplicate_scan'),
  wrongAction('wrong_action'),
  sessionNotActive('session_not_active');

  const QRDutyScanResult(this.wire);
  final String wire;

  static QRDutyScanResult? tryParse(String? raw) {
    if (raw == null) return null;
    for (final r in QRDutyScanResult.values) {
      if (r.wire == raw) return r;
    }
    return null;
  }
}

/// QR Duty session model.
class QRDutySession {
  const QRDutySession({
    required this.sessionId,
    required this.eventId,
    required this.createdBy,
    required this.startsAt,
    required this.expiresAt,
    required this.status,
    required this.tokenDigest,
    required this.maxScansPerMember,
    required this.allowedActions,
    required this.createdAt,
    required this.updatedAt,
    this.revision = 0,
    this.schemaVersion = 1,
  });

  final String sessionId;
  final String eventId;
  final String createdBy;
  final DateTime startsAt;
  final DateTime expiresAt;
  final QRDutySessionStatus status;
  final String tokenDigest; // SHA-256 hash of the token (never store raw token)
  final int maxScansPerMember;
  final List<QRDutyAction> allowedActions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int revision;
  final int schemaVersion;

  bool get isActive =>
      status == QRDutySessionStatus.active &&
      DateTime.now().toUtc().isAfter(startsAt.toUtc()) &&
      DateTime.now().toUtc().isBefore(expiresAt.toUtc());

  factory QRDutySession.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return QRDutySession(
      sessionId: doc.id,
      eventId: data['eventId'] as String,
      createdBy: data['createdBy'] as String,
      startsAt: (data['startsAt'] as Timestamp).toDate().toUtc(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate().toUtc(),
      status: QRDutySessionStatus.tryParse(data['status'] as String?) ?? QRDutySessionStatus.active,
      tokenDigest: data['tokenDigest'] as String,
      maxScansPerMember: data['maxScansPerMember'] as int? ?? 1,
      allowedActions: (data['allowedActions'] as List<dynamic>?)
              ?.map((e) => QRDutyAction.tryParse(e as String?) ?? QRDutyAction.checkIn)
              .toList() ??
          [QRDutyAction.checkIn],
      createdAt: (data['createdAt'] as Timestamp).toDate().toUtc(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate().toUtc(),
      revision: data['revision'] as int? ?? 0,
      schemaVersion: data['schemaVersion'] as int? ?? 1,
    );
  }
}

/// QR Duty scan record model.
class QRDutyScan {
  const QRDutyScan({
    required this.scanId,
    required this.sessionId,
    required this.eventId,
    required this.uid,
    required this.action,
    required this.serverTime,
    required this.result,
    this.revision = 0,
    this.schemaVersion = 1,
  });

  final String scanId;
  final String sessionId;
  final String eventId;
  final String uid;
  final QRDutyAction action;
  final DateTime serverTime;
  final QRDutyScanResult result;
  final int revision;
  final int schemaVersion;

  factory QRDutyScan.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return QRDutyScan(
      scanId: doc.id,
      sessionId: data['sessionId'] as String,
      eventId: data['eventId'] as String,
      uid: data['uid'] as String,
      action: QRDutyAction.tryParse(data['action'] as String?) ?? QRDutyAction.checkIn,
      serverTime: (data['serverTime'] as Timestamp).toDate().toUtc(),
      result: QRDutyScanResult.tryParse(data['result'] as String?) ?? QRDutyScanResult.success,
      revision: data['revision'] as int? ?? 0,
      schemaVersion: data['schemaVersion'] as int? ?? 1,
    );
  }
}