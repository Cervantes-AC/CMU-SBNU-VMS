import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/event_repository.dart';
import '../../data/models/event.dart';
import '../../shared/app_feedback.dart';

/// Immutable events view state.
class EventsViewState {
  const EventsViewState({
    this.loading = false,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
    this.selectedFilter = 'all',
  });

  final bool loading;
  final List<Event> items;
  final String? nextCursor;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;
  final String selectedFilter;

  EventsViewState copyWith({
    bool? loading,
    List<Event>? items,
    String? nextCursor,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    String? selectedFilter,
    bool clearError = false,
  }) => EventsViewState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
        selectedFilter: selectedFilter ?? this.selectedFilter,
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
}