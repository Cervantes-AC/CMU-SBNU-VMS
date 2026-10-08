import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.volunteer_activism_outlined,
          size: 16,
          color: AppColors.orange,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            'CMU School-Based NSRC Unit  •  Local development preview',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}
