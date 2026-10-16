import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final List<_LocalIncident> _localIncidents = [];

  Future<void> _reportIncident() async {
    final details = TextEditingController();
    String category = 'Safety concern';
    final saved = await showDialog<_LocalIncident>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Incident report preview'),
          content: SizedBox(
            width: 440,
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
                  'Use fictional text only. This entry stays in memory on this device and is not sent. No location is collected in this preview.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Color(0xFF748078),
                  ),
                ),
              ],
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
                  Navigator.pop(context, _LocalIncident(category, text));
                }
              },
              child: const Text('Save local preview'),
            ),
          ],
        ),
      ),
    );
    details.dispose();
    if (saved != null && mounted) {
      setState(() => _localIncidents.insert(0, saved));
    }
  }

  Future<void> _requestHelp() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFB63D34),
          size: 40,
        ),
        title: const Text('SOS is not connected'),
        content: const Text(
          'This app has no alert service or approved responder roster configured. No alert can be sent. Follow your institution’s emergency procedures and contact local emergency services directly if needed.',
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
        onPressed: _reportIncident,
      ),
      const SizedBox(height: 10),
      _SafetyCard(
        icon: Icons.phone_in_talk_outlined,
        title: 'Hotline directory',
        description:
            'No institution-verified contacts have been configured for this project.',
        action: 'View directory status',
        onPressed: () => showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No verified contacts configured'),
            content: const Text(
              'The planning documents require each hotline to be verified and kept current by an authorized institutional owner. No numbers are included in this local preview.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        'Local report drafts',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      if (_localIncidents.isEmpty)
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No local drafts. Submitted reports will appear here only for this session.',
              style: TextStyle(color: Color(0xFF748078), height: 1.4),
            ),
          ),
        )
      else
        for (final incident in _localIncidents)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(
                Icons.description_outlined,
                color: Color(0xFF47745A),
              ),
              title: Text(incident.category),
              subtitle: Text(
                incident.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Text(
                'Local only',
                style: TextStyle(fontSize: 9, color: Color(0xFF748078)),
              ),
            ),
          ),
      const SizedBox(height: 16),
      const Text(
        'The app does not contact public emergency services and cannot guarantee alert delivery or response.',
        style: TextStyle(fontSize: 11, height: 1.45, color: Color(0xFF748078)),
      ),
    ],
  );
}

class _LocalIncident {
  const _LocalIncident(this.category, this.description);
  final String category;
  final String description;
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
