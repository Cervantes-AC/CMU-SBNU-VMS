import 'package:flutter/material.dart';

class LandingHeader extends StatelessWidget {
  const LandingHeader({
    super.key,
    required this.compact,
    required this.horizontalPadding,
    required this.onSignIn,
  });

  final bool compact;
  final double horizontalPadding;
  final VoidCallback onSignIn;

  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _green = Color(0xFF245B4B);
  static const _line = Color(0xFFE1E8E1);

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            16,
          ),
          child: Row(
            children: [
              _logo(
                'assets/images/cmu_logo.png',
                'Central Mindanao University',
              ),
              const SizedBox(width: 8),
              _logo('assets/images/SBNU LOGO.png', 'School-Based NSRC'),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volunteer Management System',
                      style: TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'CMU · School-Based NSRC Unit',
                      style: TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (compact)
                IconButton.filled(
                  tooltip: 'Member sign in',
                  onPressed: onSignIn,
                  icon: const Icon(Icons.login_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: onSignIn,
                  icon: const Icon(Icons.login_rounded, size: 17),
                  label: const Text('Member sign in'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _logo(String path, String label) => Container(
    width: 46,
    height: 46,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Image.asset(path, fit: BoxFit.contain, semanticLabel: label),
  );
}
