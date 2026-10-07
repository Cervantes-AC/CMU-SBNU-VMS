import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/incident.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/shared/empty_state.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

import 'incident_controller.dart';


/// Incidents list screen with filtering and pagination.
class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
  });

  final IncidentsController controller;
  final SessionController sessionController;
  final AuthController authController;

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  final _scrollController = ScrollController();
  IncidentStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.controller.load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMore(statusFilter: _statusFilter);
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
                PopupMenuButton<IncidentStatus>(
                  icon: const Icon(Icons.filter_list_rounded, color: AppTheme.seed),
                  tooltip: 'Filter by status',
                  onSelected: (status) {
                    setState(() => _statusFilter = status);
                    widget.controller.load(statusFilter: status);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All'),
                    ),
                    const PopupMenuItem(
                      value: IncidentStatus.open,
                      child: Text('Open'),
                    ),
                    const PopupMenuItem(
                      value: IncidentStatus.acknowledged,
                      child: Text('Acknowledged'),
                    ),
                    const PopupMenuItem(
                      value: IncidentStatus.inProgress,
                      child: Text('In Progress'),
                    ),
                    const PopupMenuItem(
                      value: IncidentStatus.resolved,
                      child: Text('Resolved'),
                    ),
                    const PopupMenuItem(
                      value: IncidentStatus.closed,
                      child: Text('Closed'),
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
            child: Column(
              children: [
                // Status filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      for (final filter in <_FilterOption>[
                        _FilterOption(null, 'All'),
                        _FilterOption(IncidentStatus.open, 'Open'),
                        _FilterOption(IncidentStatus.acknowledged, 'Acknowledged'),
                        _FilterOption(IncidentStatus.inProgress, 'In Progress'),
                        _FilterOption(IncidentStatus.resolved, 'Resolved'),
                        _FilterOption(IncidentStatus.closed, 'Closed'),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter.label),
                            selected: _statusFilter == filter.status,
                            onSelected: (_) {
                              setState(() => _statusFilter = filter.status);
                              widget.controller.load(statusFilter: filter.status);
                            },
                            selectedColor: AppTheme.seed.withAlpha(30),
                            checkmarkColor: AppTheme.seed,
                            labelStyle: TextStyle(
                              color: _statusFilter == filter.status
                                  ? AppTheme.seed
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: _statusFilter == filter.status
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _statusFilter == filter.status
                                    ? AppTheme.seed
                                    : const Color(0xFFE1E8E1),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => widget.controller.load(),
                    child: _buildBody(state, isOfficer),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(IncidentsViewState state, bool isOfficer) {
    if (state.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => widget.controller.load(),
        onDismiss: widget.controller.clearError,
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        title: 'No incidents yet',
        explanation: isOfficer
            ? 'Incidents reported by members will appear here.'
            : 'Your reported incidents will appear here. Tap the + button to report a new incident.',
        icon: Icons.report_gmailerrorred_outlined,
        actionLabel: 'Report incident',
        onAction: () => _showCreateIncidentDialog(),
      );
    }

    return ListView.builder(
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
        final incident = state.items[index];
        return _IncidentCard(
          incident: incident,
          onTap: () => Navigator.of(context).pushNamed(
              '/incidents/\${incident.incidentId}'),
        );
      },
    );
  }

  void _showCreateIncidentDialog() {
    // TODO: Implement create incident dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create incident - to be implemented')),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  const _IncidentCard({
    required this.incident,
    required this.onTap,
  });

  final Incident incident;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE1E8E1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                incident.category.wire.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(status: incident.status.wire),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                incident.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: muted, fontSize: 13, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14, color: muted),
                            const SizedBox(width: 6),
                            Text(
                              'Reported: ${DateHelpers.formatDateTime(incident.createdAt)}',
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                          ],
                        ),
                        if (incident.assignedTo != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.person_outline, size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                'Assigned: ${incident.assignedTo}',
                                style: TextStyle(color: muted, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (incident.location != null && incident.location!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: muted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        incident.location!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: muted, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
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
              'Couldn\'t load incidents',
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

class _FilterOption {
  const _FilterOption(this.status, this.label);

  final IncidentStatus? status;

  final String label;

}








