import 'package:flutter/material.dart';

/// A navigation drawer destination for the workspace sidebar.
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.label,
    this.route,
  });

  final IconData icon;
  final String label;
  final String? route;
}

/// A reusable navigation drawer with SBNU branding.
class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.onSignOut,
    this.userDisplayName,
    this.userEmail,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback? onSignOut;
  final String? userDisplayName;
  final String? userEmail;

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
        const Divider(indent: 20, endIndent: 20),
        if (onSignOut != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFB63D34)),
              title: const Text(
                'Sign out',
                style: TextStyle(
                  color: Color(0xFFB63D34),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: onSignOut,
            ),
          ),
      ],
    );
  }
}
