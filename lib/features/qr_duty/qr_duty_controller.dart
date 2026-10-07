import 'package:flutter/foundation.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../data/interfaces/qr_duty_repository.dart';
import '../../data/models/qr_duty.dart';
import '../../shared/app_feedback.dart';

/// Immutable QR duty scanner view state.
class QRDutyScannerViewState {
  const QRDutyScannerViewState({
    this.scanning = false,
    this.lastResult,
    this.errorMessage,
    this.failureCategory,
  });

  final bool scanning;
  final QRDutyScan? lastResult;
  final String? errorMessage;
  final ErrorCategory? failureCategory;

  QRDutyScannerViewState copyWith({
    bool? scanning,
    QRDutyScan? lastResult,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool clearError = false,
  }) => QRDutyScannerViewState(
        scanning: scanning ?? this.scanning,
        lastResult: lastResult ?? this.lastResult,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory: clearError ? null : failureCategory ?? this.failureCategory,
      );

  @override
  bool operator ==(Object other) =>
      other is QRDutyScannerViewState &&
      other.scanning == scanning &&
      other.lastResult == lastResult &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory;

  @override
  int get hashCode => Object.hash(scanning, lastResult, errorMessage, failureCategory);
}

/// Coordinates QR duty scanning against [QRDutyRepository].
class QRDutyScannerController extends ChangeNotifier {
  QRDutyScannerController({required QRDutyRepository qrDutyRepository})
      : _qrDutyRepository = qrDutyRepository;

  final QRDutyRepository _qrDutyRepository;

  QRDutyScannerViewState _state = const QRDutyScannerViewState();
  QRDutyScannerViewState get state => _state;

  bool _disposed = false;

  void _update(QRDutyScannerViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Scans a QR code token for the given session and action.
  Future<bool> scan({
    required String sessionId,
    required String rawToken,
    required QRDutyAction action,
  }) async {
    if (_state.scanning) return false;
    _update(_state.copyWith(scanning: true, clearError: true));
    try {
      final result = await _qrDutyRepository.validateScan(
        sessionId: sessionId,
        rawToken: rawToken,
        action: action,
      );
      if (_disposed) return false;
      return result.when(
        success: (scan) {
          _update(_state.copyWith(
            scanning: false,
            lastResult: scan,
            clearError: true,
          ));
          return true;
        },
        failure: (error) {
          _update(_state.copyWith(
            scanning: false,
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
        scanning: false,
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

/// Immutable QR duty monitor view state (officer/admin).
class QRDutyMonitorViewState {
  const QRDutyMonitorViewState({
    this.loading = false,
    this.session,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
    this.failureCategory,
    this.hasMore = true,
  });

  final bool loading;
  final QRDutySession? session;
  final List<QRDutyScan> items;
  final String? nextCursor;
  final String? errorMessage;
  final ErrorCategory? failureCategory;
  final bool hasMore;

  QRDutyMonitorViewState copyWith({
    bool? loading,
    QRDutySession? session,
    List<QRDutyScan>? items,
    String? nextCursor,
    String? errorMessage,
    ErrorCategory? failureCategory,
    bool? hasMore,
    bool clearError = false,
  }) => QRDutyMonitorViewState(
        loading: loading ?? this.loading,
        session: session ?? this.session,
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        failureCategory:
            clearError ? null : failureCategory ?? this.failureCategory,
        hasMore: hasMore ?? this.hasMore,
      );

  @override
  bool operator ==(Object other) =>
      other is QRDutyMonitorViewState &&
      other.loading == loading &&
      other.session == session &&
      listEquals(other.items, items) &&
      other.nextCursor == nextCursor &&
      other.errorMessage == errorMessage &&
      other.failureCategory == failureCategory &&
      other.hasMore == hasMore;

  @override
  int get hashCode => Object.hash(
        loading,
        session,
        items,
        nextCursor,
        errorMessage,
        failureCategory,
        hasMore,
      );
}

/// Coordinates QR duty session monitoring against [QRDutyRepository].
class QRDutyMonitorController extends ChangeNotifier {
  QRDutyMonitorController({required QRDutyRepository qrDutyRepository})
      : _qrDutyRepository = qrDutyRepository;

  final QRDutyRepository _qrDutyRepository;

  QRDutyMonitorViewState _state = const QRDutyMonitorViewState();
  QRDutyMonitorViewState get state => _state;

  bool _disposed = false;
  String _sessionId = '';

  void _update(QRDutyMonitorViewState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Loads the session details and first page of scans.
  Future<void> load(String sessionId) async {
    _sessionId = sessionId;
    if (_state.loading) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final sessionResult = await _qrDutyRepository.getSession(_sessionId);
      if (_disposed) return;
      final session = sessionResult.when(
        success: (s) => s,
        failure: (_) => null,
      );
      if (session == null) {
        _update(_state.copyWith(loading: false));
        return;
      }

      final scansResult = await _qrDutyRepository.getSessionScans(
        sessionId: _sessionId,
      );
      if (_disposed) return;
      final data = scansResult.when(
        success: (d) => d,
        failure: (e) => (items: <QRDutyScan>[], nextCursor: null),
      );

      _update(_state.copyWith(
        loading: false,
        session: session,
        items: data.items,
        nextCursor: data.nextCursor,
        hasMore: data.nextCursor != null,
        clearError: true,
      ));
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

  /// Loads the next page of scans.
  Future<void> loadMore() async {
    if (_state.loading || !_state.hasMore || _state.nextCursor == null) return;
    _update(_state.copyWith(loading: true, clearError: true));
    try {
      final result = await _qrDutyRepository.getSessionScans(
        sessionId: _sessionId,
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
}