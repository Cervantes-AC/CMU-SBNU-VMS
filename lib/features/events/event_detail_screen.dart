import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/constants/route_names.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/interfaces/event_repository.dart';
import 'package:cmu_sbnu_vms/data/models/event.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/features/events/events_controller.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

/// Event detail screen for viewing event information and joining.
class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.eventId,
  });

  final EventsController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String eventId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadDetail(widget.eventId);
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
        final event = state.detail;
        final profile = widget.sessionController.profile;
        final isOfficer = profile?.role == UserRole.officer ||
            profile?.role == UserRole.admin;

        if (state.loadingDetail && event == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Event')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (event == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Event')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_busy_rounded, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'Event not found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This event may have been removed or you do not have permission to view it.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go(RouteNames.events),
                      child: const Text('Back to events'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final canManage = isOfficer && event.createdBy == profile?.uid;
        final hasJoined = state.joinRequestStatus != null &&
            state.joinRequestStatus != JoinRequestStatus.none;

        return Scaffold(
          appBar: AppBar(
            title: Text(event.title, overflow: TextOverflow.ellipsis),
            actions: [
              if (canManage)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.go('${RouteNames.eventForm}/${event.eventId}');
                    } else if (value == 'cancel') {
                      _showCancelDialog(context, event);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Cancel', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => widget.controller.loadDetail(widget.eventId),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        child: Image.network(
                          event.imageUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                      const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _EventHeader(event: event, isOfficer: isOfficer),
                    ),
                    const SizedBox(height: 16),
                    _EventDetails(event: event),
                    const SizedBox(height: 16),
                    if (event.description != null && event.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionTitle(title: 'Description'),
                      ),
                    if (event.description != null && event.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Text(
                          event.description!,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _ActionSection(
                        event: event,
                        profile: profile!,
                        hasJoined: hasJoined,
                        joinStatus: state.joinRequestStatus,
                        onJoin: () => widget.controller.requestJoin(event.eventId),
                        onCancelJoin: () => _showCancelJoinDialog(context, event),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel event'),
        content: Text(
          'Are you sure you want to cancel "${event.title}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep event'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.controller.cancelEvent(event.eventId, expectedRevision: 0);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel event'),
          ),
        ],
      ),
    );
  }

  void _showCancelJoinDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel request'),
        content: Text(
          'Cancel your request to join "${event.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep request'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement cancel join request
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel request'),
          ),
        ],
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  const _EventHeader({
    required this.event,
    required this.isOfficer,
  });

  final Event event;
  final bool isOfficer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(status: event.status.wire),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            if (isOfficer)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.go('${RouteNames.eventForm}/${event.eventId}'),
                tooltip: 'Edit event',
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              '${DateHelpers.formatDate(event.start)} – ${DateHelpers.formatTime(event.start)} to ${DateHelpers.formatTime(event.end)}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.venue,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
              ),
            ),
          ],
        ),
        if (event.capacity != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                '${event.attendeesCount} / ${event.capacity} attendees',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
              ),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.group_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Audience: ${event.audience.wire}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

class _EventDetails extends StatelessWidget {
  const _EventDetails({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              label: 'Status',
              value: event.status.wire,
              valueWidget: StatusBadge(status: event.status.wire),
            ),
            _DetailRow(
              label: 'Created by',
              value: event.createdBy,
            ),
            _DetailRow(
              label: 'Created',
              value: DateHelpers.formatDateTime(event.createdAt),
            ),
            _DetailRow(
              label: 'Last updated',
              value: DateHelpers.formatDateTime(event.updatedAt),
            ),
            if (event.revision > 0)
              _DetailRow(label: 'Revision', value: event.revision.toString()),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
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
            child: Text(label, style: TextStyle(color: muted, fontSize: 13)),
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

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.event,
    required this.profile,
    required this.hasJoined,
    required this.joinStatus,
    required this.onJoin,
    required this.onCancelJoin,
  });

  final Event event;
  final UserProfile profile;
  final bool hasJoined;
  final JoinRequestStatus? joinStatus;
  final VoidCallback onJoin;
  final VoidCallback onCancelJoin;

  @override
  Widget build(BuildContext context) {
    final isOfficer = profile.role == UserRole.officer || profile.role == UserRole.admin;
    final isMember = profile.role == UserRole.member;

    if (isOfficer) {
      // Officers see management actions
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: onJoin,
            icon: const Icon(Icons.person_add_rounded, size: 18),
            label: const Text('Manage attendees'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      );
    }

    // Member actions
    if (hasJoined) {
      final statusColor = switch (joinStatus) {
        JoinRequestStatus.approved => Colors.green,
        JoinRequestStatus.pending => Colors.orange,
        JoinRequestStatus.denied => Colors.red,
        JoinRequestStatus.waitlisted => Colors.blue,
        _ => Theme.of(context).colorScheme.onSurfaceVariant,
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.check_circle_outline, size: 18),
            label: Text(_joinStatusLabel(joinStatus)),
            style: FilledButton.styleFrom(
              backgroundColor: statusColor.withAlpha(30),
              foregroundColor: statusColor,
            ),
          ),
          if (joinStatus == JoinRequestStatus.pending || joinStatus == JoinRequestStatus.approved)
            const SizedBox(height: 8),
          if (joinStatus == JoinRequestStatus.pending || joinStatus == JoinRequestStatus.approved)
            OutlinedButton.icon(
              onPressed: onCancelJoin,
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Cancel request'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
        ],
      );
    }

    // Not joined yet
    if (event.isFull) {
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.lock_outline, size: 18),
        label: const Text('Event is full'),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
      );
    }

    if (event.hasEnded) {
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.event_busy_outlined, size: 18),
        label: const Text('Event has ended'),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onJoin,
      icon: const Icon(Icons.login_rounded, size: 18),
      label: const Text('Join event'),
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    );
  }

  String _joinStatusLabel(JoinRequestStatus? status) {
    switch (status) {
      case JoinRequestStatus.approved:
        return 'Joined';
      case JoinRequestStatus.pending:
        return 'Request pending';
      case JoinRequestStatus.denied:
        return 'Request denied';
      case JoinRequestStatus.waitlisted:
        return 'Waitlisted';
      default:
        return 'Status unknown';
    }
  }
}