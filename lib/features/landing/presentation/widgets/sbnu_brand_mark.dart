import 'package:flutter/material.dart';

/// Reusable SBNU mark presentation for the landing page.
class SbnuBrandMark extends StatelessWidget {
  const SbnuBrandMark({super.key, required this.size, this.borderRadius = 0});

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Image.asset(
      'assets/images/sbnu_app_icon.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
      semanticLabel: 'Central Mindanao University School-Based NSRC Unit logo',
    ),
  );
}
