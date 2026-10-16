import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Trust bar showing key community metrics.
class TrustBar extends StatelessWidget {
  const TrustBar({super.key});

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
            child: TrustItem(
              icon: Icons.people_alt_rounded,
              label: 'Active volunteers',
              value: '1,248',
              subtitle: 'Serving across CMU',
              accent: DesignTokens.forest,
            ),
          ),
          Container(width: 1.0, height: 40.0, color: DesignTokens.line),
          Expanded(
            child: TrustItem(
              icon: Icons.access_time_rounded,
              label: 'Service hours',
              value: '38K+',
              subtitle: 'Since 2022',
              accent: DesignTokens.gold,
            ),
          ),
          Container(width: 1.0, height: 40.0, color: DesignTokens.line),
          Expanded(
            child: TrustItem(
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

class TrustItem extends StatelessWidget {
  const TrustItem({
    super.key,
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
