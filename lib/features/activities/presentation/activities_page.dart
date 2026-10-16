import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/activity.dart';
import 'view_models/activities_view_model.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  Future<void> _createActivity(BuildContext context) async {
    final title = TextEditingController();
    final venue = TextEditingController();
    var category = ActivityCategory.community;
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Activity draft'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Activity name'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ActivityCategory>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ActivityCategory.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(_categoryLabel(value)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => category = value ?? category),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: venue,
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Venue'),
                ),
                const Text(
                  'Saved only in this session. Publishing and participation are not connected.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF748078)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isNotEmpty &&
                    venue.text.trim().isNotEmpty) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Save local draft'),
            ),
          ],
        ),
      ),
    );
    if (created == true && context.mounted) {
      context.read<ActivitiesViewModel>().createDraft(
        title: title.text,
        category: category,
        venue: venue.text,
      );
    }
    title.dispose();
    venue.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<ActivitiesViewModel>(
    builder: (context, viewModel, _) => ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Discover and participate',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFAA7C10),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Create local activity draft',
              onPressed: () => _createActivity(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Build community through action.',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        const Text(
          'Browse sample opportunities and reserve a place in this local preview.',
          style: TextStyle(color: Color(0xFF748078), height: 1.4),
        ),
        const SizedBox(height: 18),
        const _SampleNotice(),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final filter in [null, ...ActivityCategory.values])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      filter == null ? 'All' : _categoryLabel(filter),
                    ),
                    selected: viewModel.categoryFilter == filter,
                    onSelected: (_) => viewModel.setCategoryFilter(filter),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (final activity in viewModel.visibleActivities)
          _ActivityCard(
            activity: activity,
            onJoin: () => viewModel.toggleJoinRequest(activity.id),
          ),
      ],
    ),
  );
}

String _categoryLabel(ActivityCategory category) => switch (category) {
  ActivityCategory.environment => 'Environment',
  ActivityCategory.safety => 'Safety',
  ActivityCategory.training => 'Training',
  ActivityCategory.community => 'Community',
};

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.onJoin});
  final Activity activity;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final percent = activity.joinedCount / activity.capacity;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    activity.status == ActivityStatus.draft
                        ? 'LOCAL DRAFT'
                        : _categoryLabel(activity.category).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFAA7C10),
                      fontSize: 9,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: Color(0xFF748078),
                ),
                const SizedBox(width: 5),
                Text(
                  activity.scheduleLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF65746A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              activity.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 15,
                  color: Color(0xFF748078),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    activity.venue,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF748078),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Text(
                  '${activity.joinedCount} of ${activity.capacity} places',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(percent * 100).round()}% full',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF748078),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF27724D),
              backgroundColor: const Color(0xFFE9EEE9),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onJoin,
                icon: Icon(
                  activity.joinRequested ? Icons.check : Icons.arrow_forward,
                  size: 16,
                ),
                label: Text(
                  activity.joinRequested
                      ? 'Join request in preview'
                      : 'Request to join',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleNotice extends StatelessWidget {
  const _SampleNotice();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFBF0D7),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      children: [
        Icon(Icons.science_outlined, color: Color(0xFF895F00), size: 18),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Sample activities only. Join requests are not submitted to a server.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: Color(0xFF6E581F),
            ),
          ),
        ),
      ],
    ),
  );
}
