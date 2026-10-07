import 'package:flutter/material.dart';

import '../../data/models/user.dart';
import 'widgets/dashboard_scaffold.dart';

/// Member dashboard. Shows the member's own workspace summary.
///
/// Role-specific metrics read from authorized repositories arrive with the
/// stage-2 dashboard slice; this build shows the member greeting and
/// sign-out only — no synthetic numbers.
class MemberDashboard extends StatelessWidget {
  const MemberDashboard({
    super.key,
    required this.displayName,
    required this.onSignOut,
  });

  final String displayName;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => DashboardScaffold(
        roleLabel: roleLabelFor(UserRole.member),
        displayName: displayName,
        onSignOut: onSignOut,
        body: _MemberBody(displayName: displayName),
      );
}

class _MemberBody extends StatelessWidget {
  const _MemberBody({required this.displayName});
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListView(
      children: [
        Text(
          'Welcome, $displayName',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.7,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Member workspace · CMU School-Based NSRC Unit',
          style: TextStyle(color: muted, fontSize: 14),
        ),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE1E8E1)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Color(0xFF245B4B), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Your workspace',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Events, attendance, announcements, and other unit modules '
                'are being connected to your account. They will appear here '
                'as they become available.',
                style: TextStyle(color: muted, height: 1.55, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
