import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/incident.dart';
import '../view_models/incidents_view_model.dart';

/// Incidents page — premium, fully functional.
class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          Consumer<IncidentsViewModel>(
            builder: (context, viewModel, _) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    AppStateWrapper(
                      status: viewModel.status,
                      onRetry: viewModel.init,
                      errorMessage: viewModel.error?.message,
                      child: viewModel.myIncidents.isEmpty
                          ? const PremiumEmptyState(
                              icon: Icons.report_outlined,
                              title: 'No incident reports.',
                              subtitle:
                                  'Submit a report if you observe a safety concern.',
                            )
                          : Padding(
                              padding: const EdgeInsets.all(DesignTokens.lg),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
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
                    ),
                    const SizedBox(height: DesignTokens.xxl),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(DesignTokens.lg),
        child: PremiumButton(
          label: 'Report Incident',
          onPressed: () => _showSubmitDialog(context),
          icon: Icons.add_circle_rounded,
          isFullWidth: false,
          variant: ButtonVariant.destructive,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final categoryController = TextEditingController();
    final narrativeController = TextEditingController();
    String severity = 'medium';
    bool shareLocation = false;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PremiumCard(
          elevation: 3,
          borderRadius: DesignTokens.radiusXl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(DesignTokens.lg),
                  child: Text('Report Incident', style: DesignTokens.headline),
                ),
                PremiumDivider(),
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PremiumInputField(
                        controller: categoryController,
                        label: 'Category',
                        hint: 'e.g. Safety, Facility',
                        icon: Icons.category_rounded,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: narrativeController,
                        label: 'What happened?',
                        hint: 'Describe the incident',
                        maxLines: 4,
                        icon: Icons.description_rounded,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      DropdownButtonFormField<String>(
                        initialValue: severity,
                        decoration: InputDecoration(
                          labelText: 'Severity',
                          labelStyle: DesignTokens.captionBold.copyWith(
                            color: DesignTokens.muted,
                            fontSize: 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: DesignTokens.radiusLg,
                            borderSide: BorderSide(color: DesignTokens.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: DesignTokens.radiusLg,
                            borderSide: BorderSide(color: DesignTokens.line),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: DesignTokens.radiusLg,
                            borderSide: const BorderSide(
                              color: DesignTokens.forest,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'low', child: Text('Low')),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(value: 'high', child: Text('High')),
                          DropdownMenuItem(
                            value: 'critical',
                            child: Text('Critical'),
                          ),
                        ],
                        onChanged: (v) => severity = v ?? 'medium',
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.md),
                        decoration: BoxDecoration(
                          color: DesignTokens.canvas,
                          borderRadius: DesignTokens.radiusLg,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: shareLocation,
                              onChanged: (v) => shareLocation = v ?? false,
                              activeColor: DesignTokens.forest,
                            ),
                            const SizedBox(width: DesignTokens.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Share location',
                                    style: DesignTokens.title.copyWith(
                                      fontSize: 13,
                                      color: DesignTokens.ink,
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.xs / 2),
                                  Text(
                                    'Optional - location helps responders',
                                    style: DesignTokens.caption.copyWith(
                                      color: DesignTokens.muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumButton(
                              label: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                              variant: ButtonVariant.outline,
                              isFullWidth: true,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.md),
                          Expanded(
                            child: PremiumButton(
                              label: 'Submit Report',
                              onPressed: () {
                                if (categoryController.text.isEmpty ||
                                    narrativeController.text.isEmpty) {
                                  return;
                                }
                                Navigator.of(context).pop();
                                context.read<IncidentsViewModel>().submitIncident(
                                  Incident(
                                    id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
                                    reporterUid: 'current_user',
                                    organizationId: 'org_001',
                                    category: categoryController.text.trim(),
                                    narrative: narrativeController.text.trim(),
                                    severity: IncidentSeverity.values
                                        .firstWhere(
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
                              variant: ButtonVariant.destructive,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xl,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Incidents & Safety',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Report and track safety concerns across campus.',
            style: DesignTokens.body.copyWith(
              fontSize: 15,
              color: DesignTokens.muted,
            ),
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
      IncidentSeverity.critical => DesignTokens.error,
      IncidentSeverity.high => DesignTokens.gold,
      IncidentSeverity.medium => DesignTokens.warning,
      IncidentSeverity.low => DesignTokens.info,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignTokens.radiusXl,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incident.category,
                            style: DesignTokens.title.copyWith(
                              fontSize: 16,
                              color: DesignTokens.ink,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.sm),
                          Text(
                            incident.narrative,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: DesignTokens.body.copyWith(
                              fontSize: 13,
                              color: DesignTokens.muted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.lg),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        incident.severityLabel,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: DesignTokens.canvas,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        incident.statusLabel,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.success,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
