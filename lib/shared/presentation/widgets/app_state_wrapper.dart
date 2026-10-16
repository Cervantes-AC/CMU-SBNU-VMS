import 'package:flutter/material.dart';

import '../../../core/types/app_types.dart';

import 'app_state_widgets.dart';

/// Wraps content and shows loading, empty, error, offline, or permission-denied states.
///
/// [status] controls which state is shown. [child] is shown when status is [LoadStatus.loaded].
class AppStateWrapper extends StatelessWidget {
  const AppStateWrapper({
    super.key,
    required this.status,
    this.child,
    this.onRetry,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.errorMessage,
    this.offlineMessage,
    this.permissionMessage,
  });

  final LoadStatus status;
  final Widget? child;
  final VoidCallback? onRetry;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final String? errorMessage;
  final String? offlineMessage;
  final String? permissionMessage;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return AppLoadingState(message: _statusMessage());
      case LoadStatus.loaded:
        if (child == null) {
          return AppEmptyState(
            icon: emptyIcon,
            title: emptyTitle ?? 'No items available.',
            subtitle: emptySubtitle,
          );
        }
        return child!;
      case LoadStatus.error:
        return AppErrorState(
          message: errorMessage ?? 'An unexpected error occurred.',
          onRetry: onRetry,
        );
      case LoadStatus.offline:
        return AppOfflineState(message: offlineMessage, onRetry: onRetry);
    }
  }

  String? _statusMessage() {
    switch (status) {
      case LoadStatus.initial:
        return 'Getting ready…';
      case LoadStatus.loading:
        return 'Loading…';
      case LoadStatus.loaded:
      case LoadStatus.error:
      case LoadStatus.offline:
        return null;
    }
  }
}
