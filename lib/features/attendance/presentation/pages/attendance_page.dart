import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/attendance_repository.dart';
import '../../data/models/attendance_record.dart';
import '../view_models/attendance_view_model.dart';

/// Attendance page - record and correct attendance.
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Attendance'),
          ),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.records.isEmpty
                ? const AppEmptyState(
                    icon: Icons.fact_check_outlined,
                    title: 'No attendance records.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.records.length,
                    itemBuilder: (context, index) {
                      final record = viewModel.records[index];
                      return _RecordCard(record: record);
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showRecordDialog(context, viewModel),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showRecordDialog(BuildContext context, AttendanceViewModel viewModel) {
    final activityController = TextEditingController();
    final uidController = TextEditingController();
    String selectedStatus = 'present';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              controller: activityController,
              label: 'Activity ID',
              hint: 'e.g. act_001',
              icon: Icons.event_outlined,
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: uidController,
              label: 'Volunteer UID',
              hint: 'e.g. vol_001',
              icon: Icons.person_outlined,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'present', child: Text('Present')),
                DropdownMenuItem(value: 'absent', child: Text('Absent')),
                DropdownMenuItem(value: 'excused', child: Text('Excused')),
              ],
              onChanged: (v) => selectedStatus = v ?? 'present',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Record',
            onPressed: () {
              if (activityController.text.isEmpty || uidController.text.isEmpty) return;
              Navigator.of(context).pop();
              viewModel.recordAttendance(AttendanceRecord(
                activityId: activityController.text.trim(),
                uid: uidController.text.trim(),
                status: selectedStatus == 'present'
                    ? AttendanceStatus.present
                    : selectedStatus == 'absent'
                        ? AttendanceStatus.absent
                        : AttendanceStatus.excused,
                recordedBy: 'current_user',
                recordedAt: DateTime.now(),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE5EFE7),
          child: const Icon(Icons.check_circle, color: Color(0xFF134F35)),
        ),
        title: Text(
          record.uid,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${record.activityId} · ${record.statusLabel}',
          style: const TextStyle(fontSize: 13, color: Color(0xFF68766D)),
        ),
        trailing: Text(
          record.source.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF748078),
          ),
        ),
      ),
    );
  }
}
