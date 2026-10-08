import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/section_eyebrow.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/scroll_reveal.dart';

class PlatformSection extends StatelessWidget {
  const PlatformSection({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(isWide ? 64 : 24, 8, isWide ? 64 : 24, 62),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionEyebrow(label: 'A PLATFORM FOR SERVICE'),
        const SizedBox(height: 13),
        Text(
          'The work is shared.\nThe tools should be, too.',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: isWide ? 36 : 29,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'A proposed starting point for keeping people, activities, and information easier to coordinate.',
          style: TextStyle(
            color: AppColors.mutedText,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 950
                ? 3
                : (constraints.maxWidth >= 600 ? 2 : 1);
            const gap = 14.0;
            final cardWidth =
                (constraints.maxWidth - gap * (count - 1)) / count;
            final cards = <Widget>[
              _PlatformCard(
                width: cardWidth,
                number: '01',
                icon: Icons.groups_2_outlined,
                tint: AppColors.green,
                title: 'People in view',
                description:
                    'A role-aware home for volunteers and authorized unit officers.',
              ),
              _PlatformCard(
                width: cardWidth,
                number: '02',
                icon: Icons.event_note_outlined,
                tint: AppColors.orange,
                title: 'Activities in focus',
                description:
                    'A place to coordinate approved unit work and shared plans.',
              ),
              _PlatformCard(
                width: cardWidth,
                number: '03',
                icon: Icons.shield_outlined,
                tint: AppColors.navy,
                title: 'Information handled carefully',
                description:
                    'Privacy and appropriate access guide the experience.',
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (var index = 0; index < cards.length; index++)
                  ScrollReveal(
                    delay: Duration(milliseconds: index * 130),
                    child: cards[index],
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class _PlatformCard extends StatelessWidget {
  const _PlatformCard({
    required this.width,
    required this.number,
    required this.icon,
    required this.tint,
    required this.title,
    required this.description,
  });

  final double width;
  final String number;
  final IconData icon;
  final Color tint;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Container(
      constraints: const BoxConstraints(minHeight: 218),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0809234A),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: tint, size: 22),
              ),
              Text(
                number,
                style: const TextStyle(
                  color: Color(0xFFB5BFCC),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.mutedText,
              height: 1.55,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}
