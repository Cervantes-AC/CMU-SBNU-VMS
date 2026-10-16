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
    final formKey = GlobalKey<FormState>();
    const audiences = [
      'All volunteers',
      'Activity participants',
      'Coordinators',
    ];
    var audience = audiences.first;
    final result = await showDialog<_Announcement>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Draft announcement'),
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
                Navigator.pop(
                  context,
                  _Announcement(
                    titleController.text.trim(),
                    messageController.text.trim(),
                    audience,
                    'Local preview',
                    Icons.campaign_outlined,
                    isDraft: true,
                  ),
                );
              },
              child: const Text('Save local draft'),
            ),
          ],
        ),
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
                    if (item.isDraft)
                      const _DraftBadge()
                    else
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
    this.icon, {
    this.isDraft = false,
  });
  final String title;
  final String message;
  final String audience;
  final String date;
  final IconData icon;
  final bool isDraft;
}

String? _requiredField(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required.' : null;

class _DraftBadge extends StatelessWidget {
  const _DraftBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFBF0D7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'LOCAL DRAFT',
      style: TextStyle(
        color: Color(0xFF6E581F),
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: .4,
      ),
    ),
  );
}
