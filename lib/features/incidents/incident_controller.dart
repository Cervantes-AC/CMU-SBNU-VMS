import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/incident_repository.dart';
import '../../data/models/incident.dart';
import '../../shared/app_feedback.dart';

/// Immutable incidents view state.
class IncidentsViewState {
  const IncidentsViewState({
    this.loading = false,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
    this.selectedStatusFilter,
  });

  final bool loading;
  final List<Incident> items;
  final String? nextCursor;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;
  final IncidentStatus? selectedStatusFilter;

  IncidentsViewState copyWith({
    bool? loading,
    List<Incident>? items,
    String? nextCursor,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    IncidentStatus? selectedStatusFilter,
    bool clearError = false,
  }) => IncidentsViewState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
        selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      );

  @override
  bool operator ==(Object other) =>
      other is IncidentsViewState &&
      other.loading == loading &&
      listEquals(other.items, items) &&
      other.nextCursor == nextCursor &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.hasMore == hasMore &&
      other.selectedStatusFilter == selectedStatusFilter;

  @override
  int get hashCode => Object.hash(
        loading,
        items,
        nextCursor,
        errorMessage,
        failureCategory,
        hasMore,
        selectedStatusFilter,
      );
}

/// Coordinates incidents loading and management against [IncidentRepository].
class IncidentsController extends ChangeNotifier {
  IncidentsController({required IncidentRepository incidentRepository})
      : _incidentRepository = incidentRepository;

  final IncidentRepository _incidentRepository;

  IncidentsViewState _state = const IncidentsViewState();
  IncidentsViewState get state => _state;

  bool _disposed = false;

  void _update(IncidentsViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the first page of incidents.
  Future<void> load({
    String? reporterUid,
    String? assigneeUid,
    IncidentStatus? statusFilter,
  }) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _incidentRepository.getIncidents(
        reporterUid: reporterUid,
        assigneeUid: assigneeUid,
        statusFilter: statusFilter,
      );
      if (_disposed) return;
      result.when(
        success: (data) => _update(_state.copyWith(
              loading: false,
              items: data.items,
              nextCursor: data.nextCursor,
              hasMore: data.nextCursor != null,
              selectedStatusFilter: statusFilter,
              clearError: true,
            )),
        failure: (error) => _update(_state.copyWith(
              loading: false,
              errorMessage: AppFeedback.messageFor(error),
              failureCategory: error.category,
            )),
      );
    } catch (error, st) {
      if (_disposed) return;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        loading: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  /// Loads the next page of incidents.
  Future<void> loadMore({
    String? reporterUid,
    String? assigneeUid,
    IncidentStatus? statusFilter,
  }) async {
    if (_state.loading || !_state.hasMore || _state.nextCursor == null) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _incidentRepository.getIncidents(
        reporterUid: reporterUid,
        assigneeUid: assigneeUid,
        statusFilter: statusFilter,
        startAfter: _state.nextCursor,
      );
      if (_disposed) return;
      result.when(
        success: (data) => _update(_state.copyWith(
              loading: false,
              items: [..._state.items, ...data.items],
              nextCursor: data.nextCursor,
              hasMore: data.nextCursor != null,
              clearError: true,
            )),
        failure: (error) => _update(_state.copyWith(
              loading: false,
              errorMessage: AppFeedback.messageFor(error),
              failureCategory: error.category,
            )),
      );
    } catch (error, st) {
      if (_disposed) return;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        loading: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  /// Creates a new incident.
  Future<bool> createIncident({
    required String category,
    required String severity,
    required String description,
    String? location,
  }) async {
    if (_state.loading) return false;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _incidentRepository.createIncident(
        IncidentDraft(
          category: IncidentCategory.tryParse(category) ?? IncidentCategory.other,
          severity: IncidentSeverity.tryParse(severity) ?? IncidentSeverity.medium,
          description: description,
          location: location,
        ),
      );
      if (_disposed) return false;
      return result.when(
        success: (_) {
          _update(_state.copyWith(loading: false, clearError: true));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            loading: false,
            errorMessage: AppFeedback.messageFor(error),
            failureCategory: error.category,
          ));
          return false;
        },
      );
    } catch (error, st) {
      if (_disposed) return false;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        loading: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
      return false;
    }
  }

  /// Clears transient messages.
  void clearError() {
    if (_disposed) return;
    if (_state.errorMessage == null) return;
    _update(_state.copyWith(clearError: true));
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Immutable incident detail view state.
class IncidentDetailViewState {
  const IncidentDetailViewState({
    this.loading = false,
    this.incident,
    this.errorMessage,
    this.failureCategory,
    this.updating = false,
  });

  final bool loading;
  final Incident? incident;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool updating;

  IncidentDetailViewState copyWith({
    bool? loading,
    Incident? incident,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? updating,
    bool clearError = false,
  }) => IncidentDetailViewState(
        loading: loading ?? this.loading,
        incident: incident ?? this.incident,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        updating: updating ?? this.updating,
      );

  @override
  bool operator ==(Object other) =>
      other is IncidentDetailViewState &&
      other.loading == loading &&
      other.incident == incident &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.updating == updating;

  @override
  int get hashCode =>
      Object.hash(loading, incident, errorMessage, failureCategory, updating);
}

/// Coordinates a single incident's detail, updates, and status transitions.
class IncidentDetailController extends ChangeNotifier {
  IncidentDetailController({required IncidentRepository incidentRepository})
      : _incidentRepository = incidentRepository;

  final IncidentRepository _incidentRepository;

  IncidentDetailViewState _state = const IncidentDetailViewState();
  IncidentDetailViewState get state => _state;

  bool _disposed = false;

  void _update(IncidentDetailViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads a single incident by ID.
  Future<void> load(String incidentId) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _incidentRepository.getIncident(incidentId);
      if (_disposed) return;
      result.when(
        success: (incident) => _update(_state.copyWith(
              loading: false,
              incident: incident,
              clearError: true,
            )),
        failure: (error) => _update(_state.copyWith(
              loading: false,
              errorMessage: AppFeedback.messageFor(error),
              failureCategory: error.category,
            )),
      );
    } catch (error, st) {
      if (_disposed) return;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        loading: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  /// Updates incident fields (reporter only for their own open incidents).
  Future<bool> update({
    required String incidentId,
    required String category,
    required String severity,
    required String description,
    String? location,
  }) async {
    if (_state.updating) return false;
    _update(_state.copyWith(updating: true, clearError: true));
    try {
      final result = await _incidentRepository.updateIncident(
        incidentId: incidentId,
        draft: IncidentDraft(
          category: IncidentCategory.tryParse(category) ?? IncidentCategory.other,
          severity: IncidentSeverity.tryParse(severity) ?? IncidentSeverity.medium,
          description: description,
          location: location,
        ),
        // In practice, fetch current revision from state.incident.revision
        expectedRevision: _state.incident?.revision ?? 0,
      );
      if (_disposed) return false;
      return result.when(
        success: (incident) {
          _update(_state.copyWith(
            updating: false,
            incident: incident,
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            updating: false,
            errorMessage: AppFeedback.messageFor(error),
            failureCategory: error.category,
          ));
          return false;
        },
      );
    } catch (error, st) {
      if (_disposed) return false;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        updating: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
      return false;
    }
  }

  /// Transitions incident status (officer/admin).
  Future<bool> transitionStatus({
    required String incidentId,
    required String newStatus,
    String? resolution,
  }) async {
    if (_state.updating) return false;
    _update(_state.copyWith(updating: true, clearError: true));
    try {
      final result = await _incidentRepository.transitionStatus(
        incidentId: incidentId,
        newStatus: IncidentStatus.tryParse(newStatus) ?? IncidentStatus.open,
        expectedRevision: _state.incident?.revision ?? 0,
        resolution: resolution,
      );
      if (_disposed) return false;
      return result.when(
        success: (incident) {
          _update(_state.copyWith(
            updating: false,
            incident: incident,
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            updating: false,
            errorMessage: AppFeedback.messageFor(error),
            failureCategory: error.category,
          ));
          return false;
        },
      );
    } catch (error, st) {
      if (_disposed) return false;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        updating: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
      return false;
    }
  }

  /// Assigns incident to another user (admin only).
  Future<bool> assign({
    required String incidentId,
    required String assigneeUid,
  }) async {
    if (_state.updating) return false;
    _update(_state.copyWith(updating: true, clearError: true));
    try {
      final result = await _incidentRepository.assignIncident(
        incidentId: incidentId,
        assigneeUid: assigneeUid,
        expectedRevision: _state.incident?.revision ?? 0,
      );
      if (_disposed) return false;
      return result.when(
        success: (incident) {
          _update(_state.copyWith(
            updating: false,
            incident: incident,
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            updating: false,
            errorMessage: AppFeedback.messageFor(error),
            failureCategory: error.category,
          ));
          return false;
        },
      );
    } catch (error, st) {
      if (_disposed) return false;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        updating: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
      return false;
    }
  }

  /// Clears transient messages.
  void clearError() {
    if (_disposed) return;
    if (_state.errorMessage == null) return;
    _update(_state.copyWith(clearError: true));
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}