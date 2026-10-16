import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models/incident_draft.dart';
import '../data/models/incident_preview_record.dart';
import 'view_models/emergency_view_model.dart';
import '../../sos/presentation/sos_preview_dialog.dart';
import '../../hotlines/presentation/hotline_directory_preview_dialog.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  Future<void> _reportIncident(
    EmergencyViewModel viewModel, {
    IncidentDraft? existing,
  }) async {
    final details = TextEditingController(text: existing?.description);
    String category = existing?.category ?? 'Safety concern';
    var occurredAt = existing?.occurredAt ?? DateTime.now();
    final saved = await showDialog<_LocalIncident>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            existing == null
                ? 'Incident report preview'
                : 'Edit local incident draft',
          ),
          content: SizedBox(
            width: 440,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .65,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items:
                          const [
                                'Medical concern',
                                'Safety concern',
                                'Facility or environment',
                                'Transport',
                                'Other',
                              ]
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                      onChanged: (value) =>
                          setDialogState(() => category = value ?? category),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.schedule_outlined),
                      title: const Text('When did it happen?'),
                      subtitle: Text(
                        DateFormat.yMMMd().add_jm().format(occurredAt),
                      ),
                      trailing: const Icon(Icons.edit_calendar_outlined),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: occurredAt,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date == null || !context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(occurredAt),
                        );
                        if (time == null) return;
                        setDialogState(() {
                          occurredAt = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: details,
                      maxLength: 500,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Brief description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use fictional text only. This entry stays in memory on this device and is not sent. Location is not collected in this preview.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
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
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final text = details.text.trim();
                if (text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    _LocalIncident(category, text, occurredAt),
                  );
                }
              },
              child: Text(
                existing == null ? 'Save local preview' : 'Save draft changes',
              ),
            ),
          ],
        ),
      ),
    );
    details.dispose();
    if (saved != null && mounted) {
      if (existing == null) {
        viewModel.saveLocalIncidentDraft(
          category: saved.category,
          description: saved.description,
          occurredAt: saved.occurredAt,
        );
      } else {
        viewModel.updateLocalIncidentDraft(
          id: existing.id,
          category: saved.category,
          description: saved.description,
          occurredAt: saved.occurredAt,
        );
      }
    }
  }

  Future<void> _requestHelp() => SosPreviewDialog.show(context);

  @override
  Widget build(BuildContext context) => Consumer<EmergencyViewModel>(
    builder: (context, viewModel, _) => ListView(
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
                onPressed: _requestHelp,
                icon: const Icon(Icons.sos, size: 18),
                label: const Text('Review SOS limitation'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SafetyCard(
          icon: Icons.report_gmailerrorred_outlined,
          title: 'Report an incident',
          description:
              'Create a local interface preview with no location or service submission.',
          action: 'Create report preview',
          onPressed: () => _reportIncident(viewModel),
        ),
        const SizedBox(height: 10),
        _SafetyCard(
          icon: Icons.map_outlined,
          title: 'Incident list and map',
          description:
              'Review fictional status examples. Live records and map locations are not available.',
          action: 'Open sample incident list',
          onPressed: () => _showIncidentList(viewModel),
        ),
        const SizedBox(height: 10),
        _SafetyCard(
          icon: Icons.phone_in_talk_outlined,
          title: 'Hotline directory',
          description:
              'No institution-verified contacts have been configured for this project.',
          action: 'Preview directory states',
          onPressed: () => HotlineDirectoryPreviewDialog.show(context),
        ),
        const SizedBox(height: 20),
        Text(
          'Local report drafts',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (viewModel.localIncidentDrafts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No local incident drafts yet.',
                style: TextStyle(color: Color(0xFF748078), height: 1.4),
              ),
            ),
          )
        else
          for (final incident in viewModel.localIncidentDrafts)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF47745A),
                ),
                title: Text(incident.category),
                subtitle: Text(
                  'Local only · ${DateFormat.yMMMd().add_jm().format(incident.occurredAt)}\n${incident.description}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton<_IncidentDraftAction>(
                  tooltip: 'Local incident draft actions',
                  onSelected: (action) {
                    switch (action) {
                      case _IncidentDraftAction.edit:
                        _reportIncident(viewModel, existing: incident);
                      case _IncidentDraftAction.delete:
                        _discardIncident(viewModel, incident);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _IncidentDraftAction.edit,
                      child: Text('Edit draft'),
                    ),
                    PopupMenuItem(
                      value: _IncidentDraftAction.delete,
                      child: Text('Delete draft'),
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 16),
        const Text(
          'The app does not contact public emergency services and cannot guarantee alert delivery or response.',
          style: TextStyle(
            fontSize: 11,
            height: 1.45,
            color: Color(0xFF748078),
          ),
        ),
      ],
    ),
  );

  Future<void> _showIncidentList(
    EmergencyViewModel viewModel,
  ) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.map_outlined, color: Color(0xFF47745A), size: 36),
      title: const Text('Sample incident list'),
      content: SizedBox(
        width: 460,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .65,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF0D7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Fictional examples only. These rows have no dates, location, reporter identity, or incident narrative and do not describe current campus conditions.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      color: Color(0xFF6E581F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                for (final record in viewModel.sampleIncidentRecords)
                  _IncidentPreviewCard(record: record),
                const SizedBox(height: 4),
                const Text(
                  'Map markers are unavailable until the location precision policy, map provider, and reviewer access rules are approved. Use institution procedures for current safety information.',
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

  Future<void> _discardIncident(
    EmergencyViewModel viewModel,
    IncidentDraft incident,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete local incident draft?'),
        content: const Text(
          'This removes the draft narrative from this session. The report has not been sent or saved to a service.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep draft'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete draft'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      viewModel.deleteLocalIncidentDraft(incident.id);
    }
  }
}

class _LocalIncident {
  const _LocalIncident(this.category, this.description, this.occurredAt);
  final String category;
  final String description;
  final DateTime occurredAt;
}

enum _IncidentDraftAction { edit, delete }

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

class _IncidentPreviewCard extends StatelessWidget {
  const _IncidentPreviewCard({required this.record});

  final IncidentPreviewRecord record;

  @override
  Widget build(BuildContext context) {
    final severity = switch (record.severity) {
      IncidentPreviewSeverity.low => ('LOW', const Color(0xFF47745A)),
      IncidentPreviewSeverity.medium => ('MEDIUM', const Color(0xFF9A6810)),
      IncidentPreviewSeverity.high => ('HIGH', const Color(0xFF9E342B)),
    };
    final status = switch (record.status) {
      IncidentPreviewStatus.underReview => 'Under review',
      IncidentPreviewStatus.actionInProgress => 'Action in progress',
      IncidentPreviewStatus.resolved => 'Resolved',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 17,
                  color: Color(0xFF47745A),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    record.category,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  severity.$1,
                  style: TextStyle(
                    color: severity.$2,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(status, style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 4),
            const Text(
              'Sample record · no location shared',
              style: TextStyle(fontSize: 10, color: Color(0xFF748078)),
            ),
          ],
        ),
      ),
    );
  }
}
