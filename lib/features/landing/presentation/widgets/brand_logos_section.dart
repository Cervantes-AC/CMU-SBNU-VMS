import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/scroll_reveal.dart';

/// Supporting organization marks in the documented order, with SBNU primary.
class BrandLogosSection extends StatelessWidget {
  const BrandLogosSection({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(isWide ? 64 : 18, 0, isWide ? 64 : 18, 56),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 18, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6EBDD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1009234A),
            blurRadius: 24,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'ONE UNIT. ROOTED IN CMU.',
            style: TextStyle(
              color: AppColors.cmuGreen,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 580;
              final width = compact ? (constraints.maxWidth - 14) / 2 : 190.0;
              return Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 14,
                runSpacing: 14,
                children:
                    [
                          _OrganizationLogo(
                            width: width,
                            height: compact ? 128 : 142,
                            asset: 'assets/images/cmu_logo_brand.png',
                            label: 'Central Mindanao University',
                            shortName: 'CMU',
                          ),
                          _OrganizationLogo(
                            width: width,
                            height: compact ? 128 : 142,
                            asset: 'assets/images/odrrm_logo_brand.png',
                            label:
                                'Office of Disaster Risk Reduction and Management',
                            shortName: 'ODRRM',
                          ),
                          _OrganizationLogo(
                            width: compact ? constraints.maxWidth * 0.72 : 220,
                            height: compact ? 168 : 174,
                            asset: 'assets/images/sbnu_logo_brand.png',
                            label:
                                'School-Based National Service Reserve Corps Unit',
                            shortName: 'SBNU',
                            isPrimary: true,
                          ),
                        ]
                        .asMap()
                        .entries
                        .map(
                          (entry) => ScrollReveal(
                            delay: Duration(milliseconds: entry.key * 120),
                            child: entry.value,
                          ),
                        )
                        .toList(),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _OrganizationLogo extends StatelessWidget {
  const _OrganizationLogo({
    required this.width,
    required this.height,
    required this.asset,
    required this.label,
    required this.shortName,
    this.isPrimary = false,
  });

  final double width;
  final double height;
  final String asset;
  final String label;
  final String shortName;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    padding: EdgeInsets.all(isPrimary ? 7 : 12),
    decoration: BoxDecoration(
      color: isPrimary ? const Color(0xFFFFFBF1) : const Color(0xFFFAFBF8),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isPrimary ? AppColors.cmuGold : const Color(0xFFE8EBE3),
        width: isPrimary ? 2 : 1,
      ),
    ),
    child: Column(
      children: [
        Expanded(
          child: Image.asset(asset, fit: BoxFit.contain, semanticLabel: label),
        ),
        const SizedBox(height: 5),
        Text(
          shortName,
          style: TextStyle(
            color: isPrimary ? AppColors.navy : AppColors.mutedText,
            fontWeight: FontWeight.w900,
            fontSize: isPrimary ? 11 : 10,
            letterSpacing: 1,
          ),
        ),
      ],
    ),
  );
}
