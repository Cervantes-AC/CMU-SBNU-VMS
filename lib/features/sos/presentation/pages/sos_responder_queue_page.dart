import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/sos_alert.dart';
import '../view_models/sos_view_model.dart';

/// Responder queue showing all SOS alerts for designated handlers.
///
/// Delivery state (pending/sent/failed/unknown) is separate from lifecycle
/// status. Provider acceptance does not mean a responder saw the message.
/// This page is part of the clearly-labeled SOS preview — it does not
/// contact public emergency services.
class SosResponderQueuePage extends StatefulWidget {
  const SosResponderQueuePage({super.key});

  @override
  State<SosResponderQueuePage> createState() => _SosResponderQueuePageState();
}

class _SosResponderQueuePageState extends State<SosResponderQueuePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SosViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('SOS Responder Queue')),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.alerts.isEmpty
                ? _buildEmptyBody()
                : _buildListBody(viewModel.alerts, viewModel),
          ),
        );
      },
    );
  }

  Widget _buildEmptyBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.queue, size: 64, color: Color(0xFFADB5AF)),
          SizedBox(height: 16),
          Text(
            'No SOS alerts in queue.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF59685E),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Alerts submitted by volunteers appear here for '
            'designated handlers to review.',
            style: TextStyle(fontSize: 13, color: Color(0xFF68766D)),
          ),
        ],
      ),
    );
  }

  Widget _buildListBody(List<SosAlert> alerts, SosViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _AlertCard(alert: alert, viewModel: viewModel);
      },
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.viewModel});

  final SosAlert alert;
  final SosViewModel viewModel;

  Color _lifecycleColor(SosLifecycleStatus status) {
    switch (status) {
      case SosLifecycleStatus.submitted:
        return const Color(0xFFD5A52F);
      case SosLifecycleStatus.acknowledged:
        return const Color(0xFF4C735E);
      case SosLifecycleStatus.actionInProgress:
        return const Color(0xFFD58A2F);
      case SosLifecycleStatus.resolved:
        return const Color(0xFF196142);
      case SosLifecycleStatus.cancelled:
      case SosLifecycleStatus.falseAlarm:
      case SosLifecycleStatus.closed:
        return const Color(0xFF748078);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    alert.lifecycleLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF17231C),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _lifecycleColor(
                      alert.lifecycleStatus,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    alert.deliveryLabel,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: _lifecycleColor(alert.lifecycleStatus),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              alert.details ?? 'No details provided.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF68766D),
                height: 1.4,
              ),
            ),
            if (alert.locationShared &&
                alert.latitude != null &&
                alert.longitude != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Color(0xFF196142),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Location shared: ${alert.latitude!.toStringAsFixed(6)}, ${alert.longitude!.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF196142),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Mark Acknowledged',
                    onPressed: () => viewModel.updateAlertStatus(
                      alert.id,
                      lifecycleStatus: SosLifecycleStatus.acknowledged,
                      actorUid: 'responder_current',
                    ),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: 'Mark Resolved',
                    onPressed: () => viewModel.updateAlertStatus(
                      alert.id,
                      lifecycleStatus: SosLifecycleStatus.resolved,
                      actorUid: 'responder_current',
                    ),
                    isOutlined: true,
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
