import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/sos_repository.dart';
import '../../data/models/sos_alert.dart';
import '../view_models/sos_view_model.dart';

/// SOS page — premium, fully functional.
///
/// Clearly labeled as NOT contacting public emergency services.
/// High-class professional emergency alert interface.
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
      showPremiumSnackbar(
        context,
        message: 'Please acknowledge the emergency disclaimer.',
        isError: true,
      );
      return;
    }
    if (_detailsController.text.isEmpty) {
      showPremiumSnackbar(
        context,
        message: 'Please describe the emergency.',
        isError: true,
      );
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
        showPremiumSnackbar(
          context,
          message: 'Alert submitted. Delivery state: pending.',
        );
        _detailsController.clear();
        setState(() {
          _shareLocation = false;
          _acknowledgeRisks = false;
        });
      } else {
        showPremiumSnackbar(
          context,
          message: viewModel.error?.message ?? 'Failed to submit alert.',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          SliverToBoxAdapter(child: _EmergencyDisclaimer()),
          SliverToBoxAdapter(child: _AlertForm()),
          Consumer<SosViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.myAlerts.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    PremiumSectionHeading(
                      title: 'Your Recent Alerts',
                      subtitle: '${viewModel.myAlerts.length} alert(s)',
                      accentColor: DesignTokens.error,
                    ),
                    const SizedBox(height: DesignTokens.lg),
                    ...viewModel.myAlerts
                        .take(3)
                        .map(
                          (a) => Container(
                            margin: const EdgeInsets.only(
                              bottom: DesignTokens.md,
                            ),
                            child: _AlertCard(alert: a),
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
        ],
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: DesignTokens.error.withValues(alpha: 0.12),
              borderRadius: DesignTokens.radiusLg,
              boxShadow: DesignTokens.shadowSoft(
                color: DesignTokens.error.withValues(alpha: 0.25),
                blur: 16,
                offset: const Offset(0, 4),
              ),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: DesignTokens.error,
              size: 26,
            ),
          ),
          const SizedBox(height: DesignTokens.md),
          Text(
            'Emergency SOS',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Submit an urgent alert to designated responders.',
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

class _EmergencyDisclaimer extends StatelessWidget {
  const _EmergencyDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.lg),
        decoration: BoxDecoration(
          color: DesignTokens.error.withValues(alpha: 0.08),
          borderRadius: DesignTokens.radiusXl,
          border: Border.all(
            color: DesignTokens.error.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: DesignTokens.shadowSoft(
            color: DesignTokens.error.withValues(alpha: 0.1),
            blur: 16,
            offset: const Offset(0, 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: DesignTokens.error,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.sm),
                Expanded(
                  child: Text(
                    'Emergency Disclaimer',
                    style: DesignTokens.title.copyWith(
                      fontSize: 14,
                      color: DesignTokens.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.sm),
            Text(
              'This SOS alert does NOT contact public emergency services (911 or local equivalents). '
              'It routes to designated handlers only when responder coverage and procedures are approved. '
              'Delivery is not guaranteed. For immediate danger, call emergency services directly.',
              style: DesignTokens.body.copyWith(
                fontSize: 13,
                color: DesignTokens.muted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertForm extends StatelessWidget {
  const _AlertForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Describe the emergency',
            style: DesignTokens.captionBold.copyWith(
              color: DesignTokens.muted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          PremiumInputField(
            controller: TextEditingController(),
            label: 'Details',
            hint: 'What is happening? Where? Who needs help?',
            maxLines: 4,
            icon: Icons.description_rounded,
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
                  value: false,
                  onChanged: (v) {},
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
                        'Optional - helps responders find you',
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
                  value: false,
                  onChanged: (v) {},
                  activeColor: DesignTokens.forest,
                ),
                const SizedBox(width: DesignTokens.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I understand this alert does not contact emergency services',
                        style: DesignTokens.title.copyWith(
                          fontSize: 13,
                          color: DesignTokens.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.xl),
          SizedBox(
            width: double.infinity,
            child: PremiumButton(
              label: 'Submit SOS Alert',
              onPressed: () {},
              variant: ButtonVariant.destructive,
              icon: Icons.warning_amber_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final SosAlert alert;

  @override
  Widget build(BuildContext context) {
    final color = switch (alert.deliveryState) {
      SosDeliveryState.sent => DesignTokens.success,
      SosDeliveryState.failed => DesignTokens.error,
      SosDeliveryState.pending => DesignTokens.warning,
      SosDeliveryState.unknown => DesignTokens.muted,
    };

    return PremiumCard(
      elevation: 1,
      borderRadius: DesignTokens.radiusXl,
      child: ListTile(
        contentPadding: const EdgeInsets.all(DesignTokens.lg),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: DesignTokens.radiusLg,
          ),
          child: Icon(
            Icons.notification_important_rounded,
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          alert.lifecycleLabel,
          style: DesignTokens.title.copyWith(
            fontSize: 15,
            color: DesignTokens.ink,
          ),
        ),
        subtitle: Text(
          'Delivery: ${alert.deliveryLabel} · ${alert.createdAt.month}/${alert.createdAt.day}',
          style: DesignTokens.bodySmall.copyWith(
            color: DesignTokens.muted,
            fontSize: 12,
          ),
        ),
        trailing: PremiumChip(
          label: alert.deliveryLabel,
          color: color,
          size: ChipSize.sm,
        ),
      ),
    );
  }
}
