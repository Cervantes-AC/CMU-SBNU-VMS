import 'package:flutter/material.dart';

class LandingHero extends StatelessWidget {
  const LandingHero({
    super.key,
    required this.compact,
    required this.horizontalPadding,
    required this.onSignIn,
  });

  final bool compact;
  final double horizontalPadding;
  final VoidCallback onSignIn;

  static const _green = Color(0xFF245B4B);
  static const _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 470),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF08150D), Color(0xFF123520), Color(0xFF0B1F2E)],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -80,
          top: -100,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(15)),
              boxShadow: [
                BoxShadow(
                  color: _green.withAlpha(80),
                  blurRadius: 100,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: compact ? 52 : 72,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 760;
                  final copy = _HeroCopy(onSignIn: onSignIn);
                  const overview = _ServiceOverview();
                  return stacked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            copy,
                            const SizedBox(height: 38),
                            overview,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 11, child: copy),
                            const SizedBox(width: 56),
                            const Expanded(flex: 9, child: overview),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onSignIn});

  final VoidCallback onSignIn;
  static const _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(18),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withAlpha(40)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 7, color: Color(0xFF7DDD9A)),
            SizedBox(width: 8),
            Text(
              'CMU SCHOOL-BASED NSRC UNIT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      Text(
        'Volunteer service,\nworking together.',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.4,
          height: 1.05,
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'A shared workspace for coordinating unit activities, communicating updates, and keeping volunteer service organized.',
        style: TextStyle(
          color: Colors.white.withAlpha(190),
          fontSize: 16,
          height: 1.65,
        ),
      ),
      const SizedBox(height: 26),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FilledButton.icon(
            onPressed: onSignIn,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Continue to member sign in'),
            style: FilledButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: const Color(0xFF17251C),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            ),
          ),
          OutlinedButton.icon(
            onPressed: onSignIn,
            icon: const Icon(Icons.lock_outline_rounded, size: 17),
            label: const Text('Member access'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withAlpha(80)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      Text(
        'Accounts are provided by unit administrators. Registration is not available here.',
        style: TextStyle(
          color: Colors.white.withAlpha(150),
          fontSize: 12,
          height: 1.5,
        ),
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
      color: Colors.white.withAlpha(13),
      border: Border.all(color: Colors.white.withAlpha(32)),
      borderRadius: BorderRadius.circular(23),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 30,
          offset: Offset(0, 16),
        ),
      ],
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNIT VOLUNTEER SERVICES',
          style: TextStyle(
            color: _HeroCopy._gold,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 9),
        Text(
          'Tools to support coordinated service',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        SizedBox(height: 20),
        _ServiceRow(
          icon: Icons.event_available_outlined,
          title: 'Coordinate activities',
          description: 'Keep event information organized for unit members.',
          accent: Color(0xFF8AD7A2),
        ),
        SizedBox(height: 18),
        _ServiceRow(
          icon: Icons.campaign_outlined,
          title: 'Share unit updates',
          description: 'Provide a clear place for approved announcements.',
          accent: Color(0xFFE6C76C),
        ),
        SizedBox(height: 18),
        _ServiceRow(
          icon: Icons.fact_check_outlined,
          title: 'Keep participation records',
          description: 'Support accountable attendance and service tracking.',
          accent: Color(0xFF9FC5F1),
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
    required this.accent,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: accent.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: accent, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withAlpha(160),
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
