import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/performance/performance.dart';
import '../../../core/platform/device_info.dart';
import 'app_sidebar.dart';
import 'app_topbar.dart';

/// Responsive workspace shell.
///
/// On mobile/tablet it uses a simple column layout (child pages already have
/// their own Scaffold/AppBar). On desktop it shows a persistent sidebar.
///
/// Feature pages are rendered as the `child` inside the content area.
class AppWorkspaceShell extends StatefulWidget {
  const AppWorkspaceShell({
    super.key,
    required this.child,
    required this.activeSection,
    required this.onNavigate,
    required this.onMenu,
    required this.onSearch,
    required this.onNotifications,
    required this.onLogout,
    required this.onSettings,
    required this.onProfile,
  });

  final Widget child;
  final String activeSection;
  final ValueChanged<String> onNavigate;
  final VoidCallback onMenu;
  final ValueChanged<String> onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onLogout;
  final VoidCallback onSettings;
  final VoidCallback onProfile;

  @override
  State<AppWorkspaceShell> createState() => _AppWorkspaceShellState;
}

class _AppWorkspaceShellState extends State<AppWorkspaceShell> {
  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);

    // Desktop/tablet: persistent sidebar + topbar.
    if (!device.useDrawer) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSidebar(
            active: widget.activeSection,
            onNavigate: widget.onNavigate,
            onMenu: widget.onMenu,
            onLogout: widget.onLogout,
            onSettings: widget.onSettings,
            onProfile: widget.onProfile,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTopbar(
                  activeSection: widget.activeSection,
                  onMenu: widget.onMenu,
                  onSearch: widget.onSearch,
                  onNotifications: widget.onNotifications,
                ),
                Expanded(
                  child: _ContentArea(
                    child: widget.child,
                    device: device,
                  ),
                ),
                const _WorkspaceFooter(),
              ],
            ),
          ),
        ],
      );
    }

    // Mobile/tablet: column layout without nested Scaffold (child pages
    // provide their own Scaffold/AppBar). Menu opens a navigation dialog.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTopbar(
          activeSection: widget.activeSection,
          onMenu: () => _showNavDialog(context),
          onSearch: widget.onSearch,
          onNotifications: widget.onNotifications,
        ),
        Expanded(
          child: _ContentArea(
            child: widget.child,
            device: device,
          ),
        ),
        const _WorkspaceFooter(),
      ],
    );
  }

  void _showNavDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _NavDialogItem(icon: Icons.grid_view_rounded, label: 'Overview', route: '/workspace'),
            const _NavDialogItem(icon: Icons.calendar_month_outlined, label: 'Activities', route: '/activities'),
            const _NavDialogItem(icon: Icons.groups_outlined, label: 'Volunteers', route: '/volunteers'),
            const _NavDialogItem(icon: Icons.fact_check_outlined, label: 'Attendance', route: '/attendance'),
            const _NavDialogItem(icon: Icons.campaign_outlined, label: 'Announcements', route: '/announcements'),
            const _NavDialogItem(icon: Icons.shield_outlined, label: 'Emergency & Safety', route: '/emergency'),
            const _NavDialogItem(icon: Icons.insights_outlined, label: 'Reports', route: '/reports'),
            const _NavDialogItem(icon: Icons.admin_panel_settings_outlined, label: 'Access & Operations', route: '/access-control'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _NavDialogItem extends StatelessWidget {
  const _NavDialogItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }
}

class _ContentArea extends StatelessWidget {
  const _ContentArea({required this.child, required this.device});

  final Widget child;
  final DeviceInfo device;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.canvas,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: device.isDesktop ? 1540 : double.infinity,
          ),
          child: Padding(
            padding: responsivePadding(
              context,
              mobile: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              tablet: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              desktop: const EdgeInsets.fromLTRB(37, 31, 37, 0),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _WorkspaceFooter extends StatelessWidget {
  const _WorkspaceFooter();

  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    return Container(
      height: device.isMobile ? 32 : 40,
      padding: responsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 16),
        tablet: const EdgeInsets.symmetric(horizontal: 24),
        desktop: const EdgeInsets.symmetric(horizontal: 37),
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.line, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'CMU SBNu Volunteer Management System',
              style: GoogleFonts.dmSans(
                fontSize: device.isMobile ? 7 : 8,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9BA39E),
                letterSpacing: 0.8,
                height: 1,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Service • Bayanihan • Nationalism • Unity',
              style: GoogleFonts.dmSans(
                fontSize: device.isMobile ? 7 : 8,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9BA39E),
                letterSpacing: 0.8,
                height: 1,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
