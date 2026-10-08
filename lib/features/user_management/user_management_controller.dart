import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/user_management_repository.dart';
import '../../data/models/user.dart';
import 'package:cmu_sbnu_vms/features/user_management/user_management.dart';
import '../../shared/app_feedback.dart';

/// Immutable user management view state.
class UserManagementViewState {
  const UserManagementViewState({
    this.loading = false,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
    this.selectedFilter,
    this.selectedSort,
    this.searchQuery,
    this.statistics,
    this.statisticsLoading = false,
  });

  final bool loading;
  final List<UserProfile> items;
  final String? nextCursor;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;
  final UserManagementFilter? selectedFilter;
  final UserManagementSort? selectedSort;
  final String? searchQuery;
  final UserStatistics? statistics;
  final bool statisticsLoading;

  UserManagementViewState copyWith({
    bool? loading,
    List<UserProfile>? items,
    String? nextCursor,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    UserManagementFilter? selectedFilter,
    UserManagementSort? selectedSort,
    String? searchQuery,
    UserStatistics? statistics,
    bool? statisticsLoading,
    bool clearError = false,
  }) => UserManagementViewState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
        selectedFilter: selectedFilter ?? this.selectedFilter,
        selectedSort: selectedSort ?? this.selectedSort,
        searchQuery: searchQuery ?? this.searchQuery,
        statistics: statistics ?? this.statistics,
        statisticsLoading: statisticsLoading ?? this.statisticsLoading,
      );

  @override
  bool operator ==(Object other) =>
      other is UserManagementViewState &&
      other.loading == loading &&
      listEquals(other.items, items) &&
      other.nextCursor == nextCursor &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.hasMore == hasMore &&
      other.selectedFilter == selectedFilter &&
      other.selectedSort == selectedSort &&
      other.searchQuery == searchQuery &&
      other.statistics == statistics &&
      other.statisticsLoading == statisticsLoading;

  @override
  int get hashCode => Object.hash(
        loading,
        items,
        nextCursor,
        errorMessage,
        failureCategory,
        hasMore,
        selectedFilter,
        selectedSort,
        searchQuery,
        statistics,
        statisticsLoading,
      );
}

/// Coordinates user management operations against [UserManagementRepository].
class UserManagementController extends ChangeNotifier {
  UserManagementController({required UserManagementRepository userManagementRepository})
      : _userManagementRepository = userManagementRepository;

  final UserManagementRepository _userManagementRepository;

  UserManagementViewState _state = const UserManagementViewState();
  UserManagementViewState get state => _state;

  bool _disposed = false;

  void _update(UserManagementViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the first page of users.
  Future<void> load({
    UserManagementFilter? filter,
    UserManagementSort? sort,
  }) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _userManagementRepository.getUsers(
        statusFilter: filter,
        sort: sort,
      );
      if (_disposed) return;
      result.when(
        success: (data) => _update(_state.copyWith(
              loading: false,
              items: data.items,
              nextCursor: data.nextCursor,
              hasMore: data.nextCursor != null,
              selectedFilter: filter,
              selectedSort: sort,
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

  /// Loads the next page of users.
  Future<void> loadMore({
    UserManagementFilter? filter,
    UserManagementSort? sort,
  }) async {
    if (_state.loading || !_state.hasMore || _state.nextCursor == null) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _userManagementRepository.getUsers(
        statusFilter: _state.selectedFilter,
        sort: _state.selectedSort,
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

  /// Updates user status.
  Future<bool> updateUserStatus(String uid, AccountStatus newStatus) async {
    if (_state.loading) return false;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _userManagementRepository.updateUserStatus(
        uid: uid,
        newStatus: newStatus,
        expectedRevision: _state.items
            .where((u) => u.uid == uid)
            .firstOrNull
            ?.revision ??
            0,
      );
      if (_disposed) return false;
      return result.when(
        success: (result) {
          _update(_state.copyWith(
            loading: false,
            items: _state.items
                .map((u) => u.uid == result.updatedUser?.uid ? result.updatedUser! : u)
                .toList(),
            clearError: true,
          ));
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

  /// Updates user role.
  Future<bool> updateUserRole(String uid, UserRole newRole) async {
    if (_state.loading) return false;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _userManagementRepository.updateUserRole(
        uid: uid,
        newRole: newRole,
        expectedRevision: _state.items
            .where((u) => u.uid == uid)
            .firstOrNull
            ?.revision ??
            0,
      );
      if (_disposed) return false;
      return result.when(
        success: (result) {
          _update(_state.copyWith(
            loading: false,
            items: _state.items
                .map((u) => u.uid == result.updatedUser?.uid ? result.updatedUser! : u)
                .toList(),
            clearError: true,
          ));
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

  /// Loads statistics.
  Future<void> loadStatistics() async {
    if (_state.statisticsLoading) return;
    _update(_state.copyWith(statisticsLoading: true));
    try {
      final result = await _userManagementRepository.getUserStatistics();
      if (_disposed) return;
      result.when(
        success: (stats) => _update(_state.copyWith(
              statistics: stats,
              statisticsLoading: false,
            )),
        failure: (error) => _update(_state.copyWith(
              statisticsLoading: false,
            )),
      );
    } catch (error, st) {
      if (_disposed) return;
      _update(_state.copyWith(statisticsLoading: false));
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