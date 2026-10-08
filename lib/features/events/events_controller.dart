import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/event_repository.dart';
import '../../data/models/event.dart';
import '../../shared/app_feedback.dart';
import '../../shared/result.dart';

/// Immutable events view state.
class EventsViewState {
  const EventsViewState({
    this.loading = false,
    this.loadingDetail = false,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
    this.selectedFilter = 'all',
    this.detail,
    this.joinRequestStatus,
  });

  final bool loading;
  final bool loadingDetail;
  final List<Event> items;
  final String? nextCursor;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;
  final String selectedFilter;
  final Event? detail;
  final JoinRequestStatus? joinRequestStatus;

  EventsViewState copyWith({
    bool? loading,
    bool? loadingDetail,
    List<Event>? items,
    String? nextCursor,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    String? selectedFilter,
    Event? detail,
    JoinRequestStatus? joinRequestStatus,
    bool clearDetail = false,
    bool clearJoinStatus = false,
    bool clearError = false,
  }) => EventsViewState(
        loading: loading ?? this.loading,
        loadingDetail: loadingDetail ?? this.loadingDetail,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
        selectedFilter: selectedFilter ?? this.selectedFilter,
        detail: clearDetail ? null : detail ?? this.detail,
        joinRequestStatus:
            clearJoinStatus ? null : joinRequestStatus ?? this.joinRequestStatus,
      );

  @override
  bool operator ==(Object other) =>
      other is EventsViewState &&
      other.loading == loading &&
      listEquals(other.items, items) &&
      other.nextCursor == nextCursor &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.hasMore == hasMore &&
      other.selectedFilter == selectedFilter;

  @override
  int get hashCode => Object.hash(
        loading,
        items,
        nextCursor,
        errorMessage,
        failureCategory,
        hasMore,
        selectedFilter,
      );
}

/// Coordinates events loading and join requests against [EventRepository].
class EventsController extends ChangeNotifier {
  EventsController({required EventRepository eventRepository})
      : _eventRepository = eventRepository;

  final EventRepository _eventRepository;

  EventsViewState _state = const EventsViewState();
  EventsViewState get state => _state;

  bool _disposed = false;

  void _update(EventsViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the first page of events.
  Future<void> load({String? audienceFilter}) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _eventRepository.getEvents(
        audienceFilter: audienceFilter,
      );
      if (_disposed) return;
      result.when(
        success: (data) => _update(_state.copyWith(
              loading: false,
              items: data.items,
              nextCursor: data.nextCursor,
              hasMore: data.nextCursor != null,
              selectedFilter: audienceFilter ?? 'all',
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
        errorMessage: AppFeedback.messageFor(mapped ?? const UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  /// Loads the next page of events.
  Future<void> loadMore() async {
    if (_state.loading || !_state.hasMore || _state.nextCursor == null) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _eventRepository.getEvents(
        audienceFilter: _state.selectedFilter == 'all' ? null : _state.selectedFilter,
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
        errorMessage: AppFeedback.messageFor(mapped ?? const UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  /// Requests to join an event.
  Future<bool> requestJoin(String eventId) async {
    try {
      final result = await _eventRepository.requestJoin(eventId);
      return result.when(
        success: (_) => true,
        failure: (error) {
          // Don't update global state for this action; UI handles feedback.
          return false;
        },
      );
    } catch (error, st) {
      mapToAppException(error, st);
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

  /// Loads a single event by ID for the detail screen.
  Future<void> loadDetail(String eventId) async {
    if (_state.loadingDetail) return;
    _update(_state.copyWith(loadingDetail: true, clearDetail: true, clearError: true));
    try {
      final result = await _eventRepository.getEvent(eventId);
      if (_disposed) return;
      result.when(
        success: (event) {
          _update(_state.copyWith(loadingDetail: false, detail: event, clearError: true));
          // Also fetch join request status if user is authenticated
          _fetchJoinStatus(eventId);
        },
        failure: (error) => _update(_state.copyWith(
              loadingDetail: false,
              errorMessage: AppFeedback.messageFor(error),
              failureCategory: error.category,
            )),
      );
    } catch (error, st) {
      if (_disposed) return;
      final mapped = mapToAppException(error, st);
      _update(_state.copyWith(
        loadingDetail: false,
        errorMessage: AppFeedback.messageFor(mapped ?? const UnexpectedException()),
        failureCategory: mapped?.category,
      ));
    }
  }

  Future<void> _fetchJoinStatus(String eventId) async {
    try {
      final result = await _eventRepository.getJoinRequestStatus(eventId);
      if (_disposed) return;
      result.when(
        success: (status) => _update(_state.copyWith(joinRequestStatus: status)),
        failure: (_) => _update(_state.copyWith(joinRequestStatus: JoinRequestStatus.none)),
      );
    } catch (_) {
      if (!_disposed) _update(_state.copyWith(joinRequestStatus: JoinRequestStatus.none));
    }
  }

  /// Creates a new event (officer/admin).
  Future<Result<Event>> createEvent(EventDraft draft) async {
    try {
      final result = await _eventRepository.createEvent(draft);
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  /// Updates an existing event (officer/admin).
  Future<Result<Event>> updateEvent({
    required String eventId,
    required EventDraft draft,
    required int expectedRevision,
  }) async {
    try {
      final result = await _eventRepository.updateEvent(
        eventId: eventId,
        draft: draft,
        expectedRevision: expectedRevision,
      );
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  /// Cancels an event (officer/admin).
  Future<Result<void>> cancelEvent(String eventId, {required int expectedRevision}) async {
    try {
      final result = await _eventRepository.cancelEvent(
        eventId,
        expectedRevision: expectedRevision,
      );
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  /// Deletes an event (officer/admin).
  Future<Result<void>> deleteEvent(String eventId) async {
    // This would require a deleteEvent method in the repository
    // For now, we'll use cancelEvent as a placeholder
    try {
      final result = await _eventRepository.cancelEvent(
        eventId,
        expectedRevision: 0,
      );
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }
}