import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';

class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 24, height: 3, color: AppColors.orange),
      const SizedBox(width: 9),
      Text(
        label,
        style: const TextStyle(
          color: AppColors.orange,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
    ],
  );
}
