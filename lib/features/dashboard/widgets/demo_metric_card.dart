import 'package:flutter/material.dart';

class DemoMetricCard extends StatelessWidget {
  const DemoMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE1E8E1)),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF65736D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: const Color(0xFF245B4B), size: 19),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1C2B2A),
            fontSize: 28,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail,
          style: const TextStyle(
            color: Color(0xFF65736D),
            fontSize: 11,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
