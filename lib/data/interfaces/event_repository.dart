import '../../shared/result.dart';
import '../models/event.dart';

/// Event repository contract.
///
/// All queries are typed and paginated; no unbounded collection downloads.
/// Caller does not supply actor UID — the repository derives it from the session.
abstract interface class EventRepository {
  /// Emits a paged list of published events visible to the current user.
  /// Filter by audience/role; ordering is by start date ascending.
  Stream<({List<Event> items, String? nextCursor})> watchEvents({
    String? audienceFilter,
    int limit = 20,
  });

  /// One-shot fetch of published events.
  Future<Result<({List<Event> items, String? nextCursor})>> getEvents({
    String? audienceFilter,
    int limit = 20,
    String? startAfter,
  });

  /// Fetches a single event by ID.
  Future<Result<Event>> getEvent(String eventId);

  /// Emits a single event by ID (for detail screens).
  Stream<Event?> watchEvent(String eventId);

  /// Creates a new event (officer/admin only). Returns the created event with server-generated ID.
  Future<Result<Event>> createEvent(EventDraft draft);

  /// Updates an existing event (officer/admin only). Optimistic concurrency via revision.
  Future<Result<Event>> updateEvent({
    required String eventId,
    required EventDraft draft,
    required int expectedRevision,
  });

  /// Cancels an event (officer/admin only).
  Future<Result<void>> cancelEvent(String eventId, {required int expectedRevision});

  /// Member requests to join an event. One request per (event, uid) pair.
  Future<Result<void>> requestJoin(String eventId);

  /// Officer/admin reviews a join request.
  Future<Result<void>> reviewJoinRequest({
    required String eventId,
    required String requesterUid,
    required JoinRequestDecision decision,
  });

  /// Gets the current user's join request status for an event.
  Future<Result<JoinRequestStatus?>> getJoinRequestStatus(String eventId);
}

/// Draft event data for create/update (excludes server-generated fields).
class EventDraft {
  const EventDraft({
    required this.title,
    required this.venue,
    required this.start,
    required this.end,
    this.description,
    this.capacity,
    this.audience = EventAudience.all,
    this.imageUrl,
    this.isFeatured = false,
  });

  final String title;
  final String venue;
  final DateTime start;
  final DateTime end;
  final String? description;
  final int? capacity;
  final EventAudience audience;
  final String? imageUrl;
  final bool isFeatured;
}

/// Join request decision.
enum JoinRequestDecision {
  approved('approved'),
  denied('denied');

  const JoinRequestDecision(this.wire);
  final String wire;
}

/// Current user's join request status for an event.
enum JoinRequestStatus {
  none('none'),
  pending('pending'),
  approved('approved'),
  denied('denied'),
  waitlisted('waitlisted');

  const JoinRequestStatus(this.wire);
  final String wire;

  static JoinRequestStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in JoinRequestStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}