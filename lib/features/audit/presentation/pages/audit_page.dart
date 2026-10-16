import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/audit_event.dart';
import '../view_models/audit_view_model.dart';

/// Audit page - restricted review of append-only audit events.
class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuditViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Audit Log')),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.events.isEmpty
                ? const AppEmptyState(
                    icon: Icons.history_outlined,
                    title: 'No audit events.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.events.length,
                    itemBuilder: (context, index) {
                      final e = viewModel.events[index];
                      return _AuditRow(event: e);
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.event});

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final isSuccess = event.outcome == 'success';
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSuccess
              ? const Color(0xFFE5EFE7)
              : const Color(0xFFF5E5E5),
          child: Icon(
            isSuccess ? Icons.check_circle : Icons.error_outline,
            color: isSuccess
                ? const Color(0xFF196142)
                : const Color(0xFFB63D34),
          ),
        ),
        title: Text(
          event.action,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF17231C),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${event.recordType} · ${event.recordId}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF68766D)),
            ),
            const SizedBox(height: 4),
            Text(
              '${event.occurredAt.month}/${event.occurredAt.day}/${event.occurredAt.year}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF748078)),
            ),
          ],
        ),
        trailing: Text(
          event.outcome.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isSuccess
                ? const Color(0xFF196142)
                : const Color(0xFFB63D34),
          ),
        ),
      ),
    );
  }
}
