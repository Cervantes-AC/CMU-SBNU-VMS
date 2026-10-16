import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Public footer with branding.
class PublicFooter extends StatelessWidget {
  const PublicFooter({super.key});

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
