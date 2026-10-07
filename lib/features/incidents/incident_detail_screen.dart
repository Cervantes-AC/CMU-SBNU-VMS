import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/incident.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

import 'incident_controller.dart';

/// Incident detail screen with editing and status transitions for authorized users.
class IncidentDetailScreen extends StatefulWidget {
  const IncidentDetailScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.incidentId,
  });

  final IncidentDetailController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String incidentId;

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load(widget.incidentId);
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
        final isReporter = state.incident?.reporterUid == profile?.uid;

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
                onPressed: state.updating ? null : widget.authController.signOut,
                icon: const Icon(Icons.logout_rounded, size: 17),
                label: Text(compact ? '' : 'Sign out'),
                style: TextButton.styleFrom(foregroundColor: AppTheme.seed),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () => widget.controller.load(widget.incidentId),
              child: _buildBody(state, isOfficer, isReporter),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(IncidentDetailViewState state, bool isOfficer, bool isReporter) {
    if (state.loading && state.incident == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.incident == null) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => widget.controller.load(widget.incidentId),
        onDismiss: widget.controller.clearError,
      );
    }

    final incident = state.incident;
    if (incident == null) {
      return const Center(child: Text('Incident not found'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          _IncidentHeaderCard(
            incident: incident,
            isOfficer: isOfficer,
            isReporter: isReporter,
            onStatusTransition: isOfficer ? _showStatusTransitionDialog : null,
            onAssign: isOfficer ? _showAssignDialog : null,
          ),
          const SizedBox(height: 16),
          // Description card
          _InfoCard(
            title: 'Description',
            child: Text(
              incident.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          if (incident.location != null && incident.location!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Location',
              child: Text(
                incident.location!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
          if (incident.resolution != null && incident.resolution!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Resolution',
              child: Text(
                incident.resolution!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Metadata card
          _InfoCard(
            title: 'Details',
            child: Column(
              children: [
                _DetailRow(label: 'Incident ID', value: incident.incidentId),
                _DetailRow(
                  label: 'Category',
                  value: incident.category.wire,
                  valueWidget: StatusBadge(
                    status: incident.category.wire,
                    compact: true,
                  ),
                ),
                _DetailRow(
                  label: 'Severity',
                  value: incident.severity.wire,
                  valueWidget: _SeverityBadge(severity: incident.severity),
                ),
                _DetailRow(
                  label: 'Status',
                  value: incident.status.wire,
                  valueWidget: StatusBadge(
                    status: incident.status.wire,
                    compact: true,
                  ),
                ),
                if (incident.assignedTo != null)
                  _DetailRow(label: 'Assigned To', value: incident.assignedTo!),
                _DetailRow(
                  label: 'Reported',
                  value: DateHelpers.formatDateTime(incident.createdAt),
                ),
                _DetailRow(
                  label: 'Last Updated',
                  value: DateHelpers.formatDateTime(incident.updatedAt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusTransitionDialog() {
    final incident = widget.controller.state.incident!;
    showDialog(
      context: context,
      builder: (context) => _StatusTransitionDialog(
        incident: widget.controller.state.incident!,
        onConfirm: (status, resolution) {
          widget.controller.transitionStatus(
            incidentId: widget.incidentId,
            newStatus: status.wire,
            resolution: resolution,
          ).then((success) {
            if (success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Status updated to ${status.wire}')),
              );
            }
          });
        },
      ),
    );
  }

  void _showAssignDialog() {
    // TODO: Implement assign dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assign incident - to be implemented')),
    );
  }
}

class _IncidentHeaderCard extends StatelessWidget {
  const _IncidentHeaderCard({
    required this.incident,
    required this.isOfficer,
    required this.isReporter,
    this.onStatusTransition,
    this.onAssign,
  });

  final Incident incident;
  final bool isOfficer;
  final bool isReporter;
  final VoidCallback? onStatusTransition;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    incident.category.wire.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                _SeverityBadge(severity: incident.severity),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                StatusBadge(status: incident.status.wire),
                const SizedBox(width: 8),
                _SeverityBadge(severity: incident.severity),
              ],
            ),
            const SizedBox(height: 12),
            if (isOfficer)
              Row(
                children: [
                  if (onStatusTransition != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onStatusTransition,
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: const Text('Change Status'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.seed,
                          side: const BorderSide(color: AppTheme.seed),
                        ),
                      ),
                    ),
                  if (onAssign != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onAssign,
                        icon: const Icon(Icons.person_add_rounded, size: 18),
                        label: const Text('Assign'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.seed,
                          side: const BorderSide(color: AppTheme.seed),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final IncidentSeverity severity;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        severity.wire.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static Color _severityColor(IncidentSeverity severity) => switch (severity) {
        IncidentSeverity.critical => const Color(0xFFB3372C),
        IncidentSeverity.high => const Color(0xFFB7791F),
        IncidentSeverity.medium => AppTheme.seed,
        IncidentSeverity.low => const Color(0xFF65736D),
      };
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueWidget,
  });

  final String label;
  final String value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ],
      ),
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
              'Couldn\'t load incident',
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

class _StatusTransitionDialog extends StatefulWidget {
  const _StatusTransitionDialog({
    required this.incident,
    required this.onConfirm,
  });

  final Incident incident;
  final void Function(IncidentStatus, String?) onConfirm;

  @override
  State<_StatusTransitionDialog> createState() => _StatusTransitionDialogState();
}

class _StatusTransitionDialogState extends State<_StatusTransitionDialog> {
  IncidentStatus _selectedStatus = IncidentStatus.acknowledged;
  final _resolutionController = TextEditingController();
  bool _showResolution = false;

  @override
  void dispose() {
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextStatuses = _getNextStatuses(widget.incident.status);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Change Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<IncidentStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(labelText: 'New Status'),
            initialValue: _selectedStatus,
            items: nextStatuses
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.wire),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                  _showResolution = value == IncidentStatus.resolved ||
                      value == IncidentStatus.closed;
                });
              }
            },
          ),
          if (_showResolution) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _resolutionController,
              decoration: const InputDecoration(
                labelText: 'Resolution (required)',
                hintText: 'Describe how this was resolved...',
              ),
              maxLines: 3,
              validator: (v) =>
                  _showResolution && (v == null || v.trim().isEmpty)
                      ? 'Resolution is required'
                      : null,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onConfirm(
              _selectedStatus,
              _showResolution ? _resolutionController.text.trim() : null,
            );
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  List<IncidentStatus> _getNextStatuses(IncidentStatus current) {
    switch (current) {
      case IncidentStatus.open:
        return [IncidentStatus.acknowledged, IncidentStatus.inProgress];
      case IncidentStatus.acknowledged:
        return [IncidentStatus.inProgress, IncidentStatus.resolved];
      case IncidentStatus.inProgress:
        return [IncidentStatus.resolved];
      case IncidentStatus.resolved:
        return [IncidentStatus.closed];
      case IncidentStatus.closed:
        return [];
    }
  }
}