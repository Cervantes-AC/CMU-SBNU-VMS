import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/trust_bar.dart';
import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Hero section with mission statement and primary CTAs.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

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
          const TrustBar(),
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
