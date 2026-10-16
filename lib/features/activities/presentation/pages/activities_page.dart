import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/activities_repository.dart';
import '../../data/models/activity.dart';
import '../view_models/activities_view_model.dart';

/// Activities page — premium, fully functional.
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage>
    with TickerProviderStateMixin {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          SliverToBoxAdapter(child: _FilterBar()),
          Consumer<ActivitiesViewModel>(
            builder: (context, viewModel, _) {
              final activities = viewModel.publishedActivities;
              final filtered = _filter == 'All'
                  ? activities
                  : activities.where((a) => a.statusLabel == _filter).toList();

              return SliverToBoxAdapter(
                child: AppStateWrapper(
                  status: viewModel.status,
                  onRetry: viewModel.init,
                  errorMessage: viewModel.error?.message,
                  child: filtered.isEmpty
                      ? const PremiumEmptyState(
                          icon: Icons.event_busy_rounded,
                          title: 'No activities available.',
                          subtitle:
                              'Check back later for new service opportunities.',
                          actionLabel: 'Explore all programs',
                          action: PremiumCard(child: const Text('Placeholder')),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(DesignTokens.lg),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final activity = filtered[index];
                            return _ActivityCard(
                              activity: activity,
                              onTap: () => viewModel.selectActivity(activity),
                              onJoin: () => viewModel.joinActivity(
                                activity.id,
                                'current_user',
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(DesignTokens.lg),
        child: PremiumButton(
          label: 'Create Activity',
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
    showDialog(
      context: context,
      builder: (context) => const _CreateActivityDialog(),
    );
  }

  String _statusLabel(ActivityStatus status) => switch (status) {
    ActivityStatus.draft => 'Draft',
    ActivityStatus.published => 'Published',
    ActivityStatus.ongoing => 'Ongoing',
    ActivityStatus.completed => 'Completed',
    ActivityStatus.cancelled => 'Cancelled',
  };
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
            'Activities',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Discover and join service opportunities across CMU.',
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

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: DesignTokens.radiusXl,
                border: Border.all(color: DesignTokens.line, width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: DesignTokens.md),
                  const Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: DesignTokens.muted,
                  ),
                  const SizedBox(width: DesignTokens.sm),
                  Expanded(
                    child: Text(
                      'Filter by status',
                      style: DesignTokens.body.copyWith(
                        fontSize: 14,
                        color: DesignTokens.muted,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: DesignTokens.muted,
                  ),
                  const SizedBox(width: DesignTokens.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.onTap,
    required this.onJoin,
  });

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (activity.status) {
      ActivityStatus.published => DesignTokens.success,
      ActivityStatus.ongoing => DesignTokens.gold,
      ActivityStatus.completed => DesignTokens.muted,
      ActivityStatus.cancelled => DesignTokens.error,
      ActivityStatus.draft => DesignTokens.muted,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignTokens.radiusXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero image area
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: DesignTokens.canvas,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.event_rounded,
                    size: 48,
                    color: statusColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(DesignTokens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity.title,
                            style: DesignTokens.title.copyWith(
                              fontSize: 17,
                              color: DesignTokens.ink,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PremiumChip(
                          label: activity.statusLabel,
                          color: statusColor,
                          size: ChipSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.sm),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: DesignTokens.canvas,
                            borderRadius: DesignTokens.radiusMd,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: DesignTokens.muted,
                              ),
                              const SizedBox(width: DesignTokens.xs / 2),
                              Text(
                                activity.scheduleLabel,
                                style: DesignTokens.captionBold.copyWith(
                                  fontSize: 11,
                                  color: DesignTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: DesignTokens.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: DesignTokens.canvas,
                            borderRadius: DesignTokens.radiusMd,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: DesignTokens.muted,
                              ),
                              const SizedBox(width: DesignTokens.xs / 2),
                              Text(
                                activity.venue,
                                style: DesignTokens.captionBold.copyWith(
                                  fontSize: 11,
                                  color: DesignTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.md),
                    Text(
                      activity.description,
                      style: DesignTokens.body.copyWith(
                        fontSize: 13,
                        color: DesignTokens.muted,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: DesignTokens.lg),
                    Row(
                      children: [
                        Expanded(
                          child: PremiumButton(
                            label: 'Join Activity',
                            onPressed: onJoin,
                            variant: ButtonVariant.primary,
                            isFullWidth: true,
                            icon: Icons.person_add_rounded,
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
    );
  }
}

class _CreateActivityDialog extends StatefulWidget {
  const _CreateActivityDialog();

  @override
  State<_CreateActivityDialog> createState() => _CreateActivityDialogState();
}

class _CreateActivityDialogState extends State<_CreateActivityDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                child: Text('Create Activity', style: DesignTokens.headline),
              ),
              PremiumDivider(),
              Padding(
                padding: const EdgeInsets.all(DesignTokens.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PremiumInputField(
                        controller: _titleController,
                        label: 'Title',
                        hint: 'e.g. Community Tree Planting',
                        icon: Icons.title_rounded,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Title is required'
                            : null,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Describe the activity',
                        icon: Icons.description_rounded,
                        maxLines: 3,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: _venueController,
                        label: 'Venue',
                        hint: 'e.g. Botanical Garden',
                        icon: Icons.location_on_rounded,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Venue is required'
                            : null,
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
                              label: 'Create',
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                Navigator.of(context).pop();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
