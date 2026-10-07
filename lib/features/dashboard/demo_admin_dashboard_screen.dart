import 'package:flutter/material.dart';

import 'widgets/demo_activity_panel.dart';
import 'widgets/demo_metric_card.dart';

/// A local-only, synthetic preview of the administrator dashboard.
class DemoAdminDashboardScreen extends StatelessWidget {
  const DemoAdminDashboardScreen({super.key});

  static const _canvas = Color(0xFFF5F7F2);
  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _green = Color(0xFF245B4B);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _canvas,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                sliver: SliverToBoxAdapter(child: _topBar(context)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                sliver: SliverToBoxAdapter(child: _dashboardContent(context)),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _topBar(BuildContext context) => Row(
    children: [
      Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE1E8E1)),
        ),
        child: Image.asset('assets/images/SBNU LOGO.png', fit: BoxFit.contain),
      ),
      const SizedBox(width: 12),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CMU SBNU',
              style: TextStyle(
                color: _ink,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            Text(
              'Volunteer Management System · Local demo',
              style: TextStyle(color: _muted, fontSize: 11),
            ),
          ],
        ),
      ),
      TextButton.icon(
        onPressed: () =>
            Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Exit demo'),
        style: TextButton.styleFrom(foregroundColor: _green),
      ),
    ],
  );

  Widget _dashboardContent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0E9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD4E2D6)),
        ),
        child: const Row(
          children: [
            Icon(Icons.science_outlined, color: _green, size: 19),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                'LOCAL DEMO · All dashboard values are synthetic sample data. No account or records are connected.',
                style: TextStyle(color: _ink, fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 760;
          final heading = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADMINISTRATOR OVERVIEW',
                style: TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome, Demo Admin',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'A preview of the unit operations workspace.',
                style: TextStyle(color: _muted, fontSize: 14),
              ),
            ],
          );
          final badge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE1E8E1)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                  color: _green,
                  size: 17,
                ),
                SizedBox(width: 7),
                Text(
                  'ADMIN · PREVIEW',
                  style: TextStyle(
                    color: _green,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          );
          return stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [heading, const SizedBox(height: 16), badge],
                )
              : Row(
                  children: [
                    Expanded(child: heading),
                    badge,
                  ],
                );
        },
      ),
      const SizedBox(height: 25),
      _metrics(context),
      const SizedBox(height: 24),
      LayoutBuilder(
        builder: (context, constraints) {
          final activity = const DemoActivityPanel();
          final note = _previewNote();
          return constraints.maxWidth < 760
              ? Column(children: [activity, const SizedBox(height: 16), note])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: activity),
                    const SizedBox(width: 18),
                    Expanded(flex: 5, child: note),
                  ],
                );
        },
      ),
    ],
  );

  Widget _metrics(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1000
          ? 4
          : constraints.maxWidth >= 560
          ? 2
          : 1;
      final width = (constraints.maxWidth - 14 * (columns - 1)) / columns;
      const metrics = [
        DemoMetricCard(
          label: 'Sample members',
          value: '128',
          detail: 'Synthetic preview total',
          icon: Icons.groups_2_outlined,
          tint: Color(0xFFE7F0E8),
        ),
        DemoMetricCard(
          label: 'Sample pending reviews',
          value: '08',
          detail: 'Illustrative queue count',
          icon: Icons.pending_actions_outlined,
          tint: Color(0xFFF1EBDD),
        ),
        DemoMetricCard(
          label: 'Sample activities',
          value: '14',
          detail: 'Illustrative planning count',
          icon: Icons.event_note_outlined,
          tint: Color(0xFFE9E9F5),
        ),
        DemoMetricCard(
          label: 'Sample participation',
          value: '92%',
          detail: 'Example metric only',
          icon: Icons.insights_outlined,
          tint: Color(0xFFE5EFF3),
        ),
      ];
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          for (final metric in metrics) SizedBox(width: width, child: metric),
        ],
      );
    },
  );

  Widget _previewNote() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF08150D), Color(0xFF123520), Color(0xFF0B1F2E)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.tune_rounded, color: Color(0xFFD4AF37), size: 22),
        SizedBox(height: 13),
        Text(
          'Workspace preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Navigation, activity feeds, and live metrics will connect after the approved authentication and data services are implemented.',
          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.55),
        ),
      ],
    ),
  );
}
