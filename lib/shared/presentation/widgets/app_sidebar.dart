import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/platform/device_info.dart';
import '../../landing/presentation/widgets/public_footer.dart';

/// Responsive sidebar navigation matching the prototype design.
///
/// Provides the brand lockup, university label, workspace nav items,
/// partner office card, profile, and sign-out in a fixed dark-green panel.
/// Width adapts to tablet vs desktop.
class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.active,
    required this.onNavigate,
    required this.onMenu,
    required this.onLogout,
    required this.onSettings,
    required this.onProfile,
  });

  final String active;
  final ValueChanged<String> onNavigate;
  final VoidCallback onMenu;
  final VoidCallback onLogout;
  final VoidCallback onSettings;
  final VoidCallback onProfile;

  @override
  State<AppSidebar> createState() => _AppSidebarState;
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    return SizedBox(
      width: device.isTablet ? 220 : 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SidebarBrand(),
                    const SizedBox(height: 20),
                    const _UniversityLabel(),
                    const SizedBox(height: 8),
                    _NavList(
                      active: widget.active,
                      onNavigate: widget.onNavigate,
                    ),
                    const SizedBox(height: 24),
                    const _SidebarBottom(),
                  ],
                ),
              ),
            ),
          ),
          const _ProfileSection(),
        ],
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand();

  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: device.isTablet ? 40 : 47,
            height: device.isTablet ? 44 : 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppTheme.forestDark,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/sbnu_logo.svg',
                fit: BoxFit.contain,
                semanticLabel: 'SBNU logo',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SBNu',
                style: GoogleFontsManrope.w800.copyWith(
                  fontSize: device.isTablet ? 18 : 21,
                  color: AppTheme.surface,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'VOLUNTEER CORPS',
                style: GoogleFontsDMSans.w700.copyWith(
                  fontSize: 10,
                  color: const Color(0xFF9FB8A9),
                  letterSpacing: 1.6,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UniversityLabel extends StatelessWidget {
  const _UniversityLabel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 21),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Central Mindanao University',
          style: GoogleFontsDMSans.w700.copyWith(
            fontSize: 10,
            color: const Color(0xFF9FB8A9),
            letterSpacing: 0.9,
            height: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _NavList extends StatelessWidget {
  const _NavList({
    required this.active,
    required this.onNavigate,
  });

  final String active;
  final ValueChanged<String> onNavigate;

  static const List<_NavItem> _items = [
    _NavItem(Icons.grid_view_rounded, 'Overview'),
    _NavItem(Icons.calendar_month_outlined, 'Activities'),
    _NavItem(Icons.groups_outlined, 'Volunteers'),
    _NavItem(Icons.fact_check_outlined, 'Attendance'),
    _NavItem(Icons.campaign_outlined, 'Announcements'),
    _NavItem(Icons.shield_outlined, 'Emergency & Safety'),
    _NavItem(Icons.insights_outlined, 'Reports'),
    _NavItem(Icons.admin_panel_settings_outlined, 'Access & Operations'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 7),
          child: Text(
            'Workspace',
            style: GoogleFontsDMSans.w700.copyWith(
              fontSize: 9,
              color: const Color(0xFF718D7C),
              letterSpacing: 1.8,
              height: 1,
            ),
          ),
        ),
        ..._items.map(
          (item) => _NavItemButton(
            item: item,
            isActive: active == item.label,
            onTap: () => onNavigate(item.label),
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _NavItemButton extends StatelessWidget {
  const _NavItemButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeBg = isActive
        ? const LinearGradient(
            colors: [
              Color(0x22D5A52F),
              Color(0x1AD5A52F),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        : null;
    final activeBorder = isActive
        ? const Border(left: BorderSide(color: Color(0xFFE7BD54), width: 2))
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: activeBg,
          border: activeBorder,
          borderRadius: BorderRadius.circular(9),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 19,
              color: isActive ? AppTheme.surface : const Color(0xFFA9BEB0),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                item.label,
                style: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 13,
                  color: isActive ? AppTheme.surface : const Color(0xFFA9BEB0),
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarBottom extends StatelessWidget {
  const _SidebarBottom();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
          child: SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.settings, size: 19),
              label: const Text('Settings'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFA9BEB0),
                side: const BorderSide(color: Colors.transparent),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                textStyle: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 13,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _OfficeCard(),
      ],
    );
  }
}

class _OfficeCard extends StatelessWidget {
  const _OfficeCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          color: Colors.white.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/odrrm_logo.svg',
                  fit: BoxFit.contain,
                  semanticLabel: 'ODRRM logo',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Partner office',
                    style: GoogleFontsDMSans.w700.copyWith(
                      fontSize: 8,
                      color: const Color(0xFF779282),
                      letterSpacing: 1.2,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ODRRM',
                    style: GoogleFontsDMSans.w800.copyWith(
                      fontSize: 12,
                      color: AppTheme.surface,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Safety & resilience',
                    style: GoogleFontsDMSans.w400.copyWith(
                      fontSize: 9,
                      color: const Color(0xFF9DB3A5),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Text(
                        'AT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF173423),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Alex Torres',
                          style: GoogleFontsDMSans.w800.copyWith(
                            fontSize: 11,
                            color: AppTheme.surface,
                            height: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'SBNU Coordinator',
                          style: GoogleFontsDMSans.w400.copyWith(
                            fontSize: 9,
                            color: const Color(0xFF829B8B),
                            height: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: const Color(0xFF829B8B),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, size: 19),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFA9BEB0),
                side: const BorderSide(color: Colors.transparent),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                textStyle: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 13,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Manrope font helpers (weights used across the shell).
abstract class GoogleFontsManrope {
  static TextStyle get w400 => GoogleFonts.manrope(fontWeight: FontWeight.w400);
  static TextStyle get w500 => GoogleFonts.manrope(fontWeight: FontWeight.w500);
  static TextStyle get w600 => GoogleFonts.manrope(fontWeight: FontWeight.w600);
  static TextStyle get w700 => GoogleFonts.manrope(fontWeight: FontWeight.w700);
  static TextStyle get w800 => GoogleFonts.manrope(fontWeight: FontWeight.w800);
}

/// DM Sans font helpers.
abstract class GoogleFontsDMSans {
  static TextStyle get w400 => GoogleFonts.dmSans(fontWeight: FontWeight.w400);
  static TextStyle get w500 => GoogleFonts.dmSans(fontWeight: FontWeight.w500);
  static TextStyle get w600 => GoogleFonts.dmSans(fontWeight: FontWeight.w600);
  static TextStyle get w700 => GoogleFonts.dmSans(fontWeight: FontWeight.w700);
  static TextStyle get w800 => GoogleFonts.dmSans(fontWeight: FontWeight.w800);
}
