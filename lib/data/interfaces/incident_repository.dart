import '../../shared/result.dart';
import '../models/incident.dart';

/// Incident repository contract.
///
/// Queries are typed and paginated. Only authorized roles may create/update/assign incidents.
/// Caller does not supply actor UID — the repository derives it from the session.
abstract interface class IncidentRepository {
  /// Emits a paged list of incidents visible to the current user.
  /// Members see only their own; officers/admins see all or assigned.
  Stream<({List<Incident> items, String? nextCursor})> watchIncidents({
    String? reporterUid,
    String? assigneeUid,
    IncidentStatus? statusFilter,
    int limit = 20,
  });

  /// One-shot fetch of incidents.
  Future<Result<({List<Incident> items, String? nextCursor})>> getIncidents({
    String? reporterUid,
    String? assigneeUid,
    IncidentStatus? statusFilter,
    int limit = 20,
    String? startAfter,
  });

  /// Fetches a single incident by ID.
  Future<Result<Incident>> getIncident(String incidentId);

  /// Emits a single incident by ID (for detail screens).
  Stream<Incident?> watchIncident(String incidentId);

  /// Creates a new incident (any authenticated member).
  Future<Result<Incident>> createIncident(IncidentDraft draft);

  /// Updates an incident (reporter can update their own draft; officers/admins can update any).
  Future<Result<Incident>> updateIncident({
    required String incidentId,
    required IncidentDraft draft,
    required int expectedRevision,
  });

  /// Transitions incident status (officer/admin only).
  Future<Result<Incident>> transitionStatus({
    required String incidentId,
    required IncidentStatus newStatus,
    required int expectedRevision,
    String? resolution,
  });

  /// Assigns an incident to an officer/admin (admin only).
  Future<Result<Incident>> assignIncident({
    required String incidentId,
    required String assigneeUid,
    required int expectedRevision,
  });
}

/// Draft incident data for create/update (excludes server-generated fields).
class IncidentDraft {
  const IncidentDraft({
    required this.category,
    required this.severity,
    required this.description,
    this.location,
  });

  final IncidentCategory category;
  final IncidentSeverity severity;
  final String description;
  final String? location;
}