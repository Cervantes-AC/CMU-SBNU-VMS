import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int _selectedIndex = 0;

  static const _destinations = [
    (Icons.calendar_month_outlined, 'Activities'),
    (Icons.groups_outlined, 'Volunteers'),
    (Icons.grid_view_rounded, 'Overview'),
    (Icons.shield_outlined, 'Safety'),
  ];

  @override
  Widget build(BuildContext context) {
    final title = _destinations[_selectedIndex].$2;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            const Icon(Icons.volunteer_activism, color: Color(0xFF134F35)),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications preview',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: _selectedIndex == 2
            ? const _OverviewContent()
            : _PreviewSection(title: title),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.$1),
              label: destination.$2,
            ),
        ],
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF0D7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.science_outlined, color: Color(0xFF895F00)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Design preview · All figures and activity details are sample data.',
                  style: TextStyle(color: Color(0xFF6E581F), height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Your service at a glance',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 14),
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
              icon: Icons.event_available,
              value: '08',
              label: 'UPCOMING ACTIVITIES',
              tint: Color(0xFFE5EFE7),
              ink: Color(0xFF196142),
            ),
            _MetricCard(
              icon: Icons.schedule,
              value: '24 hrs',
              label: 'SERVICE HOURS',
              tint: Color(0xFFFBF0D7),
              ink: Color(0xFFA9790D),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const _SectionHeading(title: 'Coming up', action: 'View all'),
        const SizedBox(height: 10),
        const _ActivityCard(
          day: '22',
          month: 'OCT',
          title: 'Community preparedness workshop',
          details: 'CMU Campus · Sample activity',
          color: Color(0xFFE1EEE4),
        ),
        const SizedBox(height: 10),
        const _ActivityCard(
          day: '26',
          month: 'OCT',
          title: 'Campus greening day',
          details: 'University grounds · Sample activity',
          color: Color(0xFFE4EDF0),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCECE9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFFB63D34),
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safety center',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Emergency tools are not connected in this preview.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF748078),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF89948C)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
    required this.ink,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color tint;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 52) / 2,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: ink),
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  letterSpacing: 0.7,
                  color: Color(0xFF748078),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4C735E),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.day,
    required this.month,
    required this.title,
    required this.details,
    required this.color,
  });

  final String day;
  final String month;
  final String title;
  final String details;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 8,
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF748078),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFADB5AF)),
          ],
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction_outlined,
              size: 42,
              color: Color(0xFF47745A),
            ),
            const SizedBox(height: 14),
            Text(
              '$title preview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            const Text(
              'This workspace area is part of the design preview. Connected records and actions are not available yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF748078), height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
