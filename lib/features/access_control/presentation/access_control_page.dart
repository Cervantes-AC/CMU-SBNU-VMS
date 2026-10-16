import 'package:flutter/material.dart';

class AccessControlPage extends StatelessWidget {
  const AccessControlPage({super.key});

  static const _candidateRoles = [
    (
      'Volunteer / member',
      'Own profile, eligible activities, own participation records',
    ),
    (
      'Officer / coordinator',
      'Assigned activities and organization scope only',
    ),
    ('Administrator', 'Approved account and system configuration tasks'),
  ];

  static const _designations = [
    'Incident reviewer',
    'SOS responder',
    'Hotline verifier',
    'Announcement publisher',
    'Report analyst',
    'Audit reviewer',
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    children: [
      Text(
        'Administration',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFFAA7C10),
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Access and operations',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      const Text(
        'Review the proposed permission model and setup status. This preview does not administer accounts or grant access.',
        style: TextStyle(color: Color(0xFF748078), height: 1.4),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF0D7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.rule_outlined, color: Color(0xFF895F00)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Role names and permissions are candidates in the planning specification and require owner approval.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: Color(0xFF6E581F),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'Candidate roles',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      for (final role in _candidateRoles)
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                Text(
                  role.$2,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Color(0xFF748078),
                  ),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 14),
      Text(
        'Scoped designations',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 5),
      const Text(
        'These are separate assignments, not automatic permissions attached to a broad role.',
        style: TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF748078)),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final designation in _designations)
            Chip(
              avatar: const Icon(Icons.lock_outline, size: 14),
              label: Text(designation),
            ),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        'Environment status',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      const _StatusRow(
        label: 'Authentication and account lifecycle',
        value: 'Not connected',
      ),
      const _StatusRow(
        label: 'Firestore access',
        value: 'Denied by current rules',
      ),
      const _StatusRow(
        label: 'Trusted backend operations',
        value: 'Not configured',
      ),
      const _StatusRow(label: 'Audit event review', value: 'Not connected'),
      const _StatusRow(
        label: 'Support and recovery owner',
        value: 'To be confirmed',
      ),
      const SizedBox(height: 14),
      const Text(
        'No user can grant themselves a role or responder designation. Any eventual implementation must enforce scope and separation of duties at a trusted boundary.',
        style: TextStyle(fontSize: 11, height: 1.5, color: Color(0xFF748078)),
      ),
    ],
  );
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 7),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11))),
          const SizedBox(width: 8),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7B6250),
            ),
          ),
        ],
      ),
    ),
  );
}
