import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/landing_brand_panel.dart';

class LandingHero extends StatelessWidget {
  const LandingHero({super.key, required this.isWide, required this.onExplore});

  final bool isWide;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'CENTRAL MINDANAO UNIVERSITY',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 54 : 42,
              height: 1.03,
              letterSpacing: -1.8,
              fontWeight: FontWeight.w800,
            ),
            children: const [
              TextSpan(text: 'Service,\n'),
              TextSpan(text: 'with a '),
              TextSpan(
                text: 'shared\nview.',
                style: TextStyle(color: AppColors.gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: const Text(
            'A thoughtful digital home for CMU School-Based NSRC Unit volunteers and the work they do together.',
            style: TextStyle(
              color: Color(0xFFD7E0EC),
              fontSize: 16,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.arrow_downward_rounded, size: 18),
              label: const Text('Explore the platform'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.info_outline_rounded, size: 18),
              label: const Text('About this preview'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF607794)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const _PreviewNotice(),
      ],
    );

    return Container(
      margin: EdgeInsets.fromLTRB(isWide ? 40 : 14, 12, isWide ? 40 : 14, 44),
      padding: EdgeInsets.all(isWide ? 58 : 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.cmuGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2609234A),
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 40),
                const Expanded(flex: 5, child: LandingBrandPanel()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 34),
                const LandingBrandPanel(),
              ],
            ),
    );
  }
}

class _PreviewNotice extends StatelessWidget {
  const _PreviewNotice();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 18, color: AppColors.gold),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Concept only. Sign-in, member records, and public services are not connected.',
            style: TextStyle(
              color: Color(0xFFD7E0EC),
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
      ],
    ),
  );
}
