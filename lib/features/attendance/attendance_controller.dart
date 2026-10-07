import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/attendance_repository.dart';
import '../../data/models/attendance.dart';
import '../../shared/app_feedback.dart';

/// Immutable member attendance view state.
class MemberAttendanceViewState {
  const MemberAttendanceViewState({
    this.loading = false,
    this.attendance,
    this.errorMessage,
    this.failureCategory,
    this.checkingIn = false,
  });

  final bool loading;
  final Attendance? attendance;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool checkingIn;

  MemberAttendanceViewState copyWith({
    bool? loading,
    Attendance? attendance,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? checkingIn,
    bool clearError = false,
  }) => MemberAttendanceViewState(
        loading: loading ?? this.loading,
        attendance: attendance ?? this.attendance,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        checkingIn: checkingIn ?? this.checkingIn,
      );

  @override
  bool operator ==(Object other) =>
      other is MemberAttendanceViewState &&
      other.loading == loading &&
      other.attendance == attendance &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.checkingIn == checkingIn;

  @override
  int get hashCode => Object.hash(
        loading,
        attendance,
        errorMessage,
        failureCategory,
        checkingIn,
      );
}

/// Coordinates member attendance loading and QR check-in against [AttendanceRepository].
class MemberAttendanceController extends ChangeNotifier {
  MemberAttendanceController({required AttendanceRepository attendanceRepository})
      : _attendanceRepository = attendanceRepository;

  final AttendanceRepository _attendanceRepository;

  MemberAttendanceViewState _state = const MemberAttendanceViewState();
  MemberAttendanceViewState get state => _state;

  bool _disposed = false;

  void _update(MemberAttendanceViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the current user's attendance for an event.
  Future<void> load(String eventId) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _attendanceRepository.getMyAttendance(eventId);
      if (_disposed) return;
      result.when(
        success: (attendance) => _update(_state.copyWith(
              loading: false,
              attendance: attendance,
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

  /// Checks in via QR scan.
  Future<bool> checkIn(String eventId) async {
    if (_state.checkingIn) return false;
    _update(_state.copyWith(checkingIn: true, clearError: true));
    try {
      final result = await _attendanceRepository.recordAttendance(
        eventId: eventId,
        status: AttendanceStatus.present,
        source: AttendanceSource.qrScan,
      );
      if (_disposed) return false;
      return result.when(
        success: (attendance) {
          _update(_state.copyWith(
            checkingIn: false,
            attendance: attendance,
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            checkingIn: false,
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
        checkingIn: false,
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

/// Immutable officer attendance view state (for event attendance management).
class OfficerAttendanceViewState {
  const OfficerAttendanceViewState({
    this.loading = false,
    this.items = const [],
    this.nextCursor,
    this.summary,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
    this.recording = false,
  });

  final bool loading;
  final List<Attendance> items;
  final String? nextCursor;
  final AttendanceSummary? summary;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;
  final bool recording;

  OfficerAttendanceViewState copyWith({
    bool? loading,
    List<Attendance>? items,
    String? nextCursor,
    AttendanceSummary? summary,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    bool? recording,
    bool clearError = false,
  }) => OfficerAttendanceViewState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        summary: summary ?? this.summary,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
        recording: recording ?? this.recording,
      );

  @override
  bool operator ==(Object other) =>
      other is OfficerAttendanceViewState &&
      other.loading == loading &&
      listEquals(other.items, items) &&
      other.nextCursor == nextCursor &&
      other.summary == summary &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.hasMore == hasMore &&
      other.recording == recording;

  @override
  int get hashCode => Object.hash(
        loading,
        items,
        nextCursor,
        summary,
        errorMessage,
        failureCategory,
        hasMore,
        recording,
      );
}

/// Coordinates officer attendance loading, recording, and corrections.
class OfficerAttendanceController extends ChangeNotifier {
  OfficerAttendanceController({required AttendanceRepository attendanceRepository})
      : _attendanceRepository = attendanceRepository;

  final AttendanceRepository _attendanceRepository;

  OfficerAttendanceViewState _state = const OfficerAttendanceViewState();
  OfficerAttendanceViewState get state => _state;

  bool _disposed = false;

  void _update(OfficerAttendanceViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the first page of attendance for an event.
  Future<void> load(String eventId) async {
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _attendanceRepository.getEventAttendance(
        eventId: eventId,
      );
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

  /// Loads the next page.
  Future<void> loadMore(String eventId) async {
    if (_state.loading || !_state.hasMore || _state.nextCursor == null) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _attendanceRepository.getEventAttendance(
        eventId: eventId,
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

  /// Loads the attendance summary.
  Future<void> loadSummary(String eventId) async {
    try {
      final result = await _attendanceRepository.getAttendanceSummary(eventId);
      if (_disposed) return;
      result.when(
        success: (summary) => _update(_state.copyWith(summary: summary)),
        failure: (_) {}, // Non-fatal
      );
    } catch (_) {
      // Non-fatal
    }
  }

  /// Records attendance manually (officer marking).
  Future<bool> record(String eventId, AttendanceStatus status, AttendanceSource source) async {
    if (_state.recording) return false;
    _update(_state.copyWith(recording: true, clearError: true));
    try {
      final result = await _attendanceRepository.recordAttendance(
        eventId: eventId,
        status: status,
        source: source,
      );
      if (_disposed) return false;
      return result.when(
        success: (attendance) {
          _update(_state.copyWith(
            recording: false,
            items: [attendance, ..._state.items],
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            recording: false,
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
        recording: false,
        errorMessage: AppFeedback.messageFor(mapped ?? UnexpectedException()),
        failureCategory: mapped?.category,
      ));
      return false;
    }
  }

  /// Corrects an attendance record.
  Future<bool> correct(String attendanceId, AttendanceStatus newStatus) async {
    if (_state.recording) return false;
    _update(_state.copyWith(recording: true, clearError: true));
    // Find the record to get its revision.
    final existing = _state.items
        .where((a) => a.attendanceId == attendanceId)
        .firstOrNull;
    if (existing == null) return false;

    _update(_state.copyWith(recording: true, clearError: true));
    try {
      final result = await _attendanceRepository.correctAttendance(
        attendanceId: attendanceId,
        newStatus: newStatus,
        expectedRevision: existing.revision,
      );
      if (_disposed) return false;
      return result.when(
        success: (corrected) {
          _update(_state.copyWith(
            recording: false,
            items: _state.items
                .map((a) => a.attendanceId == attendanceId ? corrected : a)
                .toList(),
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            recording: false,
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
        recording: false,
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