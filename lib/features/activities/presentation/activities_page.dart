import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/models/activity.dart';
import 'view_models/activities_view_model.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  Future<void> _createActivity(
    BuildContext context, {
    Activity? existing,
  }) async {
    final title = TextEditingController(text: existing?.title);
    final venue = TextEditingController(text: existing?.venue);
    final schedule = TextEditingController(text: existing?.scheduleLabel);
    final description = TextEditingController(text: existing?.description);
    final capacity = TextEditingController(text: '${existing?.capacity ?? 20}');
    final formKey = GlobalKey<FormState>();
    var category = existing?.category ?? ActivityCategory.community;
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            existing == null ? 'Activity draft' : 'Edit local activity draft',
          ),
          content: SizedBox(
            width: 440,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .65,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: title,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: 'Activity name',
                        ),
                        validator: _requiredField,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ActivityCategory>(
                        initialValue: category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
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
                      TextFormField(
                        controller: schedule,
                        maxLength: 80,
                        decoration: const InputDecoration(
                          labelText: 'Schedule',
                          hintText: 'e.g. Nov 08 · 8:00 AM',
                        ),
                        validator: _requiredField,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: venue,
                        maxLength: 120,
                        decoration: const InputDecoration(labelText: 'Venue'),
                        validator: _requiredField,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: description,
                        maxLength: 500,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                        ),
                        validator: _requiredField,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: capacity,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Volunteer capacity',
                        ),
                        validator: (value) {
                          final parsed = int.tryParse(value ?? '');
                          if (parsed == null || parsed < 1) {
                            return 'Enter a whole number greater than zero.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Saved only in this session as a draft. Publishing and participation are not connected.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF748078),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(
                existing == null ? 'Save local draft' : 'Save draft changes',
              ),
            ),
          ],
        ),
      ),
    );
    if (created == true && context.mounted) {
      final viewModel = context.read<ActivitiesViewModel>();
      if (existing == null) {
        viewModel.createDraft(
          title: title.text,
          category: category,
          scheduleLabel: schedule.text,
          venue: venue.text,
          description: description.text,
          capacity: int.parse(capacity.text),
        );
      } else {
        viewModel.updateDraft(
          id: existing.id,
          title: title.text,
          category: category,
          scheduleLabel: schedule.text,
          venue: venue.text,
          description: description.text,
          capacity: int.parse(capacity.text),
        );
      }
    }
    title.dispose();
    venue.dispose();
    schedule.dispose();
    description.dispose();
    capacity.dispose();
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
            onDetails: () => _showDetails(context, activity),
            onEditDraft: () => _createActivity(context, existing: activity),
            onDiscardDraft: () => _discardDraft(context, activity),
            onJoin: () => viewModel.toggleJoinRequest(activity.id),
          ),
      ],
    ),
  );

  Future<void> _showDetails(
    BuildContext context,
    Activity activity,
  ) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(activity.title),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.description.isEmpty
                    ? 'No description was provided for this sample activity.'
                    : activity.description,
                style: const TextStyle(height: 1.45),
              ),
              const SizedBox(height: 16),
              _ActivityDetailRow(Icons.event_outlined, activity.scheduleLabel),
              const SizedBox(height: 8),
              _ActivityDetailRow(Icons.place_outlined, activity.venue),
              const SizedBox(height: 8),
              _ActivityDetailRow(
                Icons.groups_outlined,
                '${activity.joinedCount} of ${activity.capacity} places shown',
              ),
              const SizedBox(height: 12),
              const Text(
                'Sample preview · details and join requests are not connected to a service.',
                style: TextStyle(fontSize: 11, color: Color(0xFF748078)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );

  Future<void> _discardDraft(BuildContext context, Activity activity) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard local activity draft?'),
        content: Text(
          '“${activity.title}” will be removed from this session. Published samples are unaffected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep draft'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard draft'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ActivitiesViewModel>().discardDraft(activity.id);
    }
  }
}

String? _requiredField(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required.' : null;

String _categoryLabel(ActivityCategory category) => switch (category) {
  ActivityCategory.environment => 'Environment',
  ActivityCategory.safety => 'Safety',
  ActivityCategory.training => 'Training',
  ActivityCategory.community => 'Community',
};

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.onDetails,
    required this.onEditDraft,
    required this.onDiscardDraft,
    required this.onJoin,
  });
  final Activity activity;
  final VoidCallback onDetails;
  final VoidCallback onEditDraft;
  final VoidCallback onDiscardDraft;
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
            Row(
              children: [
                TextButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Details'),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: activity.status == ActivityStatus.draft
                      ? onEditDraft
                      : onJoin,
                  icon: Icon(
                    activity.status == ActivityStatus.draft
                        ? Icons.edit_outlined
                        : activity.joinRequested
                        ? Icons.check
                        : Icons.arrow_forward,
                    size: 16,
                  ),
                  label: Text(
                    activity.status == ActivityStatus.draft
                        ? 'Edit local draft'
                        : activity.joinRequested
                        ? 'Join request in preview'
                        : 'Request to join',
                  ),
                ),
                if (activity.status == ActivityStatus.draft) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Discard local draft',
                    onPressed: onDiscardDraft,
                    icon: const Icon(Icons.delete_outline),
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

class _ActivityDetailRow extends StatelessWidget {
  const _ActivityDetailRow(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 17, color: const Color(0xFF748078)),
      const SizedBox(width: 9),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
    ],
  );
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
