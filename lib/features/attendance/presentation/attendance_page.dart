import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models/attendance_record.dart';
import 'view_models/attendance_view_model.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  Future<void> _correctStatus(
    BuildContext context,
    AttendanceViewModel viewModel,
    PreviewAttendanceRecord record,
    AttendanceStatus status,
  ) async {
    final reason = TextEditingController();
    final acceptedReason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Record attendance correction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${record.displayName}: ${_statusLabel(record.status)} → ${_statusLabel(status)}',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reason,
              autofocus: true,
              maxLength: 160,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Reason for this preview correction',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const Text(
              'This entry stays in memory for this session. The required reason here is a workflow demonstration, not an approved production policy.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Color(0xFF748078),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = reason.text.trim();
              if (value.isNotEmpty) Navigator.pop(dialogContext, value);
            },
            child: const Text('Save local correction'),
          ),
        ],
      ),
    );
    reason.dispose();
    if (acceptedReason != null && context.mounted) {
      viewModel.setStatus(record.displayName, status, acceptedReason);
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<AttendanceViewModel>(
    builder: (context, viewModel, _) => ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Participation records',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: const Color(0xFFAA7C10),
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Attendance',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        const Text(
          'Review the sample roster or mark a local preview record. No attendance is written to a service.',
          style: TextStyle(color: Color(0xFF748078), height: 1.4),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF0D7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'QR check-in is unavailable until a trusted server can issue and validate short-lived sessions.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: Color(0xFF6E581F),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          key: ValueKey(viewModel.activityId),
          initialValue: viewModel.activityId,
          decoration: const InputDecoration(
            labelText: 'Sample activity',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: 'sample-preparedness',
              child: Text('Preparedness workshop'),
            ),
            DropdownMenuItem(
              value: 'sample-river-cleanup',
              child: Text('River clean-up'),
            ),
          ],
          onChanged: (value) {
            if (value != null) viewModel.selectActivity(value);
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                'Sample roster',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              '${viewModel.presentCount}/${viewModel.roster.length} present',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF47745A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final record in viewModel.roster)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                record.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${_statusLabel(record.status)} · local preview'),
              trailing: DropdownButton<AttendanceStatus>(
                value: record.status,
                underline: const SizedBox.shrink(),
                onChanged: (status) {
                  if (status != null) {
                    _correctStatus(context, viewModel, record, status);
                  }
                },
                items: [
                  for (final status in AttendanceStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(_statusLabel(status)),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 18),
        Text(
          'Correction history',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (viewModel.corrections.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'No local corrections in this session.',
                style: TextStyle(color: Color(0xFF748078)),
              ),
            ),
          )
        else
          for (final correction in viewModel.corrections)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.history, color: Color(0xFF47745A)),
                title: Text(
                  '${correction.participantName}: ${_statusLabel(correction.previousStatus)} → ${_statusLabel(correction.newStatus)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${correction.reason}\n${correction.actorLabel} · ${DateFormat.MMMd().add_jm().format(correction.recordedAt)} · local preview',
                ),
              ),
            ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(
                Icons.qr_code_2,
                size: 38,
                color: Color(0xFF47745A),
              ),
              title: const Text('QR session not connected'),
              content: const Text(
                'A valid QR session must be issued and checked by a trusted backend, including expiry, activity eligibility, and replay protection. This preview cannot start one.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.qr_code_2),
          label: const Text('Review QR check-in requirements'),
        ),
      ],
    ),
  );
}

String _statusLabel(AttendanceStatus status) => switch (status) {
  AttendanceStatus.present => 'Present',
  AttendanceStatus.absent => 'Absent',
  AttendanceStatus.excused => 'Excused',
};
