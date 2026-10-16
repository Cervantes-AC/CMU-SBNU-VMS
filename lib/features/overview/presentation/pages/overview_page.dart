import 'package:flutter/material.dart';

import '../../../activities/presentation/pages/activities_page.dart';
import '../../../announcements/presentation/pages/announcements_page.dart';
import '../../../attendance/presentation/pages/attendance_page.dart';
import '../../../emergency/presentation/pages/emergency_page.dart';
import '../../../reporting/presentation/pages/reports_page.dart';
import '../../../volunteers/presentation/pages/volunteers_page.dart';
import '../../../access_control/presentation/pages/access_control_page.dart';
import '../../../../shared/presentation/widgets/app_shared_presentation.dart';

/// Overview dashboard - assembles data from feature APIs.
class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String _activeSection = 'Overview';

  static const List<_Destination> _destinations = [
    _Destination(Icons.grid_view_rounded, 'Overview'),
    _Destination(Icons.calendar_month_outlined, 'Activities'),
    _Destination(Icons.groups_outlined, 'Volunteers'),
    _Destination(Icons.fact_check_outlined, 'Attendance'),
    _Destination(Icons.campaign_outlined, 'Announcements'),
    _Destination(Icons.shield_outlined, 'Emergency & Safety'),
    _Destination(Icons.insights_outlined, 'Reports'),
    _Destination(Icons.admin_panel_settings_outlined, 'Access & Operations'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(
              _activeSection,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Return to landing page',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      drawer: _NavDrawer(
        destinations: _destinations,
        selectedIndex: _destinations.indexWhere(
          (d) => d.label == _activeSection,
        ),
        onDestinationSelected: (index) {
          setState(() => _activeSection = _destinations[index].label);
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: _SectionContent(activeSection: _activeSection),
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _NavDrawer extends StatelessWidget {
  const _NavDrawer({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex.clamp(0, destinations.length - 1),
      onDestinationSelected: onDestinationSelected,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 16, 16),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/sbnu_app_icon.png',
                    semanticLabel: 'SBNU logo',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SBNu',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
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
        for (final destination in destinations)
          NavigationDrawerDestination(
            icon: Icon(destination.icon),
            label: Text(destination.label),
          ),
      ],
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({required this.activeSection});

  final String activeSection;

  @override
  Widget build(BuildContext context) {
    switch (activeSection) {
      case 'Overview':
        return const _DashboardContent();
      case 'Activities':
        return const ActivitiesPage();
      case 'Volunteers':
        return const VolunteersPage();
      case 'Attendance':
        return const AttendancePage();
      case 'Announcements':
        return const AnnouncementsPage();
      case 'Emergency & Safety':
        return const EmergencyPage();
      case 'Reports':
        return const ReportsPage();
      case 'Access & Operations':
        return const AccessControlPage();
      default:
        return const _DashboardContent();
    }
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF52715E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Overview dashboard - reads from feature repositories.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: const Color(0xFF59685E),
                    ),
                  ),
                ),
              ],
            ),
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
                  value: '24',
                  label: 'ACTIVITIES',
                  tint: const Color(0xFFE5EFE7),
                  ink: const Color(0xFF196142),
                ),
                _MetricCard(
                  width: width,
                  icon: Icons.schedule,
                  value: '3892',
                  label: 'SERVICE HOURS',
                  tint: const Color(0xFFFBF0D7),
                  ink: const Color(0xFFA9790D),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        const AppSectionHeading(title: 'Coming up', actionLabel: 'View all'),
        const SizedBox(height: 10),
        Card(
          child: InkWell(
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
                          'Emergency tools',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'SOS, hotlines, and incidents',
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
  }
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
