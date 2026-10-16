import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Public landing page — premium, fully functional entry point.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const _PublicHeader()),
            SliverToBoxAdapter(child: const _HeroSection()),
            SliverToBoxAdapter(child: const _TrustBar()),
            SliverToBoxAdapter(child: const _MissionSection()),
            SliverToBoxAdapter(child: const _ProgramsSection()),
            SliverToBoxAdapter(child: const _SafetySection()),
            SliverToBoxAdapter(child: const _CtaSection()),
            SliverToBoxAdapter(child: const _PublicFooter()),
          ],
        ),
      ),
    );
  }
}

/// Public header with brand and navigation actions.
class _PublicHeader extends StatelessWidget {
  const _PublicHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.md,
        DesignTokens.lg,
        DesignTokens.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            decoration: DesignTokens.card3D(
              color: DesignTokens.canvas,
              shadowLevel: 1,
            ),
            child: ClipRRect(
              borderRadius: DesignTokens.radiusMd,
              child: Image.asset(
                'assets/images/sbnu_app_icon.png',
                semanticLabel: 'SBNU logo',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SBNu',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    color: DesignTokens.deepForest,
                  ),
                ),
                Text(
                  'CENTRAL MINDANAO UNIVERSITY',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: DesignTokens.gold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'VOLUNTEER MANAGEMENT SYSTEM',
                  style: TextStyle(
                    fontSize: 9.0,
                    color: DesignTokens.muted,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const _AuthActions(),
        ],
      ),
    );
  }
}

class _AuthActions extends StatelessWidget {
  const _AuthActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PremiumButton(
          label: 'Sign in',
          onPressed: () => context.go('/account/sign-in'),
          variant: ButtonVariant.outline,
          isFullWidth: false,
        ),
        const SizedBox(width: DesignTokens.sm),
        PremiumButton(
          label: 'Join the network',
          onPressed: () => context.go('/account/register'),
          variant: ButtonVariant.primary,
          isFullWidth: false,
          icon: Icons.person_add,
        ),
      ],
    );
  }
}

/// Hero section with mission statement and primary CTAs.
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xl,
        DesignTokens.lg,
        DesignTokens.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: DesignTokens.gold,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: DesignTokens.md),
          Text(
            'Service that moves a community forward.',
            style: const TextStyle(
              fontSize: 44.0,
              fontWeight: FontWeight.w900,
              color: DesignTokens.ink,
              height: 1.05,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: DesignTokens.lg),
          Text(
            'One connected space for CMU volunteers to discover opportunities, '
            'serve with purpose, and build a safer, more resilient community.',
            style: const TextStyle(
              fontSize: 17.0,
              height: 1.7,
              color: DesignTokens.muted,
            ),
          ),
          const SizedBox(height: DesignTokens.xxl),
          const _HeroActions(),
          const SizedBox(height: DesignTokens.xxl),
          const _TrustBar(),
        ],
      ),
    );
  }
}

class _HeroActions extends StatelessWidget {
  const _HeroActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumButton(
          label: 'Become a volunteer',
          onPressed: () => context.go('/account/register'),
          icon: Icons.person_add,
        ),
        const SizedBox(height: DesignTokens.md),
        PremiumButton(
          label: 'Explore programs',
          onPressed: () => context.go('/activities'),
          variant: ButtonVariant.outline,
          icon: Icons.event_available,
        ),
      ],
    );
  }
}

class _TrustBar extends StatelessWidget {
  const _TrustBar();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      elevation: 1,
      borderRadius: DesignTokens.radiusXl,
      padding: const EdgeInsets.all(DesignTokens.lg),
      color: Colors.white,
      opacity: 0.9,
      blur: 24.0,
      child: Row(
        children: [
          Expanded(
            child: _TrustItem(
              icon: Icons.people_alt_rounded,
              label: 'Active volunteers',
              value: '1,248',
              subtitle: 'Serving across CMU',
              accent: DesignTokens.forest,
            ),
          ),
          Container(width: 1.0, height: 40.0, color: DesignTokens.line),
          Expanded(
            child: _TrustItem(
              icon: Icons.access_time_rounded,
              label: 'Service hours',
              value: '38K+',
              subtitle: 'Since 2022',
              accent: DesignTokens.gold,
            ),
          ),
          Container(width: 1.0, height: 40.0, color: DesignTokens.line),
          Expanded(
            child: _TrustItem(
              icon: Icons.trending_up_rounded,
              label: 'Engagement rate',
              value: '87%',
              subtitle: 'Participation',
              accent: DesignTokens.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: DesignTokens.radiusMd,
          ),
          child: Icon(icon, color: accent, size: 18.0),
        ),
        const SizedBox(height: DesignTokens.md),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
            color: DesignTokens.ink,
          ),
        ),
        const SizedBox(height: DesignTokens.xs / 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            color: DesignTokens.ink,
          ),
        ),
        const SizedBox(height: DesignTokens.xs / 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
            color: DesignTokens.muted,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

/// Mission / purpose section with 3D cards.
class _MissionSection extends StatelessWidget {
  const _MissionSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      _MissionItem(
        icon: Icons.explore_rounded,
        title: 'Discover your purpose',
        subtitle:
            'Find service opportunities aligned with your skills, interests, and community priorities.',
        accent: DesignTokens.forest,
      ),
      _MissionItem(
        icon: Icons.groups_rounded,
        title: 'Serve together',
        subtitle:
            'Collaborate across colleges and units through organized, high-impact volunteer programs.',
        accent: DesignTokens.gold,
      ),
      _MissionItem(
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
              Expanded(child: _MissionCard(item: items[0])),
              const SizedBox(width: DesignTokens.md),
              Expanded(child: _MissionCard(item: items[1])),
              const SizedBox(width: DesignTokens.md),
              Expanded(child: _MissionCard(item: items[2])),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissionItem {
  const _MissionItem({
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

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.item});

  final _MissionItem item;

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

/// Programs section showing service areas with premium cards.
class _ProgramsSection extends StatelessWidget {
  const _ProgramsSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      _ProgramItem(
        title: 'Environment',
        accent: DesignTokens.forest,
        count: '12 active programs',
        heading: 'Restore what sustains us.',
        description:
            'Watershed, campus greening, and community clean-up initiatives.',
        icon: Icons.eco_rounded,
      ),
      _ProgramItem(
        title: 'Safety',
        accent: DesignTokens.error,
        count: '8 active programs',
        heading: 'Build a culture of readiness.',
        description:
            'Training, preparedness drills, and resilient community support.',
        icon: Icons.shield_rounded,
      ),
      _ProgramItem(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PremiumSectionHeading(
                title: 'Programs',
                subtitle: 'There is a place for every kind of service.',
                accentColor: DesignTokens.forest,
              ),
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
            _ProgramCard(item: item),
            const SizedBox(height: DesignTokens.md),
          ],
        ],
      ),
    );
  }
}

class _ProgramItem {
  const _ProgramItem({
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

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.item});

  final _ProgramItem item;

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

/// Safety features section.
class _SafetySection extends StatelessWidget {
  const _SafetySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xxl,
        DesignTokens.lg,
        DesignTokens.xxl,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.canvas,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52.0,
                height: 52.0,
                decoration: BoxDecoration(
                  color: DesignTokens.error.withValues(alpha: 0.12),
                  borderRadius: DesignTokens.radiusLg,
                  boxShadow: DesignTokens.shadowSoft(
                    color: DesignTokens.error.withValues(alpha: 0.2),
                    blur: 16.0,
                    offset: const Offset(0.0, 4.0),
                  ),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: DesignTokens.error,
                  size: 26.0,
                ),
              ),
              const SizedBox(width: DesignTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'POWERED BY ODRRM READINESS',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.error,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.xs / 2),
                    Text(
                      'Service, with safety at the center.',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.ink,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.sm),
                    Text(
                      'Access verified emergency contacts, submit safety reports, '
                      'receive campus advisories, and connect with designated responders.',
                      style: const TextStyle(
                        fontSize: 13.0,
                        height: 1.6,
                        color: DesignTokens.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.xl),
          SizedBox(
            width: double.infinity,
            child: PremiumButton(
              label: 'Access the safety center',
              onPressed: () => context.go('/emergency'),
              icon: Icons.shield,
            ),
          ),
        ],
      ),
    );
  }
}

/// Final call-to-action section.
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xxl,
        DesignTokens.lg,
        DesignTokens.xxl,
      ),
      decoration: BoxDecoration(
        gradient: DesignTokens.forestGradient,
        borderRadius: DesignTokens.radiusXl,
        boxShadow: DesignTokens.shadowStrong(
          color: DesignTokens.deepForest.withValues(alpha: 0.4),
          blur: 32.0,
          offset: const Offset(0.0, 16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: DesignTokens.md),
          const Text(
            'START SERVING TODAY',
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w800,
              color: DesignTokens.goldLight,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: DesignTokens.md),
          const Text(
            'Your time can change someone\'s tomorrow.',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          const Text(
            'Join the CMU SBNu volunteer network and turn your willingness '
            'to help into measurable impact.',
            style: TextStyle(
              fontSize: 14.0,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: DesignTokens.xl),
          PremiumButton(
            label: 'Create your volunteer account',
            onPressed: () => context.go('/account/register'),
            icon: Icons.person_add,
            variant: ButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}

/// Public footer with branding.
class _PublicFooter extends StatelessWidget {
  const _PublicFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xxl,
        DesignTokens.lg,
        DesignTokens.xxl,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: DesignTokens.line)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: DesignTokens.card3D(
                  color: DesignTokens.canvas,
                  shadowLevel: 1,
                ),
                child: ClipRRect(
                  borderRadius: DesignTokens.radiusMd,
                  child: Image.asset(
                    'assets/images/sbnu_app_icon.png',
                    semanticLabel: 'SBNU logo',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.md),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SBNu',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: DesignTokens.ink,
                    ),
                  ),
                  Text(
                    'CMU VOLUNTEER CORPS',
                    style: TextStyle(
                      fontSize: 9.0,
                      letterSpacing: 0.8,
                      color: DesignTokens.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.lg),
          const Text(
            'Service • Bayanihan • Nationalism • Unity',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: DesignTokens.muted,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
