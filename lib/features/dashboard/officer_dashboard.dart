import 'package:flutter/material.dart';

import '../../data/models/user.dart';
import 'widgets/dashboard_scaffold.dart';

/// Officer dashboard. Shows the officer's operations summary.
///
/// Authorized event/attendance/incident queues arrive with the stage-2
/// dashboard slice; this build shows the officer greeting and sign-out
/// only — no synthetic numbers.
class OfficerDashboard extends StatelessWidget {
  const OfficerDashboard({
    super.key,
    required this.displayName,
    required this.onSignOut,
  });

  final String displayName;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => DashboardScaffold(
        roleLabel: roleLabelFor(UserRole.officer),
        displayName: displayName,
        onSignOut: onSignOut,
        body: _OfficerBody(displayName: displayName),
      );
}

class _OfficerBody extends StatelessWidget {
  const _OfficerBody({required this.displayName});
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
          'Officer workspace · CMU School-Based NSRC Unit',
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
                  Icon(Icons.work_outline_rounded,
                      color: Color(0xFF245B4B), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Operations workspace',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Event management, attendance recording, and incident '
                'response tools are being connected. They will appear here '
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
