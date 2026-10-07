import 'package:flutter/material.dart';

class AuthIdentityHeader extends StatelessWidget {
  const AuthIdentityHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE6E6D8)),
        ),
        child: Image.asset('assets/images/SBNU LOGO.png', fit: BoxFit.contain),
      ),
      const SizedBox(width: 12),
      const Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Management System',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'CMU · School-Based NSRC Unit',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}
