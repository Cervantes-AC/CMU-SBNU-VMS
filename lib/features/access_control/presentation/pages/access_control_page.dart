import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/permission_entry.dart';

/// Access and operations page — premium, fully functional UX.
class AccessControlPage extends StatefulWidget {
  const AccessControlPage({super.key});

  @override
  State<AccessControlPage> createState() => _AccessControlPageState();
}

class _AccessControlPageState extends State<AccessControlPage> {
  final _entries = [
    PermissionEntry(
      dataArea: 'Own user profile',
      volunteer: 'Read own; update allowlist',
      officer: 'Read assigned scope',
      admin: 'Manage account fields',
      server: 'Privileged transitions only',
    ),
    PermissionEntry(
      dataArea: 'Organizations',
      volunteer: 'Read assigned',
      officer: 'Read/manage assigned scope',
      admin: 'Manage hierarchy',
      server: 'Validate privileged changes',
    ),
    PermissionEntry(
      dataArea: 'Activities / Participation',
      volunteer: 'Read eligible; own request',
      officer: 'Manage assigned activities',
      admin: 'System administration',
      server: 'Optional invariant checks',
    ),
    PermissionEntry(
      dataArea: 'Attendance',
      volunteer: 'Read own',
      officer: 'Record/correct assigned activity',
      admin: 'Admin correction if approved',
      server: 'Optional validation/audit',
    ),
    PermissionEntry(
      dataArea: 'Announcements',
      volunteer: 'Read matched audience',
      officer: 'Publish approved audiences',
      admin: 'Manage publisher settings',
      server: 'Optional scheduled publish',
    ),
    PermissionEntry(
      dataArea: 'Incidents',
      volunteer: 'Create; read own limited details',
      officer: 'Read assigned; update if reviewer',
      admin: 'Full review only if policy',
      server: 'Route/validate privileged transitions',
    ),
    PermissionEntry(
      dataArea: 'SOS alerts',
      volunteer: 'Create if permitted; limited own state',
      officer: 'Only if designated responder',
      admin: 'Admin only if assigned policy',
      server: 'Create/route/ack/status with checks',
    ),
    PermissionEntry(
      dataArea: 'Hotlines',
      volunteer: 'Read verified active',
      officer: 'Read verified active',
      admin: 'Edit only if designated',
      server: 'Verification state changes if approved',
    ),
    PermissionEntry(
      dataArea: 'Audit / Export',
      volunteer: 'No broad audit access',
      officer: 'Scoped review if approved',
      admin: 'Authorized review/export',
      server: 'Create restricted audit records',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.lg),
              child: Column(
                children: [
                  for (final entry in _entries) ...[
                    _MatrixRow(entry: entry),
                    const SizedBox(height: DesignTokens.md),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xl,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.canvas,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Access & Operations',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Proposed permission matrix (UX guidance only).',
            style: DesignTokens.body.copyWith(
              fontSize: 15,
              color: DesignTokens.muted,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Real authorization is enforced at trusted backend boundaries. '
            'No roles can be changed from this screen.',
            style: DesignTokens.caption.copyWith(
              color: DesignTokens.muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatrixRow extends StatelessWidget {
  const _MatrixRow({required this.entry});

  final PermissionEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 1,
        borderRadius: DesignTokens.radiusXl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(DesignTokens.lg),
              child: Text(
                entry.dataArea,
                style: DesignTokens.headlineSmall.copyWith(
                  fontSize: 15,
                  color: DesignTokens.ink,
                ),
              ),
            ),
            PremiumDivider(),
            Row(
              children: [
                Expanded(
                  child: _Cell(
                    label: 'Volunteer',
                    text: entry.volunteer,
                    color: entry.volunteerColor,
                  ),
                ),
                Expanded(
                  child: _Cell(
                    label: 'Officer',
                    text: entry.officer,
                    color: entry.officerColor,
                  ),
                ),
                Expanded(
                  child: _Cell(
                    label: 'Admin',
                    text: entry.admin,
                    color: entry.adminColor,
                  ),
                ),
                Expanded(
                  child: _Cell(
                    label: 'Server',
                    text: entry.server,
                    color: entry.serverColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label, required this.text, required this.color});

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DesignTokens.caption.copyWith(
              color: DesignTokens.muted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: DesignTokens.radiusLg,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
