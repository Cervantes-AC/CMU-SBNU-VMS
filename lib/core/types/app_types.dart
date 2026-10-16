import 'package:equatable/equatable.dart';

import '../errors/app_failure.dart';

/// Stable cross-feature primitive types used across the app.

/// The status of a data-loading operation.
enum LoadStatus { initial, loading, loaded, error, offline }

/// The availability of a feature or service.
enum FeatureAvailability { available, previewOnly, unavailable }

/// Result wrapper for repository operations.
class AppResult<T> {
  final T? data;
  final AppFailure? error;
  final bool isLoading;

  const AppResult._({this.data, this.error, this.isLoading = false});

  const AppResult.data(this.data) : error = null, isLoading = false;

  const AppResult.error(this.error) : data = null, isLoading = false;

  const AppResult.loading() : data = null, error = null, isLoading = true;

  bool get hasData => data != null && error == null && !isLoading;
  bool get hasError => error != null;
  bool get success => data != null && error == null && !isLoading;
}

/// Simple async command result for ViewModel actions.
class CommandResult {
  final bool success;
  final AppFailure? error;

  const CommandResult._({required this.success, this.error});

  const CommandResult.success() : success = true, error = null;
  const CommandResult.failure(this.error) : success = false;
}

/// Timestamp helper using server-authoritative time when available.
class AppTimestamp {
  final DateTime value;

  const AppTimestamp(this.value);

  factory AppTimestamp.now() => AppTimestamp(DateTime.now());

  String toIsoString() => value.toIso8601String();

  @override
  String toString() => value.toIso8601String();
}
