import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/announcement_repository.dart';
import '../../data/models/announcement.dart';
import '../../shared/app_feedback.dart';
import '../../shared/result.dart';

/// Immutable announcements view state.
class AnnouncementsViewState {
  const AnnouncementsViewState({
    this.loading = false,
    this.loadingDetail = false,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
    this.detail,
  });

  final bool loading;
  final bool loadingDetail;
  final List<Announcement> items;
  final String? nextCursor;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;
  final Announcement? detail;

  AnnouncementsViewState copyWith({
    bool? loading,
    bool? loadingDetail,
    List<Announcement>? items,
    String? nextCursor,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    Announcement? detail,
    bool clearDetail = false,
    bool clearError = false,
  }) => AnnouncementsViewState(
        loading: loading ?? this.loading,
        loadingDetail: loadingDetail ?? this.loadingDetail,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
        detail: clearDetail ? null : detail ?? this.detail,
      );

  @override
  bool operator ==(Object other) =>
      other is AnnouncementsViewState &&
      other.loading == loading &&
      listEquals(other.items, items) &&
      other.nextCursor == nextCursor &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.hasMore == hasMore;

  @override
  int get hashCode => Object.hash(
        loading,
        items,
        nextCursor,
        errorMessage,
        failureCategory,
        hasMore,
      );
}

/// Coordinates announcements loading against [AnnouncementRepository].
class AnnouncementsController extends ChangeNotifier {
  AnnouncementsController({required AnnouncementRepository announcementRepository})
      : _announcementRepository = announcementRepository;

  final AnnouncementRepository _announcementRepository;

  AnnouncementsViewState _state = const AnnouncementsViewState();
  AnnouncementsViewState get state => _state;

  bool _disposed = false;

  void _update(AnnouncementsViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the first page of announcements.
  Future<void> load() async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _announcementRepository.getAnnouncements();
      if (_disposed) return;
      result.when(
        success: (data) => _update(_state.copyWith(
              loading: false,
              items: data.items,
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

  /// Loads the next page of announcements.
  Future<void> loadMore() async {
    if (_state.loading || !_state.hasMore || _state.nextCursor == null) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _announcementRepository.getAnnouncements(
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

  /// Loads a single announcement by ID for the detail screen.
  Future<void> loadDetail(String id) async {
    if (_state.loadingDetail) return;
    _update(_state.copyWith(loadingDetail: true, clearDetail: true, clearError: true));
    try {
      final result = await _announcementRepository.getAnnouncement(id);
      if (_disposed) return;
      result.when(
        success: (announcement) => _update(_state.copyWith(loadingDetail: false, detail: announcement, clearError: true)),
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

  /// Creates a new announcement (officer/admin).
  Future<Result<Announcement>> createAnnouncement(AnnouncementDraft draft) async {
    try {
      final result = await _announcementRepository.createAnnouncement(draft);
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  /// Updates an existing announcement (officer/admin).
  Future<Result<Announcement>> updateAnnouncement({
    required String id,
    required AnnouncementDraft draft,
    required int expectedRevision,
  }) async {
    try {
      final result = await _announcementRepository.updateAnnouncement(
        id: id,
        draft: draft,
        expectedRevision: expectedRevision,
      );
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  /// Publishes an announcement (officer/admin).
  Future<Result<Announcement>> publishAnnouncement(String id, {required int expectedRevision}) async {
    try {
      final result = await _announcementRepository.publishAnnouncement(id, expectedRevision: expectedRevision);
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  /// Unpublishes an announcement (officer/admin).
  Future<Result<Announcement>> unpublishAnnouncement(String id, {required int expectedRevision}) async {
    try {
      final result = await _announcementRepository.unpublishAnnouncement(id, expectedRevision: expectedRevision);
      return result;
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }
}