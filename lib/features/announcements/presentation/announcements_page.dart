import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/announcement.dart';
import 'view_models/announcements_view_model.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  bool _showArchived = false;
  Future<void> _compose(
    BuildContext context,
    AnnouncementsViewModel viewModel, {
    Announcement? existing,
  }) async {
    final titleController = TextEditingController(text: existing?.title);
    final messageController = TextEditingController(text: existing?.message);
    final formKey = GlobalKey<FormState>();
    const audiences = [
      'All volunteers',
      'Activity participants',
      'Coordinators',
    ];
    var audience = existing?.audience ?? audiences.first;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Draft announcement' : 'Edit draft'),
          content: SizedBox(
            width: 420,
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
                        controller: titleController,
                        maxLength: 100,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: _requiredField,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: messageController,
                        maxLength: 800,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          alignLabelWithHint: true,
                        ),
                        validator: _requiredField,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: audience,
                        decoration: const InputDecoration(
                          labelText: 'Sample audience',
                          helperText:
                              'Audience groups are examples for this draft.',
                        ),
                        items: audiences
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setDialogState(() => audience = value ?? audience),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Saved to this screen only. No audience receives a message; publishing, permissions, and delivery are not connected.',
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                Navigator.pop(context, true);
              },
              child: Text(
                existing == null ? 'Save local draft' : 'Save changes',
              ),
            ),
          ],
        ),
      ),
    );
    final title = titleController.text;
    final message = messageController.text;
    titleController.dispose();
    messageController.dispose();
    if (saved == true && mounted) {
      viewModel.saveDraft(
        id: existing?.id,
        title: title,
        message: message,
        audience: audience,
      );
    }
  }

  Future<void> _setArchived(
    BuildContext context,
    AnnouncementsViewModel viewModel,
    Announcement item,
    bool archived,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          archived ? 'Archive this local draft?' : 'Restore this draft?',
        ),
        content: Text(
          archived
              ? 'The draft will move to the archived view on this screen only.'
              : 'The draft will return to the active view on this screen only.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(archived ? 'Archive draft' : 'Restore draft'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    viewModel.setDraftArchived(item.id, archived);
  }

  @override
  Widget build(BuildContext context) => Consumer<AnnouncementsViewModel>(
    builder: (context, viewModel, _) {
      final visibleItems = viewModel.announcements
          .where((item) => item.isArchived == _showArchived)
          .toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Communications center',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFAA7C10),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Announcements',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Draft announcement',
                onPressed: () => _compose(context, viewModel),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Sample updates for a volunteer audience. Publishing and notifications are not connected.',
            style: TextStyle(color: Color(0xFF748078), height: 1.4),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Active')),
              ButtonSegment(value: true, label: Text('Archived')),
            ],
            selected: {_showArchived},
            onSelectionChanged: (value) =>
                setState(() => _showArchived = value.first),
          ),
          const SizedBox(height: 12),
          if (visibleItems.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  _showArchived
                      ? 'No local drafts have been archived.'
                      : 'No announcements in this view.',
                  style: const TextStyle(color: Color(0xFF748078)),
                ),
              ),
            ),
          for (final item in visibleItems)
            Card(
              margin: const EdgeInsets.only(bottom: 11),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5EFE7),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            _announcementIcon(item.kind),
                            size: 19,
                            color: const Color(0xFF196142),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (item.isArchived)
                          const _DraftBadge(label: 'ARCHIVED')
                        else if (item.isDraft)
                          const _DraftBadge()
                        else if (!item.isDraft)
                          const Icon(
                            Icons.more_horiz,
                            color: Color(0xFF89948C),
                          ),
                        if (item.isDraft) ...[
                          const SizedBox(width: 4),
                          PopupMenuButton<_DraftAction>(
                            tooltip: 'Draft actions',
                            onSelected: (action) {
                              switch (action) {
                                case _DraftAction.edit:
                                  _compose(context, viewModel, existing: item);
                                case _DraftAction.archive:
                                  _setArchived(context, viewModel, item, true);
                                case _DraftAction.restore:
                                  _setArchived(context, viewModel, item, false);
                              }
                            },
                            itemBuilder: (context) => [
                              if (item.isArchived)
                                const PopupMenuItem(
                                  value: _DraftAction.restore,
                                  child: Text('Restore'),
                                )
                              else ...[
                                const PopupMenuItem(
                                  value: _DraftAction.edit,
                                  child: Text('Edit draft'),
                                ),
                                const PopupMenuItem(
                                  value: _DraftAction.archive,
                                  child: Text('Archive draft'),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.message,
                      style: const TextStyle(
                        height: 1.45,
                        color: Color(0xFF59685E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 14,
                          color: Color(0xFF748078),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item.audience,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF748078),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.dateLabel,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF748078),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}

enum _DraftAction { edit, archive, restore }

IconData _announcementIcon(AnnouncementKind kind) => switch (kind) {
  AnnouncementKind.general => Icons.groups_outlined,
  AnnouncementKind.activity => Icons.event_outlined,
  AnnouncementKind.reminder => Icons.edit_note_outlined,
  AnnouncementKind.draft => Icons.campaign_outlined,
};

String? _requiredField(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required.' : null;

class _DraftBadge extends StatelessWidget {
  const _DraftBadge({this.label = 'LOCAL DRAFT'});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFBF0D7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Color(0xFF6E581F),
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: .4,
      ),
    ),
  );
}
