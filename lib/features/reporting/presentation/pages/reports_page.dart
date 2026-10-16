import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/report_record.dart';
import '../view_models/reports_view_model.dart';

/// Reports page — premium, fully functional.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          SliverToBoxAdapter(child: _ExportBar()),
          Consumer<ReportsViewModel>(
            builder: (context, viewModel, _) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    AppStateWrapper(
                      status: viewModel.status,
                      onRetry: viewModel.init,
                      errorMessage: viewModel.error?.message,
                      child: viewModel.records.isEmpty
                          ? const PremiumEmptyState(
                              icon: Icons.analytics_outlined,
                              title: 'No report data.',
                              subtitle:
                                  'Reports will appear here once data is available.',
                            )
                          : Padding(
                              padding: const EdgeInsets.all(DesignTokens.lg),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.records.length,
                                itemBuilder: (context, index) {
                                  final r = viewModel.records[index];
                                  return _MetricCard(record: r);
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
          Text(
            'Reports',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Operational analytics and scoped export.',
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

class _ExportBar extends StatelessWidget {
  const _ExportBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: PremiumButton(
              label: 'Export CSV Report',
              onPressed: () {
                final vm = context.read<ReportsViewModel>();
                _exportImpl(context, vm);
              },
              variant: ButtonVariant.primary,
              icon: Icons.download_rounded,
            ),
          ),
        ],
      ),
    );
  }

  void _exportImpl(BuildContext context, ReportsViewModel viewModel) async {
    await viewModel.generateExport(type: 'summary', filters: {});
    if (context.mounted) {
      if (viewModel.csvContent != null) {
        showPremiumSnackbar(context, message: 'Report exported successfully.');
      } else if (viewModel.error != null) {
        showPremiumSnackbar(
          context,
          message: viewModel.error!.message,
          isError: true,
        );
      }
    }
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.record});

  final ReportRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 1,
        borderRadius: DesignTokens.radiusXl,
        child: ListTile(
          contentPadding: const EdgeInsets.all(DesignTokens.lg),
          title: Text(
            record.metric,
            style: DesignTokens.title.copyWith(
              fontSize: 15,
              color: DesignTokens.ink,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                record.displayValue,
                style: DesignTokens.displayMedium.copyWith(
                  fontSize: 20,
                  color: DesignTokens.forest,
                ),
              ),
              if (record.unit != null) ...[
                const SizedBox(height: DesignTokens.xs / 2),
                Text(
                  record.unit!,
                  style: DesignTokens.caption.copyWith(
                    color: DesignTokens.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: DesignTokens.sm),
            child: Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: DesignTokens.canvas,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
