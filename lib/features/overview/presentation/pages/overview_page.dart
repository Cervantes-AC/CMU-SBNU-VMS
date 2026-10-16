import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/features/access_control/presentation/pages/access_control_page.dart';
import 'package:cmu_sbnu_vms/features/activities/data/models/activity.dart';
import 'package:cmu_sbnu_vms/features/activities/presentation/pages/activities_page.dart';
import 'package:cmu_sbnu_vms/features/activities/presentation/view_models/activities_view_model.dart';
import 'package:cmu_sbnu_vms/features/announcements/presentation/pages/announcements_page.dart';
import 'package:cmu_sbnu_vms/features/attendance/presentation/pages/attendance_page.dart';
import 'package:cmu_sbnu_vms/features/emergency/presentation/pages/emergency_page.dart';
import 'package:cmu_sbnu_vms/features/reporting/presentation/pages/reports_page.dart';
import 'package:cmu_sbnu_vms/features/volunteers/presentation/pages/volunteers_page.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeSection = 'Overview';

  static const _destinations = [
    (Icons.grid_view_rounded, 'Overview'),
    (Icons.calendar_month_outlined, 'Activities'),
    (Icons.groups_outlined, 'Volunteers'),
    (Icons.fact_check_outlined, 'Attendance'),
    (Icons.campaign_outlined, 'Announcements'),
    (Icons.shield_outlined, 'Emergency & safety'),
    (Icons.insights_outlined, 'Reports'),
    (Icons.admin_panel_settings_outlined, 'Access & operations'),
  ];

  @override
  Widget build(BuildContext context) {
    final title = _activeSection;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 20,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Open workspace navigation',
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/sbnu_app_icon.png',
              width: 34,
              height: 34,
              semanticLabel: 'SBNU logo',
            ),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Return to landing page',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: _PreviewBadge(),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _destinations.indexWhere(
          (item) => item.$2 == _activeSection,
        ),
        onDestinationSelected: (index) {
          setState(() => _activeSection = _destinations[index].$2);
          _scaffoldKey.currentState?.closeDrawer();
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 16, 16),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/sbnu_app_icon.png',
                  width: 38,
                  height: 38,
                  semanticLabel: 'SBNU logo',
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SBNu',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'VOLUNTEER WORKSPACE',
                      style: TextStyle(fontSize: 9, letterSpacing: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          for (final destination in _destinations)
            NavigationDrawerDestination(
              icon: Icon(destination.$1),
              label: Text(destination.$2),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: IndexedStack(
              index: _destinations.indexWhere(
                (item) => item.$2 == _activeSection,
              ),
              children: [
                _OverviewContent(
                  onViewActivities: () =>
                      setState(() => _activeSection = 'Activities'),
                  onViewEmergency: () =>
                      setState(() => _activeSection = 'Emergency & safety'),
                ),
                const ActivitiesPage(),
                const VolunteersPage(),
                const AttendancePage(),
                const AnnouncementsPage(),
                const EmergencyPage(),
                const ReportsPage(),
                const AccessControlPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFFBF0D7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'SAMPLE DATA',
      style: TextStyle(
        color: Color(0xFF895F00),
        fontSize: 9,
        letterSpacing: 0.7,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({
    required this.onViewActivities,
    required this.onViewEmergency,
  });

  final VoidCallback onViewActivities;
  final VoidCallback onViewEmergency;

  @override
  Widget build(BuildContext context) => Consumer<ActivitiesViewModel>(
    builder: (context, viewModel, _) {
      final upcoming = viewModel.activities
          .where((activity) => activity.status == ActivityStatus.published)
          .toList();
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
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(
                    width: width,
                    icon: Icons.event_available,
                    value: upcoming.length.toString().padLeft(2, '0'),
                    label: 'SAMPLE ACTIVITIES',
                    tint: const Color(0xFFE5EFE7),
                    ink: const Color(0xFF196142),
                  ),
                  _MetricCard(
                    width: width,
                    icon: Icons.schedule,
                    value: '24 hrs',
                    label: 'SAMPLE SERVICE HOURS',
                    tint: const Color(0xFFFBF0D7),
                    ink: const Color(0xFFA9790D),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          _SectionHeading(
            title: 'Coming up',
            action: 'View all',
            onAction: onViewActivities,
          ),
          const SizedBox(height: 10),
          if (upcoming.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No sample activities are available.'),
              ),
            )
          else
            for (final activity in upcoming.take(3))
              _ActivityCard(activity: activity, onTap: onViewActivities),
          const SizedBox(height: 18),
          Card(
            child: InkWell(
              onTap: onViewEmergency,
              borderRadius: BorderRadius.circular(18),
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
          ),
        ],
      );
    },
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.width,
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
    required this.ink,
  });

  final double width;
  final IconData icon;
  final String value;
  final String label;
  final Color tint;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback onAction;

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
        TextButton(
          onPressed: onAction,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4C735E),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.onTap});

  final Activity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.event_outlined,
                  color: Color(0xFF196142),
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
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${activity.scheduleLabel} · ${activity.venue} · sample',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
