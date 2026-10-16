import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/sos_repository.dart';
import '../../data/models/sos_alert.dart';
import '../view_models/sos_view_model.dart';

/// SOS page - emergency alert creation with clear disclosure.
class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  final _detailsController = TextEditingController();
  bool _shareLocation = false;
  bool _acknowledgeRisks = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitAlert(SosViewModel viewModel) async {
    if (!_acknowledgeRisks) {
      showAppSnackbar(context, 'Please acknowledge the emergency disclaimer.', isError: true);
      return;
    }
    if (_detailsController.text.isEmpty) {
      showAppSnackbar(context, 'Please describe the emergency.', isError: true);
      return;
    }

    final alert = SosAlert(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      reporterUid: 'current_user',
      clientRequestId: 'req_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      details: _detailsController.text.trim(),
      locationShared: _shareLocation,
      lifecycleStatus: SosLifecycleStatus.submitted,
      deliveryState: SosDeliveryState.pending,
    );

    final success = await viewModel.submitAlert(alert);
    if (mounted) {
      if (success) {
        showAppSnackbar(context, 'Alert submitted. Delivery state: pending.');
        _detailsController.clear();
        setState(() {
          _shareLocation = false;
          _acknowledgeRisks = false;
        });
      } else {
        showAppSnackbar(context, viewModel.error?.message ?? 'Failed to submit alert.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SosViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Emergency SOS'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCECE9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8DCD9)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_outlined, color: Color(0xFFB63D34)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Emergency Disclaimer',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFB63D34),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'This SOS alert does NOT contact public emergency services (911 or local equivalents). '
                          'It routes to designated handlers only when responder coverage and procedures are approved. '
                          'Delivery is not guaranteed. For immediate danger, call emergency services directly.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Color(0xFF68766D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Describe the emergency',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF43564A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInputField(
                    controller: _detailsController,
                    label: 'Details',
                    hint: 'What is happening? Where? Who needs help?',
                    maxLines: 4,
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Checkbox(
                      value: _shareLocation,
                      onChanged: (v) => setState(() => _shareLocation = v ?? false),
                    ),
                    title: const Text('Share location'),
                    subtitle: const Text('Optional - helps responders find you'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Checkbox(
                      value: _acknowledgeRisks,
                      onChanged: (v) => setState(() => _acknowledgeRisks = v ?? false),
                    ),
                    title: const Text('I understand this alert does not contact emergency services'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Submit SOS Alert',
                      onPressed: () => _submitAlert(viewModel),
                      isLoading: viewModel.isSubmitting,
                      isDestructive: true,
                      icon: Icons.warning_amber_rounded,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.myAlerts.isNotEmpty) ...[
                    const Divider(height: 24),
                    const Text(
                      'Your recent alerts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF43564A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...viewModel.myAlerts.take(3).map((a) => _AlertCard(alert: a)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final SosAlert alert;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          alert.lifecycleLabel,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Delivery: ${alert.deliveryLabel} · ${alert.createdAt.month}/${alert.createdAt.day}',
          style: const TextStyle(fontSize: 12, color: Color(0xFF68766D)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE5EFE7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            alert.deliveryLabel,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF196142),
            ),
          ),
        ),
      ),
    );
  }
}
