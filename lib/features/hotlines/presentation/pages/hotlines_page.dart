import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/hotline_entry.dart';
import '../view_models/hotlines_view_model.dart';

/// Hotlines page - verified emergency contacts with call handoff.
class HotlinesPage extends StatefulWidget {
  const HotlinesPage({super.key});

  @override
  State<HotlinesPage> createState() => _HotlinesPageState();
}

class _HotlinesPageState extends State<HotlinesPage> {
  Future<void> _callNumber(String phone) async {
    final url = 'tel:$phone';
    final canCall = await canLaunchUrl(Uri.parse(url));
    if (!mounted) return;

    if (canCall) {
      await launchUrl(Uri.parse(url));
    } else {
      showAppSnackbar(
        context,
        'Cannot initiate call on this device.',
        isError: true,
      );
    }
  }

  Future<void> _verifyHotline(
    BuildContext context,
    HotlinesViewModel viewModel,
    HotlineEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Hotline'),
        content: Text(
          'Mark "${entry.label}" as verified and active for one-tap calling? '
          'Only institution-approved, current entries should be verified.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Verify',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await viewModel.verifyHotline(entry.id, 'admin_current');
      if (!context.mounted) return;
      showAppSnackbar(context, 'Hotline verified.');
    }
  }

  Future<void> _expireHotline(
    BuildContext context,
    HotlinesViewModel viewModel,
    HotlineEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expire Hotline'),
        content: Text(
          'Mark "${entry.label}" as expired? Expired entries are not callable.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Expire',
            onPressed: () => Navigator.of(context).pop(true),
            isDestructive: true,
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await viewModel.expireHotline(entry.id);
      if (!context.mounted) return;
      showAppSnackbar(context, 'Hotline expired.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HotlinesViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Emergency Hotlines')),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.hotlines.isEmpty
                ? const AppEmptyState(
                    icon: Icons.phone_outlined,
                    title: 'No hotlines available.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.hotlines.length,
                    itemBuilder: (context, index) {
                      final h = viewModel.hotlines[index];
                      return _HotlineCard(
                        entry: h,
                        onCall: h.isCallEnabled
                            ? () => _callNumber(h.phoneE164)
                            : null,
                        onVerify: h.verificationState != 'verified'
                            ? () => _verifyHotline(context, viewModel, h)
                            : null,
                        onExpire: h.isCallEnabled
                            ? () => _expireHotline(context, viewModel, h)
                            : null,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _HotlineCard extends StatelessWidget {
  const _HotlineCard({
    required this.entry,
    this.onCall,
    this.onVerify,
    this.onExpire,
  });

  final HotlineEntry entry;
  final VoidCallback? onCall;
  final VoidCallback? onVerify;
  final VoidCallback? onExpire;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: entry.isVerified
              ? const Color(0xFFE5EFE7)
              : const Color(0xFFF5E5E5),
          child: Icon(
            entry.isVerified ? Icons.phone : Icons.phone_disabled,
            color: entry.verificationColor,
          ),
        ),
        title: Text(
          entry.label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17231C),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.phoneE164,
              style: const TextStyle(fontSize: 13, color: Color(0xFF68766D)),
            ),
            const SizedBox(height: 4),
            Text(
              '${entry.coverage} · ${entry.hours}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF748078)),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: entry.verificationColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                entry.verificationLabel,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: entry.verificationColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (onCall != null)
              AppButton(
                label: 'Call',
                onPressed: onCall,
                isOutlined: true,
                icon: Icons.phone,
              )
            else
              const Text(
                'Not callable',
                style: TextStyle(fontSize: 10, color: Color(0xFF748078)),
              ),
            if (onVerify != null) ...[
              const SizedBox(height: 6),
              AppButton(
                label: 'Verify',
                onPressed: onVerify,
                isOutlined: true,
                icon: Icons.verified,
              ),
            ],
            if (onExpire != null) ...[
              const SizedBox(height: 6),
              AppButton(
                label: 'Expire',
                onPressed: onExpire,
                isOutlined: true,
                icon: Icons.event_busy,
                isDestructive: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
