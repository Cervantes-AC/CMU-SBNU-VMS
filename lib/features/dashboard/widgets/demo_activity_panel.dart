import 'package:flutter/material.dart';

class DemoActivityPanel extends StatelessWidget {
  const DemoActivityPanel({super.key});

  static const _rows = [
    (
      'New member applications',
      'Review queue · sample',
      Icons.person_add_alt_1_outlined,
      Color(0xFFE7F0E8),
    ),
    (
      'Upcoming unit activity',
      'Event coordination · sample',
      Icons.event_available_outlined,
      Color(0xFFF1EBDD),
    ),
    (
      'System access review',
      'Security overview · sample',
      Icons.shield_outlined,
      Color(0xFFE9E9F5),
    ),
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE1E8E1)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ADMIN WORKSPACE',
          style: TextStyle(
            color: Color(0xFF245B4B),
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Priority overview',
          style: TextStyle(
            color: Color(0xFF1C2B2A),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < _rows.length; index++) ...[
          if (index > 0) const SizedBox(height: 12),
          _ActivityRow(
            title: _rows[index].$1,
            subtitle: _rows[index].$2,
            icon: _rows[index].$3,
            tint: _rows[index].$4,
          ),
        ],
      ],
    ),
  );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF245B4B), size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1C2B2A),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF65736D), fontSize: 11),
            ),
          ],
        ),
      ),
      const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA69F)),
    ],
  );
}
