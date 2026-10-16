import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Safety features section.
class SafetySection extends StatelessWidget {
  const SafetySection({super.key});

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
