import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/audit_event_preview.dart';
import 'view_models/audit_preview_view_model.dart';

class AuditPreviewDialog {
  const AuditPreviewDialog._();

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.history, color: Color(0xFF47745A), size: 34),
      title: const Text('Audit event preview'),
      content: SizedBox(
        width: 480,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .68,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF0D7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Synthetic examples only. No real actors, record IDs, timestamps, or audit events are present. Opening this preview does not grant audit access.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      color: Color(0xFF6E581F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<AuditPreviewViewModel>(
                  builder: (context, viewModel, _) => Column(
                    children: [
                      for (final event in viewModel.events)
                        _AuditEventCard(event: event),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Production audit records require restricted read access and trusted append-only writes. Keep credentials, tokens, unnecessary narrative, and location out of audit details.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: Color(0xFF748078),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _AuditEventCard extends StatelessWidget {
  const _AuditEventCard({required this.event});

  final AuditEventPreview event;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.action,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          _AuditField(
            label: 'Target',
            value: '${event.recordType} · ${event.targetLabel}',
          ),
          _AuditField(label: 'Actor', value: event.actorLabel),
          _AuditField(label: 'Outcome', value: event.outcome),
          _AuditField(label: 'Time', value: event.timestampLabel),
          const Divider(height: 16),
          Text(
            event.changedFieldsSummary,
            style: const TextStyle(fontSize: 10, color: Color(0xFF65746A)),
          ),
        ],
      ),
    ),
  );
}

class _AuditField extends StatelessWidget {
  const _AuditField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 10, color: Color(0xFF65746A)),
          ),
        ),
      ],
    ),
  );
}
