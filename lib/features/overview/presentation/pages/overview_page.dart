import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../activities/presentation/pages/activities_page.dart';
import '../../../announcements/presentation/pages/announcements_page.dart';
import '../../../attendance/presentation/pages/attendance_page.dart';
import '../../../emergency/presentation/pages/emergency_page.dart';
import '../../../reporting/presentation/pages/reports_page.dart';
import '../../../volunteers/presentation/pages/volunteers_page.dart';
import '../../../access_control/presentation/pages/access_control_page.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/presentation/widgets/app_workspace_shell.dart';

/// Overview dashboard - assembles data from feature APIs.
class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String _activeSection = 'Overview';

  void _handleNavigate(String label) {
    setState(() => _activeSection = label);
  }

  void _handleMenu() {
    // Sidebar is always visible; menu toggle kept for parity/responsive behavior.
  }

  void _handleSearch(String query) {
    // Search handled by topbar; kept as a hook for future filtering.
  }

  void _handleNotifications() {}

  void _handleLogout() {}

  void _handleSettings() {}

  void _handleProfile() {}

  @override
  Widget build(BuildContext context) {
    return AppWorkspaceShell(
      activeSection: _activeSection,
      onNavigate: _handleNavigate,
      onMenu: _handleMenu,
      onSearch: _handleSearch,
      onNotifications: _handleNotifications,
      onLogout: _handleLogout,
      onSettings: _handleSettings,
      onProfile: _handleProfile,
      child: _SectionContent(activeSection: _activeSection),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 28),
      children: [
        const SizedBox(height: 25),
        const _WelcomeHero(),
        const SizedBox(height: 14),
        const _MetricGrid(),
        const SizedBox(height: 14),
        const _DashboardGrid(),
        const SizedBox(height: 14),
        const _SafetyPanel(),
      ],
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 20, height: 1, color: AppTheme.gold),
                  const SizedBox(width: 8),
                  Text(
                    'Service at a glance',
                    style: GoogleFontsDMSans.w700.copyWith(
                      fontSize: 9,
                      color: const Color(0xFF7A857E),
                      letterSpacing: 0.9,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Overview',
                    style: GoogleFontsDMSans.w400.copyWith(
                      fontSize: 9,
                      color: const Color(0xFF7A857E),
                      letterSpacing: 0.9,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                'Your service at a glance',
                style: GoogleFontsManrope.w700.copyWith(
                  fontSize: 34,
                  color: const Color(0xFF15281D),
                  height: 1.12,
                  letterSpacing: -1.3,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Track activities, volunteers, attendance, and safety from one connected workspace.',
                style: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF7C877F),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Row(
          children: [
            _ActionButton(
              label: 'Create activity',
              icon: Icons.add_circle_outline,
              variant: _ButtonVariant.primary,
              onPressed: () {},
            ),
            const SizedBox(width: 9),
            _ActionButton(
              label: 'View all',
              icon: Icons.chevron_right,
              variant: _ButtonVariant.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 13,
      mainAxisSpacing: 13,
      childAspectRatio: 2.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MetricCard(
          icon: Icons.event_available,
          value: '24',
          label: 'ACTIVITIES',
          tint: const Color(0xFFE5EFE7),
          ink: const Color(0xFF196142),
        ),
        _MetricCard(
          icon: Icons.schedule,
          value: '3892',
          label: 'SERVICE HOURS',
          tint: const Color(0xFFFBF0D7),
          ink: const Color(0xFFA9790D),
        ),
        _MetricCard(
          icon: Icons.groups,
          value: '1248',
          label: 'ACTIVE VOLUNTEERS',
          tint: const Color(0xFFE6F0F3),
          ink: const Color(0xFF306478),
        ),
        _MetricCard(
          icon: Icons.insights,
          value: '87.4%',
          label: 'ATTENDANCE RATE',
          tint: const Color(0xFFEEE9F2),
          ink: const Color(0xFF68537B),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 18, 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: const Color(0xFFE0E5DF)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: ink),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFontsManrope.w700.copyWith(
              fontSize: 24,
              color: AppTheme.ink,
              letterSpacing: -0.8,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFontsDMSans.w700.copyWith(
              fontSize: 9,
              color: const Color(0xFF7C8981),
              letterSpacing: 0.8,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF0ED),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return GridView.count(
          crossAxisCount: isWide ? 2 : 1,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: isWide ? 2.6 : 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [_ActivityPanel(), _PulsePanel()],
        );
      },
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      kicker: 'ACTIVITIES',
      title: 'Upcoming activities',
      child: Column(
        children: [
          _ActivityRow(
            date: 'Oct',
            day: '17',
            tint: const Color(0xFFF8EDCF),
            dateColor: const Color(0xFF895F00),
            title: 'Community Tree Planting',
            meta: 'Botanical Garden • 8:00 AM',
            people: ['A', 'B', 'C'],
            onJoin: () {},
          ),
          _ActivityRow(
            date: 'Oct',
            day: '18',
            tint: const Color(0xFFE1EEE4),
            dateColor: const Color(0xFF145638),
            title: 'Disaster Response Drill',
            meta: 'Campus Oval • 1:00 PM',
            people: ['D', 'E'],
            onJoin: () {},
          ),
          _ActivityRow(
            date: 'Oct',
            day: '20',
            tint: const Color(0xFFE4EDF0),
            dateColor: const Color(0xFF315E70),
            title: 'Blood Donation Drive',
            meta: 'University Clinic • 9:00 AM',
            people: ['F', 'G', 'H'],
            onJoin: () {},
          ),
        ],
      ),
      onMore: () {},
    );
  }
}

class _PulsePanel extends StatelessWidget {
  const _PulsePanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      kicker: 'PULSE',
      title: 'Service pulse',
      child: Column(
        children: [
          const _DonutCard(),
          const SizedBox(height: 14),
          const _PulseFooter(),
        ],
      ),
      onMore: () {},
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.kicker,
    required this.title,
    required this.child,
    this.onMore,
  });

  final String kicker;
  final String title;
  final Widget child;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: const Color(0xFFE0E5DF)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 17),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEDF0EC), width: 1),
              ),
            ),
            child: Row(
              children: [
                Text(
                  kicker,
                  style: GoogleFontsDMSans.w700.copyWith(
                    fontSize: 8,
                    color: const Color(0xFFA07B23),
                    letterSpacing: 1.3,
                    height: 1,
                  ),
                ),
                const Spacer(),
                if (onMore != null)
                  TextButton(
                    onPressed: onMore,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'More',
                          style: GoogleFontsDMSans.w700.copyWith(
                            fontSize: 9,
                            color: const Color(0xFF4C735E),
                            letterSpacing: 2,
                            height: 1,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 12,
                          color: Color(0xFF4C735E),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 12, 17, 0),
            child: Text(
              title,
              style: GoogleFontsManrope.w700.copyWith(
                fontSize: 14,
                color: const Color(0xFF213027),
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 12, 16, 12),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.date,
    required this.day,
    required this.tint,
    required this.dateColor,
    required this.title,
    required this.meta,
    required this.people,
    required this.onJoin,
  });

  final String date;
  final String day;
  final Color tint;
  final Color dateColor;
  final String title;
  final String meta;
  final List<String> people;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onJoin,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 45,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: GoogleFontsManrope.w700.copyWith(
                      fontSize: 16,
                      color: dateColor,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    date,
                    style: GoogleFontsDMSans.w700.copyWith(
                      fontSize: 7,
                      color: dateColor,
                      letterSpacing: 1,
                      height: 1,
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
                    style: GoogleFontsDMSans.w700.copyWith(
                      fontSize: 11,
                      color: AppTheme.ink,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 9,
                        color: const Color(0xFF879189),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        meta,
                        style: GoogleFontsDMSans.w400.copyWith(
                          fontSize: 8,
                          color: const Color(0xFF879189),
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC2C8C3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'On-site',
                        style: GoogleFontsDMSans.w400.copyWith(
                          fontSize: 8,
                          color: const Color(0xFF879189),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        '${people.length} going',
                        style: GoogleFontsDMSans.w400.copyWith(
                          fontSize: 8,
                          color: const Color(0xFF7A867E),
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 7),
                      ...people
                          .take(3)
                          .map(
                            (p) => Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3E9E4),
                                border: Border.all(
                                  color: AppTheme.surface,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  p,
                                  style: GoogleFontsDMSans.w700.copyWith(
                                    fontSize: 6,
                                    color: const Color(0xFF41604D),
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 13, color: Color(0xFFADB5AF)),
          ],
        ),
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 20, 20, 11),
      child: Row(
        children: [
          Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              gradient: const SweepGradient(
                colors: [
                  Color(0xFF1B6645),
                  Color(0xFF1B6645),
                  Color(0xFFE6B641),
                  Color(0xFFE6EAE6),
                ],
                stops: [0.0, 0.87, 0.95, 1.0],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 83,
                height: 83,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '82',
                      style: GoogleFontsManrope.w700.copyWith(
                        fontSize: 21,
                        color: AppTheme.ink,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'HOURS',
                      style: GoogleFontsDMSans.w700.copyWith(
                        fontSize: 7,
                        color: const Color(0xFF879189),
                        letterSpacing: 0.8,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendItem(
                  color: const Color(0xFF1B6645),
                  label: 'Completed',
                  value: '42 hrs',
                ),
                const SizedBox(height: 9),
                _LegendItem(
                  color: const Color(0xFFE6B641),
                  label: 'In progress',
                  value: '28 hrs',
                ),
                const SizedBox(height: 9),
                _LegendItem(
                  color: const Color(0xFFD8DED9),
                  label: 'Scheduled',
                  value: '12 hrs',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 8,
                  color: const Color(0xFF7D8881),
                  height: 1,
                ),
              ),
              Text(
                value,
                style: GoogleFontsDMSans.w700.copyWith(
                  fontSize: 9,
                  color: AppTheme.ink,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PulseFooter extends StatelessWidget {
  const _PulseFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 10, bottom: 13),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFEDF0EC), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: Color(0xFFC08C17)),
              const SizedBox(width: 4),
              Text(
                'Last updated',
                style: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 8,
                  color: const Color(0xFF6E7972),
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Oct 17, 2026',
                style: GoogleFontsDMSans.w400.copyWith(
                  fontSize: 7,
                  color: const Color(0xFF89948C),
                  height: 1,
                ),
              ),
            ],
          ),
          Text(
            'Oct 17, 2026 · 3:14 PM',
            style: GoogleFontsDMSans.w400.copyWith(
              fontSize: 7,
              color: const Color(0xFF89948C),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyPanel extends StatelessWidget {
  const _SafetyPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: const Color(0xFFE0E5DF)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5F2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'ODRRM Safety Desk',
                      style: GoogleFontsManrope.w700.copyWith(
                        fontSize: 12,
                        color: AppTheme.ink,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F2EB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D9C62),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3D9C62,
                                  ).withValues(alpha: 0.12),
                                  blurRadius: 3,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'All systems normal',
                            style: GoogleFontsDMSans.w700.copyWith(
                              fontSize: 8,
                              color: const Color(0xFF23603F),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'No active incidents reported. SOS, hotlines, and incident reporting are available from Emergency & Safety.',
                  style: GoogleFontsDMSans.w400.copyWith(
                    fontSize: 9,
                    color: const Color(0xFF748078),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 13),
          Row(
            children: [
              _SafetyAction(
                label: 'Hotlines',
                icon: Icons.phone,
                onPressed: () {},
              ),
              const SizedBox(width: 7),
              _SafetyAction(
                label: 'SOS',
                icon: Icons.error_outline,
                color: const Color(0xFFB63D34),
                borderColor: const Color(0xFFF0D5D2),
                bgColor: const Color(0xFFFFF8F7),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SafetyAction extends StatelessWidget {
  const _SafetyAction({
    required this.label,
    required this.icon,
    this.color,
    this.borderColor,
    this.bgColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color? color;
  final Color? borderColor;
  final Color? bgColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 13, color: color ?? const Color(0xFF315342)),
        label: Text(
          label,
          style: GoogleFontsDMSans.w700.copyWith(
            fontSize: 9,
            color: color ?? const Color(0xFF315342),
            height: 1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? const Color(0xFF315342),
          backgroundColor: bgColor ?? AppTheme.surface,
          side: BorderSide(color: borderColor ?? AppTheme.line, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}

enum _ButtonVariant { primary, secondary }

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.variant,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final _ButtonVariant variant;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == _ButtonVariant.primary;
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 15,
          color: isPrimary ? AppTheme.surface : const Color(0xFF526158),
        ),
        label: Text(
          label,
          style: GoogleFontsDMSans.w600.copyWith(
            fontSize: 11,
            color: isPrimary ? AppTheme.surface : const Color(0xFF526158),
            letterSpacing: 0.2,
            height: 1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: isPrimary
              ? AppTheme.surface
              : const Color(0xFF526158),
          backgroundColor: isPrimary ? AppTheme.forest : AppTheme.surface,
          side: BorderSide(
            color: isPrimary ? AppTheme.forest : AppTheme.line,
            width: 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

/// Font weight helpers reused across dashboard widgets.
abstract class GoogleFontsManrope {
  static TextStyle get w400 => GoogleFonts.manrope(fontWeight: FontWeight.w400);
  static TextStyle get w500 => GoogleFonts.manrope(fontWeight: FontWeight.w500);
  static TextStyle get w600 => GoogleFonts.manrope(fontWeight: FontWeight.w600);
  static TextStyle get w700 => GoogleFonts.manrope(fontWeight: FontWeight.w700);
  static TextStyle get w800 => GoogleFonts.manrope(fontWeight: FontWeight.w800);
}

abstract class GoogleFontsDMSans {
  static TextStyle get w400 => GoogleFonts.dmSans(fontWeight: FontWeight.w400);
  static TextStyle get w500 => GoogleFonts.dmSans(fontWeight: FontWeight.w500);
  static TextStyle get w600 => GoogleFonts.dmSans(fontWeight: FontWeight.w600);
  static TextStyle get w700 => GoogleFonts.dmSans(fontWeight: FontWeight.w700);
  static TextStyle get w800 => GoogleFonts.dmSans(fontWeight: FontWeight.w800);
}
