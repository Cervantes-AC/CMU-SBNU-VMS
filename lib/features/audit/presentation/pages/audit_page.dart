import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/audit_repository.dart';
import '../../data/models/audit_event.dart';
import '../view_models/audit_view_model.dart';

/// Audit page — premium, fully functional.
class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          Consumer<AuditViewModel>(
            builder: (context, viewModel, _) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    AppStateWrapper(
                      status: viewModel.status,
                      onRetry: viewModel.init,
                      errorMessage: viewModel.error?.message,
                      child: viewModel.events.isEmpty
                          ? const PremiumEmptyState(
                              icon: Icons.history_outlined,
                              title: 'No audit events.',
                              subtitle:
                                  'Audit events appear here for sensitive actions.',
                            )
                          : Padding(
                              padding: const EdgeInsets.all(DesignTokens.lg),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.events.length,
                                itemBuilder: (context, index) {
                                  final e = viewModel.events[index];
                                  return _AuditRow(event: e);
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
              color: DesignTokens.info.withValues(alpha: 0.12),
              borderRadius: DesignTokens.radiusLg,
              boxShadow: DesignTokens.shadowSoft(
                color: DesignTokens.info.withValues(alpha: 0.25),
                blur: 16,
                offset: const Offset(0, 4),
              ),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: DesignTokens.info,
              size: 26,
            ),
          ),
          const SizedBox(height: DesignTokens.md),
          Text(
            'Audit Log',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Restricted review of append-only audit events.',
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

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.event});

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final isSuccess = event.outcome == 'success';
    final color = isSuccess ? DesignTokens.success : DesignTokens.error;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
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
              isSuccess
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: color,
              size: 22,
            ),
          ),
          title: Text(
            event.action,
            style: DesignTokens.title.copyWith(
              fontSize: 15,
              color: DesignTokens.ink,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${event.recordType} · ${event.recordId}',
                style: DesignTokens.bodySmall.copyWith(
                  color: DesignTokens.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: DesignTokens.xs / 2),
              Text(
                '${event.occurredAt.month}/${event.occurredAt.day}/${event.occurredAt.year}',
                style: DesignTokens.caption.copyWith(
                  color: DesignTokens.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          trailing: Text(
            event.outcome.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
