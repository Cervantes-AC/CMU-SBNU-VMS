import 'package:flutter/material.dart';

/// A small badge indicating that a feature is preview/sample data only.
class AppPreviewBadge extends StatelessWidget {
  const AppPreviewBadge({super.key, this.label = 'SAMPLE DATA'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF0D7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF895F00),
          fontSize: 9,
          letterSpacing: 0.7,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
