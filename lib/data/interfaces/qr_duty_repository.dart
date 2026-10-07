import '../../shared/result.dart';
import '../models/qr_duty.dart';

/// QR Duty repository contract.
///
/// Token digests are validated server-side; raw tokens never leave the client.
/// Sessions and scans are validated against server time.
abstract interface class QRDutyRepository {
  /// Emits a paged list of QR duty sessions for an event (officer/admin only).
  Stream<({List<QRDutySession> items, String? nextCursor})> watchEventSessions({
    required String eventId,
    int limit = 20,
  });

  /// One-shot fetch of QR duty sessions for an event.
  Future<Result<({List<QRDutySession> items, String? nextCursor})>> getEventSessions({
    required String eventId,
    int limit = 20,
    String? startAfter,
  });

  /// Fetches a single session by ID.
  Future<Result<QRDutySession>> getSession(String sessionId);

  /// Emits a single session by ID (for monitoring screens).
  Stream<QRDutySession?> watchSession(String sessionId);

  /// Creates a new QR duty session (officer/admin only).
  /// Returns the session with the raw token (only time it's exposed).
  Future<Result<({QRDutySession session, String rawToken})>> createSession({
    required String eventId,
    required DateTime startsAt,
    required DateTime expiresAt,
    int maxScansPerMember = 1,
    List<QRDutyAction> allowedActions = const [QRDutyAction.checkIn],
  });

  /// Cancels a session (officer/admin only).
  Future<Result<void>> cancelSession(String sessionId, {required int expectedRevision});

  /// Validates a scan attempt. Returns the scan record with result.
  /// This is the core validation logic - server-side time, replay checks, capacity checks.
  Future<Result<QRDutyScan>> validateScan({
    required String sessionId,
    required String rawToken,
    required QRDutyAction action,
  });

  /// Emits scans for a session (officer/admin monitoring).
  Stream<({List<QRDutyScan> items, String? nextCursor})> watchSessionScans({
    required String sessionId,
    int limit = 50,
  });

  /// One-shot fetch of scans for a session.
  Future<Result<({List<QRDutyScan> items, String? nextCursor})>> getSessionScans({
    required String sessionId,
    int limit = 50,
    String? startAfter,
  });
}