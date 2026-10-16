import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/attendance_record.dart';
import '../view_models/attendance_view_model.dart';
import '../widgets/attendance_qr_scanner.dart';

/// Attendance page - record and correct attendance.
///
/// Rendered as content inside the workspace shell; no AppBar here.
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
        return AppStateWrapper(
          status: viewModel.status,
          onRetry: viewModel.init,
          errorMessage: viewModel.error?.message,
          child: viewModel.records.isEmpty
              ? const AppEmptyState(
                  icon: Icons.fact_check_outlined,
                  title: 'No attendance records.',
                  subtitle: 'Recorded attendance will appear here.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    Expanded(
                      child: ResponsiveListView(
                        itemCount: viewModel.records.length,
                        itemBuilder: (context, index) {
                          final record = viewModel.records[index];
                          return _RecordCard(record: record);
                        },
                      ),
                    ),
                  ],
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
      builder: (context) => ActionDialog(
        title: 'Record Attendance',
        message: '',
        actions: [
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
            initialValue: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 10,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'present', child: Text('Present')),
              DropdownMenuItem(value: 'absent', child: Text('Absent')),
              DropdownMenuItem(value: 'excused', child: Text('Excused')),
            ],
            onChanged: (v) => selectedStatus = v ?? 'present',
          ),
        ],
        onConfirm: () {
          if (activityController.text.isEmpty ||
              uidController.text.isEmpty) {
            return;
          }
          Navigator.of(context).pop();
          viewModel.recordAttendance(
            AttendanceRecord(
              activityId: activityController.text.trim(),
              uid: uidController.text.trim(),
              status: selectedStatus == 'present'
                  ? AttendanceStatus.present
                  : selectedStatus == 'absent'
                  ? AttendanceStatus.absent
                  : AttendanceStatus.excused,
              recordedBy: 'current_user',
              recordedAt: DateTime.now(),
            ),
          );
        },
      ),
    );
  }

  void _showQrConfirmDialog(
    BuildContext context,
    AttendanceViewModel viewModel,
    String qrPayload,
  ) {
    final activityController = TextEditingController();
    final uidController = TextEditingController();
    String selectedStatus = 'present';
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        title: 'Confirm QR Attendance',
        message:
            'A trusted server must validate this token before attendance is accepted. Below is the local confirmation entry only.',
        actions: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EFE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Scanned token: $qrPayload',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontFamily: 'monospace',
                color: const Color(0xFF134F35),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
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
            initialValue: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 10,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'present', child: Text('Present')),
              DropdownMenuItem(value: 'absent', child: Text('Absent')),
              DropdownMenuItem(value: 'excused', child: Text('Excused')),
            ],
            onChanged: (v) => selectedStatus = v ?? 'present',
          ),
        ],
        onConfirm: () {
          if (activityController.text.isEmpty ||
              uidController.text.isEmpty) {
            return;
          }
          Navigator.of(context).pop();
          viewModel.recordAttendance(
            AttendanceRecord(
              activityId: activityController.text.trim(),
              uid: uidController.text.trim(),
              status: selectedStatus == 'present'
                  ? AttendanceStatus.present
                  : selectedStatus == 'absent'
                  ? AttendanceStatus.absent
                  : AttendanceStatus.excused,
              recordedBy: 'current_user',
              recordedAt: DateTime.now(),
              source: 'qr',
              qrPayload: qrPayload,
            ),
          );
        },
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: const Color(0xFFDFE5DF)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F1E9),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Color(0xFF196142),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.uid,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.activityId} · ${record.statusLabel}',
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF829B8B),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              record.source.toUpperCase(),
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF748078),
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple action dialog for recording attendance.
class ActionDialog extends StatelessWidget {
  const ActionDialog({
    super.key,
    required this.title,
    this.message,
    required this.actions,
    required this.onConfirm,
  });

  final String title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppTheme.ink,
          height: 1.2,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null && message!.isNotEmpty) ...[
            Text(
              message!,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7C877F),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...actions,
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Record',
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
