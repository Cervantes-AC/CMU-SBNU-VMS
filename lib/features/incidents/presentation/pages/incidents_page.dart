import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/performance/performance.dart';
import '../../../../core/security/screen_security.dart';
import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/incident.dart';
import '../view_models/incidents_view_model.dart';
import 'incidents_map_page.dart';

/// Incidents page - submit and review incident reports.
class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentsViewModel>(
      builder: (context, viewModel, _) {
        return SecurePage(
          enabled: true,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Incidents & Safety'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const IncidentsMapPage()),
                  ),
                  tooltip: 'View incidents on map',
                ),
              ],
            ),
            body: AppStateWrapper(
              status: viewModel.status,
              onRetry: viewModel.init,
              errorMessage: viewModel.error?.message,
              child: viewModel.myIncidents.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.report_outlined,
                      title: 'No incident reports.',
                      subtitle:
                          'Submit a report if you observe a safety concern.',
                    )
                  : ResponsiveListView(
                      itemCount: viewModel.myIncidents.length,
                      itemBuilder: (context, index) {
                        final inc = viewModel.myIncidents[index];
                        return _IncidentCard(
                          incident: inc,
                          onTap: () => viewModel.select(inc),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showSubmitDialog(context, viewModel),
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void _showSubmitDialog(BuildContext context, IncidentsViewModel viewModel) {
    final categoryController = TextEditingController();
    final narrativeController = TextEditingController();
    String severity = 'medium';
    bool shareLocation = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Incident'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              controller: categoryController,
              label: 'Category',
              hint: 'e.g. Safety, Facility',
              icon: Icons.category_outlined,
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: narrativeController,
              label: 'What happened?',
              hint: 'Describe the incident',
              maxLines: 4,
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: severity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
              ],
              onChanged: (v) => severity = v ?? 'medium',
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Checkbox(
                value: shareLocation,
                onChanged: (v) => shareLocation = v ?? false,
              ),
              title: const Text('Share location'),
              subtitle: const Text('Optional - location helps responders'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Submit',
            onPressed: () {
              if (categoryController.text.isEmpty ||
                  narrativeController.text.isEmpty) {
                return;
              }
              Navigator.of(context).pop();
              viewModel.submitIncident(
                Incident(
                  id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
                  reporterUid: 'current_user',
                  organizationId: 'org_001',
                  category: categoryController.text.trim(),
                  narrative: narrativeController.text.trim(),
                  severity: IncidentSeverity.values.firstWhere(
                    (e) => e.name == severity,
                    orElse: () => IncidentSeverity.medium,
                  ),
                  status: IncidentStatus.submitted,
                  occurredAt: DateTime.now(),
                  reportedAt: DateTime.now(),
                  locationShared: shareLocation,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  const _IncidentCard({required this.incident, required this.onTap});

  final Incident incident;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (incident.severity) {
      IncidentSeverity.critical => const Color(0xFFB63D34),
      IncidentSeverity.high => const Color(0xFFD58A2F),
      IncidentSeverity.medium => const Color(0xFFD5A52F),
      IncidentSeverity.low => const Color(0xFF4C735E),
    };

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.category,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17231C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      incident.narrative,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF68766D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            incident.severityLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5EFE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            incident.statusLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF196142),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFADB5AF)),
            ],
          ),
        ),
      ),
    );
  }
}
