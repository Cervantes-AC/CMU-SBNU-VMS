import 'package:flutter/material.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final List<_Announcement> _items = [
    const _Announcement(
      'Volunteer orientation schedule',
      'Welcome session dates and preparation notes for new volunteers.',
      'Unit members',
      'Sample · Oct 14',
      Icons.groups_outlined,
    ),
    const _Announcement(
      'Preparedness workshop registration',
      'A sample training notice for the upcoming campus preparedness workshop.',
      'Activity participants',
      'Sample · Oct 12',
      Icons.event_outlined,
    ),
    const _Announcement(
      'Service reflection submissions',
      'Reminder to review your learning notes after a completed activity.',
      'All volunteers',
      'Sample · Oct 08',
      Icons.edit_note_outlined,
    ),
  ];

  Future<void> _compose() async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final result = await showDialog<_Announcement>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Draft announcement'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This saves to this screen only. Audience delivery is not connected.',
                style: TextStyle(fontSize: 11, color: Color(0xFF748078)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty ||
                  messageController.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(
                context,
                _Announcement(
                  titleController.text.trim(),
                  messageController.text.trim(),
                  'Draft',
                  'Local preview',
                  Icons.campaign_outlined,
                ),
              );
            },
            child: const Text('Save draft'),
          ),
        ],
      ),
    );
    titleController.dispose();
    messageController.dispose();
    if (result != null && mounted) setState(() => _items.insert(0, result));
  }

  @override
  Widget build(BuildContext context) => ListView(
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Draft announcement',
            onPressed: _compose,
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
      for (final item in _items)
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
                        item.icon,
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
                    const Icon(Icons.more_horiz, color: Color(0xFF89948C)),
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
                      item.date,
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
}

class _Announcement {
  const _Announcement(
    this.title,
    this.message,
    this.audience,
    this.date,
    this.icon,
  );
  final String title;
  final String message;
  final String audience;
  final String date;
  final IconData icon;
}
