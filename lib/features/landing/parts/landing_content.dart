import 'package:flutter/material.dart';

class LandingContent extends StatelessWidget {
  const LandingContent({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _green = Color(0xFF245B4B);
  static const _line = Color(0xFFE1E8E1);

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1240),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          54,
          horizontalPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A shared place for unit service',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _ink,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(height: 9),
            const SizedBox(
              width: 680,
              child: Text(
                'The application supports day-to-day volunteer coordination, with member access and records protected by role.',
                style: TextStyle(color: _muted, height: 1.6, fontSize: 15),
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 850
                    ? 3
                    : constraints.maxWidth >= 560
                    ? 2
                    : 1;
                final cardWidth =
                    (constraints.maxWidth - 14 * (columns - 1)) / columns;
                const cards = [
                  _ServiceCard(
                    icon: Icons.event_note_outlined,
                    title: 'Events',
                    description:
                        'Find unit activities and review event information.',
                    tint: Color(0xFFE7F0E8),
                  ),
                  _ServiceCard(
                    icon: Icons.forum_outlined,
                    title: 'Announcements',
                    description: 'Stay informed through unit-approved updates.',
                    tint: Color(0xFFF1EBDD),
                  ),
                  _ServiceCard(
                    icon: Icons.fact_check_outlined,
                    title: 'Attendance',
                    description:
                        'Keep a clear record of volunteer participation.',
                    tint: Color(0xFFE9E9F5),
                  ),
                ];
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    for (final card in cards)
                      SizedBox(
                        width: cardWidth,
                        child: _ServiceCardView(card: card),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            const Divider(color: _line),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 8,
                children: [
                  Text(
                    'Member sign-in is available from this page.',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                  Text(
                    'CMU · School-Based NSRC Unit',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ServiceCard {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.tint,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color tint;
}

class _ServiceCardView extends StatelessWidget {
  const _ServiceCardView({required this.card});
  final _ServiceCard card;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: LandingContent._line),
      borderRadius: BorderRadius.circular(18),
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
          child: Icon(card.icon, color: LandingContent._green),
        ),
        const SizedBox(height: 14),
        Text(
          card.title,
          style: const TextStyle(
            color: LandingContent._ink,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          card.description,
          style: const TextStyle(
            color: LandingContent._muted,
            height: 1.45,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
