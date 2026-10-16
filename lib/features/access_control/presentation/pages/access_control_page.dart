import 'package:flutter/material.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/permission_entry.dart';

/// Access and operations page - shows proposed permission matrix (UX only).
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
      appBar: AppBar(title: const Text('Access & Operations')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF3F5F0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proposed Permission Matrix',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF17231C),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'This matrix is UX guidance only. Real authorization is enforced at trusted backend boundaries. '
                    'No roles can be changed from this screen.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF68766D)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final e = _entries[index];
                  return _MatrixRow(entry: e);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatrixRow extends StatelessWidget {
  const _MatrixRow({required this.entry});

  final PermissionEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.dataArea,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF17231C),
              ),
            ),
            const SizedBox(height: 10),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF748078),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
