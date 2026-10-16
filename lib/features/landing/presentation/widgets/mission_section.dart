import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Mission / purpose section with 3D cards.
class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      MissionItem(
        icon: Icons.explore_rounded,
        title: 'Discover your purpose',
        subtitle:
            'Find service opportunities aligned with your skills, interests, and community priorities.',
        accent: DesignTokens.forest,
      ),
      MissionItem(
        icon: Icons.groups_rounded,
        title: 'Serve together',
        subtitle:
            'Collaborate across colleges and units through organized, high-impact volunteer programs.',
        accent: DesignTokens.gold,
      ),
      MissionItem(
        icon: Icons.insights_rounded,
        title: 'See your impact',
        subtitle:
            'Track attendance, service hours, milestones, and the difference your contribution creates.',
        accent: DesignTokens.success,
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
          PremiumSectionHeading(
            title: 'Why SBNu',
            subtitle: 'A stronger culture of service starts here.',
            accentColor: DesignTokens.forest,
          ),
          const SizedBox(height: DesignTokens.lg),
          Row(
            children: [
              Expanded(child: MissionCard(item: items[0])),
              const SizedBox(width: DesignTokens.md),
              Expanded(child: MissionCard(item: items[1])),
              const SizedBox(width: DesignTokens.md),
              Expanded(child: MissionCard(item: items[2])),
            ],
          ),
        ],
      ),
    );
  }
}

class MissionItem {
  const MissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
}

class MissionCard extends StatelessWidget {
  const MissionCard({super.key, required this.item});

  final MissionItem item;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      elevation: 2,
      borderRadius: DesignTokens.radiusXl,
      padding: const EdgeInsets.all(DesignTokens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: item.accent.withValues(alpha: 0.12),
              borderRadius: DesignTokens.radiusLg,
            ),
            child: Icon(item.icon, color: item.accent, size: 22.0),
          ),
          const SizedBox(height: DesignTokens.lg),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w800,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            item.subtitle,
            style: const TextStyle(
              fontSize: 13.0,
              height: 1.6,
              color: DesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}
