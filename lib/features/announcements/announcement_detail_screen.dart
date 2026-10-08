import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/constants/route_names.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/announcement.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/announcements/announcements_controller.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

/// Announcement detail screen for viewing announcement content.
class AnnouncementDetailScreen extends StatefulWidget {
  const AnnouncementDetailScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.announcementId,
  });

  final AnnouncementsController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String announcementId;

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadDetail(widget.announcementId);
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
        final announcement = state.detail;
        final profile = widget.sessionController.profile;
        final isOfficer = profile?.role == UserRole.officer ||
            profile?.role == UserRole.admin;

        if (state.loadingDetail && announcement == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Announcement')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (announcement == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Announcement')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.announcement_outlined, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'Announcement not found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This announcement may have been removed or you do not have permission to view it.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go(RouteNames.announcements),
                      child: const Text('Back to announcements'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final canManage = isOfficer && announcement.createdBy == profile?.uid;

        return Scaffold(
          appBar: AppBar(
            title: Text(announcement.title, overflow: TextOverflow.ellipsis),
            actions: [
              if (canManage)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.go('${RouteNames.announcementForm}/${announcement.id}');
                    } else if (value == 'publish' && announcement.status == AnnouncementStatus.draft) {
                      _publishAnnouncement(announcement);
                    } else if (value == 'unpublish' && announcement.status == AnnouncementStatus.published) {
                      _unpublishAnnouncement(announcement);
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
                    if (announcement.status == AnnouncementStatus.draft)
                      const PopupMenuItem(
                        value: 'publish',
                        child: Row(
                          children: [
                            Icon(Icons.publish_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Publish'),
                          ],
                        ),
                      ),
                    if (announcement.status == AnnouncementStatus.published)
                      const PopupMenuItem(
                        value: 'unpublish',
                        child: Row(
                          children: [
                            Icon(Icons.unpublished_outlined, size: 18, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Unpublish', style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => widget.controller.loadDetail(widget.announcementId),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        child: Image.network(
                          announcement.imageUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
                      const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _AnnouncementHeader(
                        announcement: announcement,
                        isOfficer: isOfficer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _AnnouncementDetails(announcement: announcement),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SectionTitle(title: 'Content'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        announcement.body,
                        style: const TextStyle(fontSize: 14, height: 1.5),
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

  void _publishAnnouncement(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish announcement'),
        content: Text(
          'Publish "${announcement.title}"? It will become visible to the ${announcement.audience.wire} audience.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.controller.publishAnnouncement(announcement.id, expectedRevision: 0);
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _unpublishAnnouncement(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unpublish announcement'),
        content: Text(
          'Unpublish "${announcement.title}"? It will no longer be visible to members.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.controller.unpublishAnnouncement(announcement.id, expectedRevision: 0);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Unpublish'),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementHeader extends StatelessWidget {
  const _AnnouncementHeader({
    required this.announcement,
    required this.isOfficer,
  });

  final Announcement announcement;
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
                  StatusBadge(status: announcement.status.wire),
                  const SizedBox(height: 8),
                  Text(
                    announcement.title,
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
                onPressed: () => context.go('${RouteNames.announcementForm}/${announcement.id}'),
                tooltip: 'Edit announcement',
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Published: ${DateHelpers.formatDate(announcement.publishAt)}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.event_busy_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Expires: ${DateHelpers.formatDate(announcement.expiresAt)}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.flag_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            StatusBadge(status: announcement.priority.wire),
            const SizedBox(width: 12),
            Icon(Icons.group_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Audience: ${announcement.audience.wire}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnnouncementDetails extends StatelessWidget {
  const _AnnouncementDetails({required this.announcement});

  final Announcement announcement;

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
              value: announcement.status.wire,
              valueWidget: StatusBadge(status: announcement.status.wire),
            ),
            _DetailRow(
              label: 'Priority',
              value: announcement.priority.wire,
            ),
            _DetailRow(
              label: 'Audience',
              value: announcement.audience.wire,
            ),
            _DetailRow(
              label: 'Created by',
              value: announcement.createdBy,
            ),
            _DetailRow(
              label: 'Created',
              value: DateHelpers.formatDateTime(announcement.createdAt),
            ),
            _DetailRow(
              label: 'Last updated',
              value: DateHelpers.formatDateTime(announcement.updatedAt),
            ),
            if (announcement.revision > 0)
              _DetailRow(label: 'Revision', value: announcement.revision.toString()),
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