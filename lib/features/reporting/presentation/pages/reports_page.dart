import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/reports_repository.dart';
import '../../data/models/report_record.dart';
import '../view_models/reports_view_model.dart';

/// Reports page - scoped analytics and export.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reports'),
            actions: [
              IconButton(
                tooltip: 'Export CSV',
                onPressed: () async {
                  await viewModel.generateExport(type: 'summary', filters: {});
                  if (mounted) {
                    if (viewModel.csvContent != null) {
                      showAppSnackbar(
                        context,
                        'Report exported (CSV preview copied).',
                      );
                    } else if (viewModel.error != null) {
                      showAppSnackbar(
                        context,
                        viewModel.error!.message,
                        isError: true,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.download_outlined),
              ),
            ],
          ),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.records.isEmpty
                ? const AppEmptyState(
                    icon: Icons.insights_outlined,
                    title: 'No report data.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.records.length,
                    itemBuilder: (context, index) {
                      final r = viewModel.records[index];
                      return _MetricRow(record: r);
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.record});

  final ReportRecord record;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          record.metric,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF17231C),
          ),
        ),
        trailing: Text(
          record.displayValue,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF134F35),
          ),
        ),
        subtitle: Text(
          record.unit ?? '',
          style: const TextStyle(fontSize: 12, color: Color(0xFF748078)),
        ),
      ),
    );
  }
}
