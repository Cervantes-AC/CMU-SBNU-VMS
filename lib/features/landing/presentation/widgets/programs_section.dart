import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Programs section showing service areas with premium cards.
class ProgramsSection extends StatelessWidget {
  const ProgramsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      ProgramItem(
        title: 'Environment',
        accent: DesignTokens.forest,
        count: '12 active programs',
        heading: 'Restore what sustains us.',
        description:
            'Watershed, campus greening, and community clean-up initiatives.',
        icon: Icons.eco_rounded,
      ),
      ProgramItem(
        title: 'Safety',
        accent: DesignTokens.error,
        count: '8 active programs',
        heading: 'Build a culture of readiness.',
        description:
            'Training, preparedness drills, and resilient community support.',
        icon: Icons.shield_rounded,
      ),
      ProgramItem(
        title: 'Community',
        accent: DesignTokens.gold,
        count: '17 active programs',
        heading: 'Extend care beyond campus.',
        description:
            'Education, outreach, relief, and civic engagement programs.',
        icon: Icons.people_rounded,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xxl,
        DesignTokens.lg,
        DesignTokens.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PremiumSectionHeading(
                  title: 'Programs',
                  subtitle: 'There is a place for every kind of service.',
                  accentColor: DesignTokens.forest,
                ),
              ),
              const SizedBox(width: DesignTokens.md),
              PremiumButton(
                label: 'View all opportunities',
                onPressed: () => context.go('/activities'),
                variant: ButtonVariant.outline,
                isFullWidth: false,
                icon: Icons.event_available,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.lg),
          for (final item in items) ...[
            ProgramCard(item: item),
            const SizedBox(height: DesignTokens.md),
          ],
        ],
      ),
    );
  }
}

class ProgramItem {
  const ProgramItem({
    required this.title,
    required this.accent,
    required this.count,
    required this.heading,
    required this.description,
    required this.icon,
  });

  final String title;
  final Color accent;
  final String count;
  final String heading;
  final String description;
  final IconData icon;
}

class ProgramCard extends StatelessWidget {
  const ProgramCard({super.key, required this.item});

  final ProgramItem item;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      elevation: 2,
      borderRadius: DesignTokens.radiusXl,
      padding: const EdgeInsets.all(DesignTokens.lg),
      child: InkWell(
        onTap: () => context.go('/activities'),
        borderRadius: DesignTokens.radiusXl,
        child: Row(
          children: [
            Container(
              width: 52.0,
              height: 52.0,
              decoration: BoxDecoration(
                color: item.accent.withValues(alpha: 0.12),
                borderRadius: DesignTokens.radiusLg,
                boxShadow: DesignTokens.shadowSoft(
                  color: item.accent.withValues(alpha: 0.2),
                  blur: 12.0,
                  offset: const Offset(0.0, 4.0),
                ),
              ),
              child: Icon(item.icon, color: item.accent, size: 26.0),
            ),
            const SizedBox(width: DesignTokens.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: item.accent,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.sm),
                      Text(
                        item.count,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.md),
                  Text(
                    item.heading,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      color: DesignTokens.ink,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.sm),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 13.0,
                      height: 1.6,
                      color: DesignTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20.0,
              color: DesignTokens.muted,
            ),
          ],
        ),
      ),
    );
  }
}
