import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/interfaces/attendance_repository.dart';
import 'package:cmu_sbnu_vms/data/models/attendance.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/shared/empty_state.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

import 'attendance_controller.dart';

/// Officer's event attendance management screen.
class EventAttendanceScreen extends StatefulWidget {
  const EventAttendanceScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.eventId,
  });

  final OfficerAttendanceController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String eventId;

  @override
  State<EventAttendanceScreen> createState() => _EventAttendanceScreenState();
}

class _EventAttendanceScreenState extends State<EventAttendanceScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.controller.load(widget.eventId);
    widget.controller.loadSummary(widget.eventId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMore(widget.eventId);
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
              if (!compact && isOfficer)
                PopupMenuButton<AttendanceStatus>(
                  icon: const Icon(Icons.add_rounded, color: AppTheme.seed),
                  tooltip: 'Record attendance',
                  onSelected: (status) => _recordAttendance(status),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: AttendanceStatus.present,
                      child: Text('Mark Present'),
                    ),
                    const PopupMenuItem(
                      value: AttendanceStatus.late,
                      child: Text('Mark Late'),
                    ),
                    const PopupMenuItem(
                      value: AttendanceStatus.absent,
                      child: Text('Mark Absent'),
                    ),
                    const PopupMenuItem(
                      value: AttendanceStatus.excused,
                      child: Text('Mark Excused'),
                    ),
                  ],
                ),
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

  Future<void> _recordAttendance(AttendanceStatus status) async {
    // For now, we'd need a UI to select which member to mark.
    // This would typically open a member picker dialog.
    // For this implementation, we'll just show a placeholder.
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Member picker for manual attendance marking - to be implemented'),
      ),
    );
  }

  Widget _buildBody(OfficerAttendanceViewState state) {
    if (state.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => widget.controller.load(widget.eventId),
        onDismiss: widget.controller.clearError,
      );
    }

    return Column(
      children: [
        if (state.summary != null) _SummaryBar(summary: state.summary!),
        Expanded(
          child: state.items.isEmpty
              ? EmptyState(
                  title: 'No attendance records yet',
                  explanation: 'Attendees will appear here as they check in or are marked manually.',
                  icon: Icons.people_outline,
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
                    final attendance = state.items[index];
                    return _AttendanceRow(
                      attendance: attendance,
                      onCorrect: (newStatus) =>
                          widget.controller.correct(attendance.attendanceId, newStatus),
                      isCorrecting: state.recording,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.summary});

  final AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E8E1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Total',
              value: summary.total.toString(),
              color: const Color(0xFF65736D),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              label: 'Present',
              value: summary.present.toString(),
              color: const Color(0xFF2E7D4F),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              label: 'Late',
              value: summary.late.toString(),
              color: const Color(0xFFB7791F),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              label: 'Absent',
              value: summary.absent.toString(),
              color: const Color(0xFFB3372C),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              label: 'Excused',
              value: summary.excused.toString(),
              color: const Color(0xFF2C6E9E),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({
    required this.attendance,
    required this.onCorrect,
    required this.isCorrecting,
  });

  final Attendance attendance;
  final Future<void> Function(AttendanceStatus) onCorrect;
  final bool isCorrecting;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final status = attendance.status;

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
              backgroundColor: _statusColor(status).withAlpha(20),
              child: Icon(
                status == AttendanceStatus.present
                    ? Icons.check_circle_rounded
                    : status == AttendanceStatus.late
                        ? Icons.schedule_rounded
                        : status == AttendanceStatus.absent
                            ? Icons.cancel_rounded
                            : Icons.event_busy_rounded,
                color: _statusColor(status),
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
                          attendance.uid,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(status: status.wire, compact: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recorded: ${DateHelpers.formatDateTime(attendance.recordedAt)} · ${_sourceLabel(attendance.source)}',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                  if (attendance.correctedAt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Corrected: ${DateHelpers.formatDateTime(attendance.correctedAt!)}',
                      style: TextStyle(
                          color: const Color(0xFF2C6E9E), fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<AttendanceStatus>(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF65736D)),
              tooltip: 'Correct status',
              onSelected: (newStatus) => onCorrect(newStatus),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: AttendanceStatus.present,
                  child: Text('Mark Present'),
                ),
                const PopupMenuItem(
                  value: AttendanceStatus.late,
                  child: Text('Mark Late'),
                ),
                const PopupMenuItem(
                  value: AttendanceStatus.absent,
                  child: Text('Mark Absent'),
                ),
                const PopupMenuItem(
                  value: AttendanceStatus.excused,
                  child: Text('Mark Excused'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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