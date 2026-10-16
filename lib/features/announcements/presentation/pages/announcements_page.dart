import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/announcements_repository.dart';
import '../../data/models/announcement.dart';
import '../view_models/announcements_view_model.dart';

/// Announcements page - feed and publishing.
class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Announcements'),
          ),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.published.isEmpty
                ? const AppEmptyState(
                    icon: Icons.campaign_outlined,
                    title: 'No announcements.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.published.length,
                    itemBuilder: (context, index) {
                      final a = viewModel.published[index];
                      return _AnnouncementCard(announcement: a);
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

  void _showCreateDialog(BuildContext context, AnnouncementsViewModel viewModel) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              controller: titleController,
              label: 'Title',
              icon: Icons.title_outlined,
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: bodyController,
              label: 'Message',
              maxLines: 4,
              icon: Icons.message_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Publish',
            onPressed: () {
              if (titleController.text.isEmpty || bodyController.text.isEmpty) return;
              Navigator.of(context).pop();
              viewModel.createAnnouncement(Announcement(
                id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
                title: titleController.text.trim(),
                body: bodyController.text.trim(),
                audienceRule: 'all',
                status: AnnouncementStatus.published,
                authorUid: 'current_user',
                publishAt: DateTime.now(),
              ));
            },
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EFE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    announcement.statusLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF196142),
                    ),
                  ),
                ),
                if (announcement.priority == 'high') ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCECE9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'HIGH',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB63D34),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17231C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.body,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF68766D),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${announcement.publishAt.month}/${announcement.publishAt.day}/${announcement.publishAt.year}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF748078),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
