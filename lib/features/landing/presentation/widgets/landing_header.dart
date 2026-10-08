import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/sbnu_brand_mark.dart';

class LandingHeader extends StatelessWidget {
  const LandingHeader({
    super.key,
    required this.isWide,
    required this.onPlatform,
    required this.onPrinciples,
  });

  final bool isWide;
  final VoidCallback onPlatform;
  final VoidCallback onPrinciples;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 12, vertical: 14),
    child: Row(
      children: [
        SbnuBrandMark(size: isWide ? 48 : 40, borderRadius: 9),
        SizedBox(width: isWide ? 12 : 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isWide ? 'CMU • ODRRM • SBNU' : 'CMU • SBNU',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                fontSize: isWide ? 12 : 11,
              ),
            ),
            Text(
              'VOLUNTEER MANAGEMENT SYSTEM',
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 9,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (isWide) ...[
          _NavLink(label: 'The platform', onPressed: onPlatform),
          const SizedBox(width: 20),
          _NavLink(label: 'Our principles', onPressed: onPrinciples),
          const SizedBox(width: 24),
        ],
        _PreviewBadge(compact: !isWide),
      ],
    ),
  );
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(foregroundColor: AppColors.navy),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF0E8),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFFFFD8C6)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 7, color: AppColors.orange),
        SizedBox(width: 7),
        Text(
          compact ? 'PREVIEW' : 'LOCAL PREVIEW',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    ),
  );
}
