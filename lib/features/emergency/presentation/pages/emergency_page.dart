import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/hotlines/presentation/widgets/hotline_directory_preview_dialog.dart';
import 'package:cmu_sbnu_vms/features/incidents/presentation/widgets/incidents_preview_panel.dart';
import 'package:cmu_sbnu_vms/features/sos/presentation/widgets/sos_preview_dialog.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    children: [
      Text(
        'ODRRM safety center',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFFAA7C10),
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Emergency and safety',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      const Text(
        'Safety tools are shown for interface development. This app does not contact emergency responders or public services.',
        style: TextStyle(color: Color(0xFF748078), height: 1.4),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF0C402B),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: Color(0xFFE1B747),
              size: 27,
            ),
            const SizedBox(height: 10),
            const Text(
              'Urgent help',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'No responders are configured. Any SOS attempt will remain unsent.',
              style: TextStyle(
                color: Color(0xFFD0DDD4),
                fontSize: 12,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 13),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFAE9E6),
                foregroundColor: const Color(0xFF9E342B),
              ),
              onPressed: () => SosPreviewDialog.show(context),
              icon: const Icon(Icons.sos, size: 18),
              label: const Text('Review SOS limitation'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const IncidentsPreviewPanel(),
      const SizedBox(height: 10),
      _SafetyCard(
        icon: Icons.phone_in_talk_outlined,
        title: 'Hotline directory',
        description:
            'No institution-verified contacts have been configured for this project.',
        action: 'Preview directory states',
        onPressed: () => HotlineDirectoryPreviewDialog.show(context),
      ),
      const SizedBox(height: 14),
      const Text(
        'The app does not contact public emergency services and cannot guarantee alert delivery or response.',
        style: TextStyle(fontSize: 11, height: 1.45, color: Color(0xFF748078)),
      ),
    ],
  );
}

class _SafetyCard extends StatelessWidget {
  const _SafetyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF47745A)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF748078),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onPressed, child: Text(action)),
          ),
        ],
      ),
    ),
  );
}
