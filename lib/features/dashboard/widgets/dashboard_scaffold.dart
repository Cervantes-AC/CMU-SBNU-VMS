import 'package:flutter/material.dart';

import '../../../data/models/user.dart';

/// Shared scaffold for the role dashboards: brand app bar with an
/// account/role block, sign-out action, and a body slot. Navigation
/// destinations arrive with the stage-2 shell slice.
class DashboardScaffold extends StatelessWidget {
  const DashboardScaffold({
    super.key,
    required this.roleLabel,
    required this.displayName,
    required this.body,
    required this.onSignOut,
  });

  /// Human role label (from [roleLabelFor]) shown with the account name.
  final String roleLabel;

  /// Signed-in member's display name for the account block.
  final String displayName;

  final Widget body;
  final VoidCallback onSignOut;

  static const _green = Color(0xFF245B4B);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E8E1)),
              ),
              child: Image.asset('assets/images/SBNU LOGO.png',
                  fit: BoxFit.contain,
                  semanticLabel: 'CMU School-Based NSRC Unit logo'),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'CMU SBNU VMS',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        actions: [
          if (!compact)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    roleLabel,
                    style: TextStyle(fontSize: 11, color: _green),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _green.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _green.withAlpha(70)),
                ),
                child: Text(
                  roleLabel,
                  style: const TextStyle(
                    color: _green,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (!compact)
            TextButton.icon(
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded, size: 17),
              label: const Text('Sign out'),
              style: TextButton.styleFrom(foregroundColor: _green),
            )
          else
            IconButton(
              tooltip: 'Sign out ($roleLabel)',
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.fromLTRB(compact ? 20 : 32, 8,
                  compact ? 20 : 32, 32),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

/// Role label shown in the dashboard header.
String roleLabelFor(UserRole role) => switch (role) {
      UserRole.member => 'Member',
      UserRole.officer => 'Officer',
      UserRole.admin => 'Administrator',
    };
