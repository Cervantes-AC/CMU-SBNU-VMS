import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/announcements_repository.dart';
import '../../data/models/announcement.dart';
import '../view_models/announcements_view_model.dart';

/// Announcements page — premium, fully functional.
class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          Consumer<AnnouncementsViewModel>(
            builder: (context, viewModel, _) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    AppStateWrapper(
                      status: viewModel.status,
                      onRetry: viewModel.init,
                      errorMessage: viewModel.error?.message,
                      child: viewModel.published.isEmpty
                          ? const PremiumEmptyState(
                              icon: Icons.campaign_outlined,
                              title: 'No announcements.',
                              subtitle:
                                  'Stay tuned for updates from the SBNU team.',
                            )
                          : Padding(
                              padding: const EdgeInsets.all(DesignTokens.lg),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.published.length,
                                itemBuilder: (context, index) {
                                  final a = viewModel.published[index];
                                  return _AnnouncementCard(announcement: a);
                                },
                              ),
                            ),
                    ),
                    const SizedBox(height: DesignTokens.xxl),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(DesignTokens.lg),
        child: PremiumButton(
          label: 'Publish Announcement',
          onPressed: () => _showCreateDialog(context),
          icon: Icons.add_circle_rounded,
          isFullWidth: false,
          variant: ButtonVariant.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PremiumCard(
          elevation: 3,
          borderRadius: DesignTokens.radiusXl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(DesignTokens.lg),
                  child: Text(
                    'Publish Announcement',
                    style: DesignTokens.headline,
                  ),
                ),
                PremiumDivider(),
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PremiumInputField(
                        controller: titleController,
                        label: 'Title',
                        hint: 'e.g. Tree Planting This Saturday',
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: bodyController,
                        label: 'Message',
                        hint: 'Write your announcement...',
                        icon: Icons.message_rounded,
                        maxLines: 4,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumChip(
                              label: 'All Volunteers',
                              color: DesignTokens.forest,
                              size: ChipSize.md,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumButton(
                              label: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                              variant: ButtonVariant.outline,
                              isFullWidth: true,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.md),
                          Expanded(
                            child: PremiumButton(
                              label: 'Publish',
                              onPressed: () {
                                if (titleController.text.isEmpty ||
                                    bodyController.text.isEmpty)
                                  return;
                                Navigator.of(context).pop();
                                context
                                    .read<AnnouncementsViewModel>()
                                    .createAnnouncement(
                                      Announcement(
                                        id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
                                        title: titleController.text.trim(),
                                        body: bodyController.text.trim(),
                                        audienceRule: 'all',
                                        status: AnnouncementStatus.published,
                                        authorUid: 'current_user',
                                        publishAt: DateTime.now(),
                                      ),
                                    );
                              },
                              variant: ButtonVariant.primary,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xl,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Announcements',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Stay informed with updates from the SBNU team.',
            style: DesignTokens.body.copyWith(
              fontSize: 15,
              color: DesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final isHigh = announcement.priority == 'high';
    final statusColor = announcement.isPublished
        ? DesignTokens.success
        : DesignTokens.muted;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        child: InkWell(
          borderRadius: DesignTokens.radiusXl,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    PremiumChip(
                      label: announcement.statusLabel,
                      color: statusColor,
                      size: ChipSize.sm,
                    ),
                    if (isHigh) ...[
                      const SizedBox(width: DesignTokens.sm),
                      PremiumChip(
                        label: 'HIGH PRIORITY',
                        color: DesignTokens.error,
                        size: ChipSize.sm,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: DesignTokens.md),
                Text(
                  announcement.title,
                  style: DesignTokens.title.copyWith(
                    fontSize: 17,
                    color: DesignTokens.ink,
                  ),
                ),
                const SizedBox(height: DesignTokens.sm),
                Text(
                  announcement.body,
                  style: DesignTokens.body.copyWith(
                    fontSize: 13,
                    color: DesignTokens.muted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: DesignTokens.lg),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: DesignTokens.muted,
                    ),
                    const SizedBox(width: DesignTokens.xs / 2),
                    Text(
                      '${announcement.publishAt.month}/${announcement.publishAt.day}/${announcement.publishAt.year}',
                      style: DesignTokens.caption.copyWith(
                        color: DesignTokens.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
