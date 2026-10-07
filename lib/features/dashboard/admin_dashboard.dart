import 'package:flutter/material.dart';

import '../../data/models/user.dart';
import 'widgets/dashboard_scaffold.dart';

/// Administrator dashboard. Shows the unit administration summary.
///
/// Account review, audit, and operational analytics arrive with later
/// slices; this build shows the administrator greeting and sign-out only —
/// no synthetic numbers (the debug-only `demo_admin_dashboard_screen`
/// remains the local synthetic preview).
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({
    super.key,
    required this.displayName,
    required this.onSignOut,
  });

  final String displayName;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => DashboardScaffold(
        roleLabel: roleLabelFor(UserRole.admin),
        displayName: displayName,
        onSignOut: onSignOut,
        body: _AdminBody(displayName: displayName),
      );
}

class _AdminBody extends StatelessWidget {
  const _AdminBody({required this.displayName});
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
          'Administration workspace · CMU School-Based NSRC Unit',
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
                  Icon(Icons.admin_panel_settings_outlined,
                      color: Color(0xFF245B4B), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Administration workspace',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Account approvals, role management, and audit review are '
                'being connected through trusted backend operations. They '
                'will appear here as they become available.',
                style: TextStyle(color: muted, height: 1.55, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
