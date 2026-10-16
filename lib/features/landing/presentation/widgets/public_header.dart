import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Public header with brand and navigation actions.
class PublicHeader extends StatelessWidget {
  const PublicHeader({super.key});

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
