import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/hotline_entry.dart';
import '../view_models/hotlines_view_model.dart';

/// Hotlines page — premium, fully functional.
class HotlinesPage extends StatefulWidget {
  const HotlinesPage({super.key});

  @override
  State<HotlinesPage> createState() => _HotlinesPageState();
}

class _HotlinesPageState extends State<HotlinesPage> {
  Future<void> _callNumber(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else if (mounted) {
      showPremiumSnackbar(
        context,
        message: 'Cannot initiate call on this device.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          Consumer<HotlinesViewModel>(
            builder: (context, viewModel, _) {
              final verified = viewModel.verified;
              final unverified = viewModel.hotlines
                  .where((h) => !h.isVerified)
                  .toList();

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    if (verified.isNotEmpty) ...[
                      PremiumSectionHeading(
                        title: 'Verified Emergency Contacts',
                        subtitle: '${verified.length} verified number(s)',
                        accentColor: DesignTokens.success,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      ...verified.map(
                        (h) => Container(
                          margin: const EdgeInsets.only(
                            bottom: DesignTokens.md,
                          ),
                          child: _HotlineCard(
                            entry: h,
                            onCall: h.isCallEnabled
                                ? () => _callNumber(h.phoneE164)
                                : null,
                          ),
                        ),
                      ),
                    ],
                    if (unverified.isNotEmpty) ...[
                      const SizedBox(height: DesignTokens.lg),
                      PremiumSectionHeading(
                        title: 'Unverified / Expired Contacts',
                        subtitle: '${unverified.length} number(s) not callable',
                        accentColor: DesignTokens.muted,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      ...unverified.map(
                        (h) => Container(
                          margin: const EdgeInsets.only(
                            bottom: DesignTokens.md,
                          ),
                          child: _HotlineCard(entry: h, onCall: null),
                        ),
                      ),
                    ],
                    const SizedBox(height: DesignTokens.xxl),
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
              Icons.phone_rounded,
              color: DesignTokens.error,
              size: 26,
            ),
          ),
          const SizedBox(height: DesignTokens.md),
          Text(
            'Emergency Hotlines',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Verified emergency contacts for the CMU community.',
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

class _HotlineCard extends StatelessWidget {
  const _HotlineCard({required this.entry, required this.onCall});

  final HotlineEntry entry;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final isVerified = entry.isVerified;
    final color = entry.verificationColor;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        child: InkWell(
          onTap: onCall,
          borderRadius: DesignTokens.radiusXl,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isVerified
                        ? DesignTokens.success.withValues(alpha: 0.12)
                        : DesignTokens.muted.withValues(alpha: 0.12),
                    borderRadius: DesignTokens.radiusXl,
                    boxShadow: DesignTokens.shadowSoft(
                      color:
                          (isVerified
                                  ? DesignTokens.success
                                  : DesignTokens.muted)
                              .withValues(alpha: 0.2),
                      blur: 12,
                      offset: const Offset(0, 4),
                    ),
                  ),
                  child: Icon(
                    isVerified
                        ? Icons.phone_rounded
                        : Icons.phone_disabled_rounded,
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: DesignTokens.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.label,
                        style: DesignTokens.title.copyWith(
                          fontSize: 16,
                          color: DesignTokens.ink,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.xs / 2),
                      Text(
                        entry.phoneE164,
                        style: DesignTokens.body.copyWith(
                          fontSize: 14,
                          color: DesignTokens.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.sm),
                      Text(
                        '${entry.coverage} · ${entry.hours}',
                        style: DesignTokens.caption.copyWith(
                          color: DesignTokens.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.verificationLabel,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.md),
                    if (onCall != null)
                      PremiumButton(
                        label: 'Call',
                        onPressed: onCall,
                        variant: ButtonVariant.outline,
                        isFullWidth: false,
                        icon: Icons.phone_rounded,
                      )
                    else
                      const Text(
                        'Not callable',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.muted,
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
