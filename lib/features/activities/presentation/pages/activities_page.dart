import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/activity.dart';
import '../view_models/activities_view_model.dart';

/// Activities page - browse and manage activities.
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesViewModel>(
      builder: (context, viewModel, _) {
        final activities = viewModel.publishedActivities;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Activities'),
            actions: [
              IconButton(
                tooltip: 'Create activity',
                onPressed: () => _showCreateDialog(context, viewModel),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: activities.isEmpty
                ? const AppEmptyState(
                    icon: Icons.event_outlined,
                    title: 'No activities available.',
                    subtitle: 'Check back later for new service opportunities.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return _ActivityCard(
                        activity: activity,
                        onTap: () => viewModel.selectActivity(activity),
                        onJoin: () =>
                            viewModel.joinActivity(activity.id, 'current_user'),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateDialog(context, viewModel),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context, ActivitiesViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => const _CreateActivityDialog(),
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_outlined,
                  color: Color(0xFF134F35),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17231C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.scheduleLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF68766D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.venue,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF68766D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EFE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        activity.statusLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF196142),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(label: 'Join', onPressed: onJoin, isOutlined: true),
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
    return AlertDialog(
      title: const Text('Create Activity'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInputField(
                controller: _titleController,
                label: 'Title',
                hint: 'e.g. Community Tree Planting',
                icon: Icons.event_outlined,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 12),
              AppInputField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the activity',
                icon: Icons.description_outlined,
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 12),
              AppInputField(
                controller: _venueController,
                label: 'Venue',
                hint: 'e.g. Botanical Garden',
                icon: Icons.location_on_outlined,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Venue is required'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Create',
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
