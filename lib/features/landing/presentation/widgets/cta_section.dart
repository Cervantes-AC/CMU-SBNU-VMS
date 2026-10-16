import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Final call-to-action section.
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

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
