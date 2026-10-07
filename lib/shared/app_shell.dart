import 'package:flutter/material.dart';

import '../core/constants/route_names.dart';
import '../data/models/user.dart';
import 'route_guard.dart';

/// Navigation destination for the authenticated application shell.
class AppDestination {
  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
    this.roles,
    this.requirement = AuthRequirement.approved,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  final Set<UserRole>? roles;
  final AuthRequirement requirement;

  bool isVisibleFor(UserRole? role) {
    switch (requirement) {
      case AuthRequirement.public:
      case AuthRequirement.authenticated:
      case AuthRequirement.approved:
        return true;
      case AuthRequirement.role:
        return role != null && roles!.contains(role);
    }
  }
}

/// Default navigation destinations. The shell filters destinations by the
/// signed-in user's role to enforce least-privilege navigation.
class AppDestinations {
  AppDestinations._();

  static const List<AppDestination> all = [
    AppDestination(
      label: 'Home',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      route: RouteNames.dashboard,
    ),
    AppDestination(
      label: 'Events',
      icon: Icons.event_outlined,
      selectedIcon: Icons.event_rounded,
      route: RouteNames.events,
    ),
    AppDestination(
      label: 'Attendance',
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check_rounded,
      route: RouteNames.memberAttendance,
    ),
    AppDestination(
      label: 'Incidents',
      icon: Icons.report_gmailerrorred_outlined,
      selectedIcon: Icons.report_gmailerrorred_rounded,
      route: RouteNames.myIncidents,
    ),
    AppDestination(
      label: 'Announcements',
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign_rounded,
      route: RouteNames.announcements,
    ),
    AppDestination(
      label: 'Officers',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups_rounded,
      route: RouteNames.officerDashboard,
      requirement: AuthRequirement.role,
      roles: {UserRole.officer, UserRole.admin},
    ),
    AppDestination(
      label: 'Admin',
      icon: Icons.admin_panel_settings_outlined,
      selectedIcon: Icons.admin_panel_settings_rounded,
      route: RouteNames.adminDashboard,
      requirement: AuthRequirement.role,
      roles: {UserRole.admin},
    ),
    AppDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      route: RouteNames.profile,
    ),
  ];
}

/// Authenticated application shell with adaptive navigation (bottom nav on
/// compact widths, navigation rail on medium/expanded). The shell itself does
/// not fetch data; it receives the active route, profile, and callbacks via
/// constructor parameters.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentRoute,
    required this.profile,
    required this.onNavigate,
    required this.onSignOut,
    required this.child,
    this.destinations = AppDestinations.all,
  });

  /// Current location path (for highlighting the selected destination).
  final String currentRoute;

  /// Signed-in approved profile; `null` only during transient states.
  final UserProfile? profile;

  /// Callback when the user selects a destination route.
  final ValueChanged<String> onNavigate;

  /// Sign-out callback.
  final VoidCallback onSignOut;

  /// Page content rendered inside the shell.
  final Widget child;

  /// Destinations to render (filtered by role).
  final List<AppDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;
    final medium = width >= 760 && width < 1100;
    final role = profile?.role;
    final visible = destinations.where((d) => d.isVisibleFor(role)).toList();
    final selectedIndex = _selectedIndex(visible);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E8E1)),
              ),
              child: Image.asset(
                'assets/images/SBNU LOGO.png',
                fit: BoxFit.contain,
                semanticLabel: 'CMU School-Based NSRC Unit logo',
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'CMU SBNU VMS',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        actions: [
          if (!compact)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    profile?.displayName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _roleLabel(role),
                    style: const TextStyle(
                      color: Color(0xFF245B4B),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          TextButton.icon(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_rounded, size: 17),
            label: Text(compact ? '' : 'Sign out'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF245B4B)),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact)
            NavigationRail(
              selectedIndex: selectedIndex,
              backgroundColor: Colors.white,
              extended: medium || width >= 1400,
              labelType: medium
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              indicatorColor: const Color(0xFF245B4B).withAlpha(20),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFF245B4B),
                fontWeight: FontWeight.w700,
              ),
              onDestinationSelected: (i) => _onSelect(visible, i),
              destinations: [
                for (final d in visible)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: compact
          ? NavigationBar(
              selectedIndex: selectedIndex,
              backgroundColor: Colors.white,
              height: 60,
              indicatorColor: const Color(0xFF245B4B).withAlpha(22),
              onDestinationSelected: (i) => _onSelect(visible, i),
              destinations: [
                for (final d in visible)
                  NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
              ],
            )
          : null,
    );
  }

  int _selectedIndex(List<AppDestination> visible) {
    final path = currentRoute.split('?').first;
    for (var i = 0; i < visible.length; i++) {
      if (_matches(visible[i].route, path)) return i;
    }
    // Fallback: match dashboard routes to Home when no exact match.
    final dashboardRoutes = {
      RouteNames.dashboard,
      RouteNames.memberDashboard,
      RouteNames.officerDashboard,
      RouteNames.adminDashboard,
    };
    if (dashboardRoutes.contains(path)) {
      final homeIndex =
          visible.indexWhere((d) => d.route == RouteNames.dashboard);
      if (homeIndex >= 0) return homeIndex;
    }
    return 0;
  }

  void _onSelect(List<AppDestination> visible, int index) {
    if (index < 0 || index >= visible.length) return;
    onNavigate(visible[index].route);
  }

  static bool _matches(String pattern, String path) {
    final pSeg = pattern.split('/');
    final vSeg = path.split('/');
    if (pSeg.length != vSeg.length) return pattern == RouteNames.dashboard;
    for (var i = 0; i < pSeg.length; i++) {
      final p = pSeg[i];
      if (p.startsWith(':')) continue;
      if (p != vSeg[i]) return false;
    }
    return true;
  }

  static String _roleLabel(UserRole? role) => switch (role) {
        UserRole.member => 'Member',
        UserRole.officer => 'Officer',
        UserRole.admin => 'Administrator',
        null => '',
      };
}
