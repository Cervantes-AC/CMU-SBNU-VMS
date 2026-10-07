import 'package:flutter/material.dart';

/// Local application landing page with a route to member sign-in.
///
/// The page contains no member records or service claims. Public publication
/// and institutional branding remain subject to their documented approvals.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF596962);
  static const _green = Color(0xFF245B4B);
  static const _canvas = Color(0xFFF5F7F2);
  static const _line = Color(0xFFE1E8E1);

  void _openSignIn(BuildContext context) {
    Navigator.of(context).pushNamed('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1100
        ? 56.0
        : width >= 700
        ? 32.0
        : 20.0;

    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 18),
                        _Header(onSignIn: () => _openSignIn(context)),
                        const SizedBox(height: 38),
                        _AccessNotice(onSignIn: () => _openSignIn(context)),
                        const SizedBox(height: 42),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >= 820) {
                              return const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(flex: 11, child: _Hero()),
                                  SizedBox(width: 48),
                                  Expanded(flex: 9, child: _ServiceOverview()),
                                ],
                              );
                            }
                            return const Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _Hero(),
                                SizedBox(height: 30),
                                _ServiceOverview(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 54),
                        Text(
                          'A shared place for unit service',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: _ink,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                              ),
                        ),
                        const SizedBox(height: 9),
                        const SizedBox(
                          width: 660,
                          child: Text(
                            'The application is being built to support day-to-day volunteer coordination, with member access and records protected by role.',
                            style: TextStyle(
                              color: _muted,
                              height: 1.6,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const _ServiceCards(),
                        const SizedBox(height: 48),
                        const Divider(color: _line, height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 8,
                            children: const [
                              Text(
                                'Member sign-in is available from this page.',
                                style: TextStyle(color: _muted, fontSize: 12),
                              ),
                              Text(
                                'Local application · publication approval remains open.',
                                style: TextStyle(color: _muted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Row(
      children: [
        const _Logo(
          'assets/images/cmu_logo.png',
          'Central Mindanao University logo',
        ),
        const SizedBox(width: 8),
        const _Logo(
          'assets/images/SBNU LOGO.png',
          'School-Based National Service Reserve Corps logo',
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volunteer Management System',
                style: TextStyle(
                  color: LandingPage._ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              Text(
                'School-Based NSRC Unit',
                style: TextStyle(color: LandingPage._muted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (compact)
          IconButton.filled(
            tooltip: 'Member sign in',
            onPressed: onSignIn,
            style: IconButton.styleFrom(
              backgroundColor: LandingPage._green,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.login_rounded),
          )
        else
          FilledButton.icon(
            onPressed: onSignIn,
            icon: const Icon(Icons.login_rounded, size: 17),
            label: const Text('Member sign in'),
            style: FilledButton.styleFrom(
              backgroundColor: LandingPage._green,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo(this.path, this.label);

  final String path;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    width: 45,
    height: 45,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: LandingPage._line),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Image.asset(path, fit: BoxFit.contain, semanticLabel: label),
  );
}

class _AccessNotice extends StatelessWidget {
  const _AccessNotice({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F0E9),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: LandingPage._green,
          size: 20,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Member services are not connected yet. Sign-in currently opens the access screen only.',
            style: TextStyle(
              color: LandingPage._ink,
              height: 1.4,
              fontSize: 13,
            ),
          ),
        ),
        TextButton(onPressed: onSignIn, child: const Text('Sign in')),
      ],
    ),
  );
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'CMU SCHOOL-BASED NSRC UNIT',
        style: TextStyle(
          color: LandingPage._green,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          fontSize: 11,
        ),
      ),
      const SizedBox(height: 15),
      Semantics(
        header: true,
        child: Text(
          'Volunteer service,\nworking together.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: LandingPage._ink,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            height: 1.08,
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'A shared workspace for coordinating unit activities, communicating updates, and keeping volunteer service organized.',
        style: TextStyle(color: LandingPage._muted, fontSize: 16, height: 1.6),
      ),
      const SizedBox(height: 22),
      FilledButton.icon(
        onPressed: () => Navigator.of(context).pushNamed('/sign-in'),
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: const Text('Continue to member sign in'),
        style: FilledButton.styleFrom(
          backgroundColor: LandingPage._green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        ),
      ),
      const SizedBox(height: 11),
      const Text(
        'Accounts are provided by unit administrators. Registration is not available here.',
        style: TextStyle(color: LandingPage._muted, fontSize: 12, height: 1.5),
      ),
    ],
  );
}

class _ServiceOverview extends StatelessWidget {
  const _ServiceOverview();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: LandingPage._line),
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Color(0x101C2B2A),
          blurRadius: 28,
          offset: Offset(0, 14),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'UNIT VOLUNTEER SERVICES',
          style: TextStyle(
            color: LandingPage._green,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tools to support coordinated service',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: LandingPage._ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        const _ServiceRow(
          icon: Icons.event_available_outlined,
          title: 'Coordinate activities',
          description: 'Keep event information organized for unit members.',
          tint: Color(0xFFE7F0E8),
        ),
        const SizedBox(height: 13),
        const _ServiceRow(
          icon: Icons.campaign_outlined,
          title: 'Share unit updates',
          description: 'Provide a clear place for approved announcements.',
          tint: Color(0xFFF1EBDD),
        ),
        const SizedBox(height: 13),
        const _ServiceRow(
          icon: Icons.fact_check_outlined,
          title: 'Keep participation records',
          description: 'Support accountable attendance and service tracking.',
          tint: Color(0xFFE9E9F5),
        ),
      ],
    ),
  );
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.tint,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color tint;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: LandingPage._green, size: 21),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: LandingPage._ink,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              description,
              style: const TextStyle(
                color: LandingPage._muted,
                height: 1.4,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ServiceCards extends StatelessWidget {
  const _ServiceCards();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 3
          : constraints.maxWidth >= 560
          ? 2
          : 1;
      const gap = 14.0;
      final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
      const cards = [
        _ServiceCardData(
          icon: Icons.event_note_outlined,
          title: 'Events',
          body: 'Find unit activities and review event information.',
          tint: Color(0xFFE7F0E8),
        ),
        _ServiceCardData(
          icon: Icons.forum_outlined,
          title: 'Announcements',
          body: 'Stay informed through unit-approved updates.',
          tint: Color(0xFFF1EBDD),
        ),
        _ServiceCardData(
          icon: Icons.fact_check_outlined,
          title: 'Attendance',
          body: 'Keep a clear record of volunteer participation.',
          tint: Color(0xFFE9E9F5),
        ),
      ];

      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final card in cards)
            SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: LandingPage._line),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: card.tint,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        card.icon,
                        color: LandingPage._green,
                        size: 21,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      card.title,
                      style: const TextStyle(
                        color: LandingPage._ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      card.body,
                      style: const TextStyle(
                        color: LandingPage._muted,
                        height: 1.45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _ServiceCardData {
  const _ServiceCardData({
    required this.icon,
    required this.title,
    required this.body,
    required this.tint,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color tint;
}
