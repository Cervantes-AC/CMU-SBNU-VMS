import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/qr_duty.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/shared/empty_state.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

import 'qr_duty_controller.dart';

/// QR duty session monitoring screen for officers/admins.
class QRDutyMonitorScreen extends StatefulWidget {
  const QRDutyMonitorScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.sessionId,
  });

  final QRDutyMonitorController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String sessionId;

  @override
  State<QRDutyMonitorScreen> createState() => _QRDutyMonitorScreenState();
}

class _QRDutyMonitorScreenState extends State<QRDutyMonitorScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.controller.load(widget.sessionId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.controller,
        widget.sessionController,
        widget.authController,
      ]),
      builder: (context, _) {
        final state = widget.controller.state;
        final profile = widget.sessionController.profile;
        final isOfficer = profile?.role == UserRole.officer ||
            profile?.role == UserRole.admin;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F2),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F7F2),
            surfaceTintColor: Colors.transparent,
            titleSpacing: 8,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E8E1)),
                  ),
                  child: Image.asset('assets/images/SBNU LOGO.png',
                      fit: BoxFit.contain,
                      semanticLabel: 'CMU School-Based NSRC Unit logo'),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'CMU SBNU VMS',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: widget.authController.signOut,
                icon: const Icon(Icons.logout_rounded, size: 17),
                label: Text(compact ? '' : 'Sign out'),
                style: TextButton.styleFrom(foregroundColor: AppTheme.seed),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () => widget.controller.load(widget.sessionId),
              child: _buildBody(state, isOfficer),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(QRDutyMonitorViewState state, bool isOfficer) {
    if (state.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => widget.controller.load(widget.sessionId),
        onDismiss: widget.controller.clearError,
      );
    }

    final session = state.session;
    return Column(
      children: [
        if (session != null) _SessionHeader(session: session, isOfficer: isOfficer),
        Expanded(
          child: state.items.isEmpty
              ? EmptyState(
                  title: 'No scans yet',
                  explanation: 'Scans will appear here as members check in/out.',
                  icon: Icons.qr_code_scanner_rounded,
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      if (state.loading) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    final scan = state.items[index];
                    return _ScanRow(scan: scan);
                  },
                ),
        ),
      ],
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.session,
    required this.isOfficer,
  });

  final QRDutySession session;
  final bool isOfficer;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E8E1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QR Duty Session',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(status: session.status.wire, compact: false),
                  ],
                ),
              ),
              isOfficer
                ? TextButton.icon(
                    onPressed: () {
                      // TODO: Cancel session dialog
                    },
                    icon: const Icon(Icons.cancel_rounded, size: 16),
                    label: const Text('Cancel Session'),
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFFB3372C)),
                  )
                : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'Event ID',
            value: session.eventId,
          ),
          _DetailRow(
            label: 'Status',
            value: _statusLabel(session.status),
            valueColor: _statusColor(session.status),
          ),
          _DetailRow(
            label: 'Valid',
            value: session.isActive ? 'Active' : 'Inactive',
            valueColor: session.isActive ? const Color(0xFF2E7D4F) : const Color(0xFFB3372C),
          ),
          _DetailRow(
            label: 'Starts',
            value: DateHelpers.formatDateTime(session.startsAt),
          ),
          _DetailRow(
            label: 'Expires',
            value: DateHelpers.formatDateTime(session.expiresAt),
          ),
          _DetailRow(
            label: 'Max Scans/Member',
            value: '${session.maxScansPerMember}',
          ),
          _DetailRow(
            label: 'Allowed Actions',
            value: session.allowedActions.map((a) => a.wire).join(', '),
          ),
          if (isOfficer) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.qr_code_rounded, size: 18, color: AppTheme.seed),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Session Token: ${session.tokenDigest.substring(0, 16)}...',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _statusLabel(QRDutySessionStatus status) {
    switch (status) {
      case QRDutySessionStatus.active:
        return 'Active';
      case QRDutySessionStatus.expired:
        return 'Expired';
      case QRDutySessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  static Color _statusColor(QRDutySessionStatus status) {
    switch (status) {
      case QRDutySessionStatus.active:
        return const Color(0xFF2E7D4F);
      case QRDutySessionStatus.expired:
        return const Color(0xFFB3372C);
      case QRDutySessionStatus.cancelled:
        return const Color(0xFF65736D);
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: muted, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanRow extends StatelessWidget {
  const _ScanRow({required this.scan});

  final QRDutyScan scan;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _resultColor(scan.result).withAlpha(20),
              child: Icon(
                scan.result == QRDutyScanResult.success
                    ? Icons.check_circle_rounded
                    : Icons.error_rounded,
                color: _resultColor(scan.result),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scan.uid,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        status: scan.result.wire,
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Action: ${scan.action.wire} · ${DateHelpers.formatDateTime(scan.serverTime)}',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _resultColor(QRDutyScanResult result) => switch (result) {
        QRDutyScanResult.success => const Color(0xFF2E7D4F),
        QRDutyScanResult.invalidToken => const Color(0xFFB3372C),
        QRDutyScanResult.expiredSession => const Color(0xFFB7791F),
        QRDutyScanResult.duplicateScan => const Color(0xFFB3372C),
        QRDutyScanResult.wrongAction => const Color(0xFFB7791F),
        QRDutyScanResult.sessionNotActive => const Color(0xFF65736D),
      };
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 40),
            const SizedBox(height: 16),
            Text(
              'Couldn\'t load session',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}