import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/attendance.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';

import 'attendance_controller.dart';

/// Member's own attendance screen.
class MemberAttendanceScreen extends StatefulWidget {
  const MemberAttendanceScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.eventId,
  });

  final MemberAttendanceController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String eventId;

  @override
  State<MemberAttendanceScreen> createState() => _MemberAttendanceScreenState();
}

class _MemberAttendanceScreenState extends State<MemberAttendanceScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load(widget.eventId);
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
              onRefresh: () => widget.controller.load(widget.eventId),
              child: _buildBody(state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(MemberAttendanceViewState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => widget.controller.load(widget.eventId),
        onDismiss: widget.controller.clearError,
      );
    }

    final attendance = state.attendance;
    if (attendance == null) {
      return _NotCheckedInView(
        onCheckIn: () => widget.controller.checkIn(widget.eventId),
        isCheckingIn: state.checkingIn,
      );
    }

    return _CheckedInView(
      attendance: attendance,
      onRefresh: () => widget.controller.load(widget.eventId),
    );
  }
}

class _NotCheckedInView extends StatelessWidget {
  const _NotCheckedInView({
    required this.onCheckIn,
    required this.isCheckingIn,
  });

  final Future<void> Function() onCheckIn;
  final bool isCheckingIn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E8E1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(Icons.qr_code_scanner_rounded,
                    size: 40, color: Color(0xFF65736D)),
              ),
              const SizedBox(height: 24),
              Text(
                'Not checked in yet',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scan the event QR code to check in. Your attendance will be recorded with the current time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: isCheckingIn ? null : onCheckIn,
                icon: isCheckingIn
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.qr_code_scanner_rounded, size: 20),
                label: Text(isCheckingIn ? 'Checking in...' : 'Scan QR to check in'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckedInView extends StatelessWidget {
  const _CheckedInView({
    required this.attendance,
    required this.onRefresh,
  });

  final Attendance attendance;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D4F).withAlpha(20),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(Icons.check_circle_rounded,
                    size: 40, color: Color(0xFF2E7D4F)),
              ),
              const SizedBox(height: 24),
              Text(
                'Checked in',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your attendance has been recorded.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE1E8E1)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Status',
                      value: _statusLabel(attendance.status),
                      valueColor: _statusColor(attendance.status),
                    ),
                    const Divider(height: 20),
                    _DetailRow(
                      label: 'Recorded at',
                      value: DateHelpers.formatDateTime(attendance.recordedAt),
                    ),
                    const Divider(height: 20),
                    _DetailRow(
                      label: 'Source',
                      value: _sourceLabel(attendance.source),
                    ),
                    if (attendance.correctedAt != null) ...[
                      const Divider(height: 20),
                      _DetailRow(
                        label: 'Corrected at',
                        value: DateHelpers.formatDateTime(attendance.correctedAt!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _statusLabel(AttendanceStatus status) => switch (status) {
        AttendanceStatus.present => 'Present',
        AttendanceStatus.late => 'Late',
        AttendanceStatus.absent => 'Absent',
        AttendanceStatus.excused => 'Excused',
      };

  static Color _statusColor(AttendanceStatus status) => switch (status) {
        AttendanceStatus.present => const Color(0xFF2E7D4F),
        AttendanceStatus.late => const Color(0xFFB7791F),
        AttendanceStatus.absent => const Color(0xFFB3372C),
        AttendanceStatus.excused => const Color(0xFF2C6E9E),
      };

  static String _sourceLabel(AttendanceSource source) => switch (source) {
        AttendanceSource.qrScan => 'QR Scan',
        AttendanceSource.manual => 'Manual Entry',
        AttendanceSource.correction => 'Correction',
      };
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
    return Row(
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
    );
  }
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
              'Couldn\'t load attendance',
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