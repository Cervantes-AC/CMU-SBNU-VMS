import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/section_eyebrow.dart';

class PrinciplesSection extends StatelessWidget {
  const PrinciplesSection({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: AppColors.odrrmForest,
    padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24, vertical: 44),
    child: isWide
        ? const Row(
            children: [
              Expanded(flex: 5, child: _PrinciplesIntro()),
              SizedBox(width: 44),
              Expanded(flex: 6, child: _PrincipleList()),
            ],
          )
        : const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PrinciplesIntro(),
              SizedBox(height: 26),
              _PrincipleList(),
            ],
          ),
  );
}

class _PrinciplesIntro extends StatelessWidget {
  const _PrinciplesIntro();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionEyebrow(label: 'BUILT WITH CARE'),
      SizedBox(height: 14),
      Text(
        'Good service starts with trust.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 31,
          height: 1.12,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.7,
        ),
      ),
      SizedBox(height: 12),
      Text(
        'This preview is a design direction. Real workflows and access will follow approved unit policies.',
        style: TextStyle(color: Color(0xFFCAD5E2), height: 1.6, fontSize: 14),
      ),
    ],
  );
}

class _PrincipleList extends StatelessWidget {
  const _PrincipleList();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        '01',
        'Role-aware by design',
        'A person should see only the tools and information meant for their role.',
      ),
      (
        '02',
        'Respect for privacy',
        'Personal information deserves careful handling at every step.',
      ),
      (
        '03',
        'Local-first development',
        'This preview uses no live accounts, member records, or services.',
      ),
    ];
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(color: Color(0xFF294768), height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                items[i].$1,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[i].$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i].$3,
                      style: const TextStyle(
                        color: Color(0xFFCAD5E2),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
