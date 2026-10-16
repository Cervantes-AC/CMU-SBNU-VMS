import 'package:flutter/material.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  String _filter = 'All';
  final Set<String> _joined = {};

  final List<_Activity> _activities = [
    const _Activity(
      'Campus preparedness workshop',
      'Safety',
      'Oct 22 · 9:00 AM',
      'University Convention Center',
      24,
      40,
    ),
    const _Activity(
      'Community river clean-up',
      'Environment',
      'Oct 26 · 6:30 AM',
      'Sawaga River access point',
      18,
      30,
    ),
    const _Activity(
      'First aid skills session',
      'Training',
      'Nov 02 · 1:00 PM',
      'College of Nursing',
      12,
      24,
    ),
    const _Activity(
      'Community learning day',
      'Community',
      'Nov 08 · 8:00 AM',
      'CMU Main Campus',
      31,
      50,
    ),
  ];

  Future<void> _createActivity() async {
    final title = TextEditingController();
    final venue = TextEditingController();
    String category = 'Community';
    final created = await showDialog<_Activity>(
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
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items:
                      const ['Environment', 'Safety', 'Training', 'Community']
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = title.text.trim();
                final place = venue.text.trim();
                if (name.isNotEmpty && place.isNotEmpty) {
                  Navigator.pop(
                    context,
                    _Activity(
                      name,
                      category,
                      'Schedule to be set',
                      place,
                      0,
                      20,
                    ),
                  );
                }
              },
              child: const Text('Save local draft'),
            ),
          ],
        ),
      ),
    );
    title.dispose();
    venue.dispose();
    if (created != null && mounted) {
      setState(() => _activities.insert(0, created));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter == 'All'
        ? _activities
        : _activities
              .where((activity) => activity.category == _filter)
              .toList();
    return ListView(
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
              onPressed: _createActivity,
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
              for (final filter in [
                'All',
                'Safety',
                'Environment',
                'Training',
                'Community',
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (final activity in visible)
          _ActivityCard(
            activity: activity,
            joined: _joined.contains(activity.title),
            onJoin: () => setState(() {
              if (!_joined.add(activity.title)) _joined.remove(activity.title);
            }),
          ),
      ],
    );
  }
}

class _Activity {
  const _Activity(
    this.title,
    this.category,
    this.date,
    this.venue,
    this.joined,
    this.capacity,
  );
  final String title;
  final String category;
  final String date;
  final String venue;
  final int joined;
  final int capacity;
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.joined,
    required this.onJoin,
  });
  final _Activity activity;
  final bool joined;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final percent = activity.joined / activity.capacity;
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
                    activity.category.toUpperCase(),
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
                  activity.date,
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
                  '${activity.joined} of ${activity.capacity} places',
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
                  joined ? Icons.check : Icons.arrow_forward,
                  size: 16,
                ),
                label: Text(joined ? 'Joined in preview' : 'Request to join'),
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
