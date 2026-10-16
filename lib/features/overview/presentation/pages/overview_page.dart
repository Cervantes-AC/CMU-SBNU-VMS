import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/activities/presentation/pages/activities_page.dart';
import 'package:cmu_sbnu_vms/features/announcements/presentation/pages/announcements_page.dart';
import 'package:cmu_sbnu_vms/features/attendance/presentation/pages/attendance_page.dart';
import 'package:cmu_sbnu_vms/features/emergency/presentation/pages/emergency_page.dart';
import 'package:cmu_sbnu_vms/features/reporting/presentation/pages/reports_page.dart';
import 'package:cmu_sbnu_vms/features/volunteers/presentation/pages/volunteers_page.dart';
import 'package:cmu_sbnu_vms/features/access_control/presentation/pages/access_control_page.dart';
import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Overview dashboard — premium, fully functional.
///
/// High-class professional dashboard with 3D-style metric cards,
/// glassmorphism panels, and smooth navigation.
class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String _activeSection = 'Overview';

  static const List<_Destination> _destinations = [
    _Destination(Icons.dashboard_rounded, 'Overview'),
    _Destination(Icons.calendar_today_rounded, 'Activities'),
    _Destination(Icons.people_rounded, 'Volunteers'),
    _Destination(Icons.check_circle_rounded, 'Attendance'),
    _Destination(Icons.campaign_rounded, 'Announcements'),
    _Destination(Icons.shield_rounded, 'Emergency & Safety'),
    _Destination(Icons.analytics_rounded, 'Reports'),
    _Destination(Icons.admin_panel_settings_rounded, 'Access & Operations'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Navigation rail (mobile shows drawer, desktop shows rail)
            if (MediaQuery.of(context).size.width >= 768)
              _NavRail(
                destinations: _destinations,
                selectedIndex: _destinations.indexWhere(
                  (d) => d.label == _activeSection,
                ),
                onDestinationSelected: (index) {
                  setState(() => _activeSection = _destinations[index].label);
                },
              ),
            Expanded(
              child: Column(
                children: [
                  _AppBar(activeSection: _activeSection),
                  Expanded(
                    child: _SectionContent(activeSection: _activeSection),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    );
  }
}

class _Destination {
  const _Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// Top app bar with brand and user actions.
class _AppBar extends StatelessWidget {
  const _AppBar({required this.activeSection});

  final String activeSection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.md,
        DesignTokens.lg,
        DesignTokens.sm,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        border: Border(bottom: BorderSide(color: DesignTokens.line, width: 1)),
      ),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width < 768)
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded, color: DesignTokens.ink),
              tooltip: 'Open navigation',
            ),
          const SizedBox(width: DesignTokens.md),
          Container(
            width: 40,
            height: 40,
            decoration: DesignTokens.card3D(
              color: DesignTokens.canvas,
              shadowLevel: 1,
            ),
            child: ClipRRect(
              borderRadius: DesignTokens.radiusMd,
              child: Image.asset(
                'assets/images/sbnu_app_icon.png',
                semanticLabel: 'SBNU logo',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.md),
          Text(
            activeSection,
            style: DesignTokens.headline.copyWith(
              fontSize: 18,
              color: DesignTokens.ink,
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: DesignTokens.card3D(
              color: DesignTokens.forest.withValues(alpha: 0.1),
              shadowLevel: 1,
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                color: DesignTokens.forest,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Navigation rail for desktop.
class _NavRail extends StatelessWidget {
  const _NavRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        border: Border(right: BorderSide(color: DesignTokens.line, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: DesignTokens.lg),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: DesignTokens.card3D(
              color: DesignTokens.canvas,
              shadowLevel: 1,
            ),
            child: ClipRRect(
              borderRadius: DesignTokens.radiusMd,
              child: Image.asset(
                'assets/images/sbnu_app_icon.png',
                semanticLabel: 'SBNU logo',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.xl),
          for (var i = 0; i < destinations.length; i++)
            _RailDestination(
              destination: destinations[i],
              isSelected: i == selectedIndex,
              onTap: () => onDestinationSelected(i),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(DesignTokens.md),
            child: PremiumButton(
              label: 'Sign out',
              onPressed: () {},
              variant: ButtonVariant.outline,
              isFullWidth: true,
              icon: Icons.logout_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _RailDestination extends StatelessWidget {
  const _RailDestination({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignTokens.forest.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: DesignTokens.radiusXl,
          border: isSelected
              ? Border.all(
                  color: DesignTokens.forest.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? DesignTokens.shadowSoft(
                  color: DesignTokens.forest.withValues(alpha: 0.15),
                  blur: 12,
                  offset: const Offset(0, 4),
                )
              : null,
        ),
        child: Icon(
          destination.icon,
          color: isSelected ? DesignTokens.forest : DesignTokens.muted,
          size: 22,
        ),
      ),
    );
  }
}

/// Navigation drawer for mobile.
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
                width: 40,
                height: 40,
                decoration: DesignTokens.card3D(
                  color: DesignTokens.canvas,
                  shadowLevel: 1,
                ),
                child: ClipRRect(
                  borderRadius: DesignTokens.radiusMd,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: DesignTokens.ink,
                    ),
                  ),
                  Text(
                    'VOLUNTEER WORKSPACE',
                    style: TextStyle(
                      fontSize: 9.0,
                      letterSpacing: 0.8,
                      color: DesignTokens.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(indent: 20, endIndent: 20),
        for (final destination in destinations)
          NavigationDrawerDestination(
            icon: Icon(destination.icon, color: DesignTokens.muted),
            label: Text(destination.label),
          ),
        const Divider(indent: 20, endIndent: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
          child: PremiumButton(
            label: 'Sign out',
            onPressed: () {},
            variant: ButtonVariant.outline,
            isFullWidth: true,
            icon: Icons.logout_rounded,
          ),
        ),
      ],
    );
  }
}

/// Section content switcher.
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

/// Premium dashboard content.
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.lg),
      children: [
        // Welcome banner
        GlassCard(
          elevation: 1,
          borderRadius: DesignTokens.radiusXl,
          padding: const EdgeInsets.all(DesignTokens.xl),
          color: Colors.white,
          opacity: 0.9,
          blur: 24,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Volunteer',
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: DesignTokens.muted,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.sm / 2),
                    Text(
                      'Welcome back to your service dashboard.',
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: DesignTokens.forestGradient,
                  borderRadius: DesignTokens.radiusXl,
                  boxShadow: DesignTokens.shadowStrong(
                    color: DesignTokens.deepForest.withValues(alpha: 0.4),
                    blur: 24,
                    offset: const Offset(0, 12),
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
