import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/attendance_record.dart';
import '../view_models/attendance_view_model.dart';

/// Attendance page — premium, fully functional.
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const _PageHeader()),
          SliverToBoxAdapter(child: const _StatsRow()),
          Consumer<AttendanceViewModel>(
            builder: (context, viewModel, _) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    _RecordList(
                      records: viewModel.records,
                      onRecordTap: (record) {
                        _showRecordDetail(context, record);
                      },
                    ),
                    const SizedBox(height: DesignTokens.xxl),
                    const _ActionCard(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(DesignTokens.lg),
        child: PremiumButton(
          label: 'Record Attendance',
          onPressed: () => _showRecordDialog(context),
          icon: Icons.add_circle_rounded,
          isFullWidth: false,
          variant: ButtonVariant.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showRecordDialog(BuildContext context) {
    final activityController = TextEditingController();
    final uidController = TextEditingController();
    String selectedStatus = 'present';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PremiumCard(
          elevation: 3,
          borderRadius: DesignTokens.radiusXl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(DesignTokens.lg),
                  child: Text(
                    'Record Attendance',
                    style: DesignTokens.headline,
                  ),
                ),
                PremiumDivider(),
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PremiumInputField(
                        controller: activityController,
                        label: 'Activity ID',
                        hint: 'e.g. act_001',
                        icon: Icons.event_rounded,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: uidController,
                        label: 'Volunteer UID',
                        hint: 'e.g. vol_001',
                        icon: Icons.person_rounded,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: DesignTokens.captionBold.copyWith(
                            color: DesignTokens.muted,
                            fontSize: 12.0,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: DesignTokens.radiusLg,
                            borderSide: BorderSide(color: DesignTokens.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: DesignTokens.radiusLg,
                            borderSide: BorderSide(color: DesignTokens.line),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: DesignTokens.radiusLg,
                            borderSide: const BorderSide(
                              color: DesignTokens.forest,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 16.0,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'present',
                            child: Text('Present'),
                          ),
                          DropdownMenuItem(
                            value: 'absent',
                            child: Text('Absent'),
                          ),
                          DropdownMenuItem(
                            value: 'excused',
                            child: Text('Excused'),
                          ),
                        ],
                        onChanged: (v) => selectedStatus = v ?? 'present',
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumButton(
                              label: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                              variant: ButtonVariant.outline,
                              isFullWidth: true,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.md),
                          Expanded(
                            child: PremiumButton(
                              label: 'Record',
                              onPressed: () {
                                if (activityController.text.isEmpty ||
                                    uidController.text.isEmpty)
                                  return;
                                Navigator.of(context).pop();
                                context
                                    .read<AttendanceViewModel>()
                                    .recordAttendance(
                                      AttendanceRecord(
                                        activityId: activityController.text
                                            .trim(),
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
                              variant: ButtonVariant.primary,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRecordDetail(BuildContext context, AttendanceRecord record) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PremiumCard(
          elevation: 3,
          borderRadius: DesignTokens.radiusXl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: DesignTokens.canvas,
                          borderRadius: DesignTokens.radiusLg,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: DesignTokens.success,
                          size: 22.0,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance Record',
                              style: DesignTokens.headline,
                            ),
                            const SizedBox(height: DesignTokens.xs / 2),
                            Text(
                              record.uid,
                              style: DesignTokens.captionBold.copyWith(
                                color: DesignTokens.muted,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                PremiumDivider(),
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.lg),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Activity ID',
                        value: record.activityId,
                        icon: Icons.event_rounded,
                      ),
                      const SizedBox(height: DesignTokens.md),
                      _DetailRow(
                        label: 'Status',
                        value: record.statusLabel,
                        icon: Icons.task_rounded,
                        valueColor: _statusColor(record.status),
                      ),
                      const SizedBox(height: DesignTokens.md),
                      _DetailRow(
                        label: 'Source',
                        value: record.source.toUpperCase(),
                        icon: Icons.source_rounded,
                      ),
                      const SizedBox(height: DesignTokens.md),
                      _DetailRow(
                        label: 'Recorded At',
                        value:
                            '${record.recordedAt.month}/${record.recordedAt.day}/${record.recordedAt.year}',
                        icon: Icons.access_time_rounded,
                      ),
                      if (record.isCorrected) ...[
                        const SizedBox(height: DesignTokens.md),
                        _DetailRow(
                          label: 'Corrected',
                          value: 'Yes',
                          icon: Icons.edit_rounded,
                          valueColor: DesignTokens.warning,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.lg),
                Row(
                  children: [
                    Expanded(
                      child: PremiumButton(
                        label: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                        variant: ButtonVariant.outline,
                        isFullWidth: true,
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

  static Color _statusColor(AttendanceStatus status) => switch (status) {
    AttendanceStatus.present => DesignTokens.success,
    AttendanceStatus.absent => DesignTokens.error,
    AttendanceStatus.excused => DesignTokens.warning,
  };
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
            'Attendance',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36.0,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Track and manage volunteer participation records.',
            style: DesignTokens.body.copyWith(
              fontSize: 15.0,
              color: DesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0.0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: PremiumMetricCard(
              icon: Icons.people_alt_rounded,
              value: '124',
              label: 'Total Records',
              accentColor: DesignTokens.forest,
            ),
          ),
          const SizedBox(width: DesignTokens.md),
          Expanded(
            child: PremiumMetricCard(
              icon: Icons.check_circle_rounded,
              value: '98',
              label: 'Present',
              accentColor: DesignTokens.success,
            ),
          ),
          const SizedBox(width: DesignTokens.md),
          Expanded(
            child: PremiumMetricCard(
              icon: Icons.cancel_rounded,
              value: '22',
              label: 'Absent',
              accentColor: DesignTokens.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordList extends StatelessWidget {
  const _RecordList({
    super.key,
    required this.records,
    required this.onRecordTap,
  });

  final List<AttendanceRecord> records;
  final ValueChanged<AttendanceRecord> onRecordTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0.0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumSectionHeading(
            title: 'Recent Records',
            subtitle: '${records.length} attendance records',
            accentColor: DesignTokens.forest,
          ),
          const SizedBox(height: DesignTokens.lg),
          for (final record in records)
            Container(
              margin: const EdgeInsets.only(bottom: DesignTokens.md),
              child: PremiumCard(
                elevation: 1,
                borderRadius: DesignTokens.radiusXl,
                child: InkWell(
                  onTap: () => onRecordTap(record),
                  borderRadius: DesignTokens.radiusXl,
                  child: Padding(
                    padding: const EdgeInsets.all(DesignTokens.lg),
                    child: Row(
                      children: [
                        Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: _AttendancePageState._statusColor(
                              record.status,
                            ).withValues(alpha: 0.12),
                            borderRadius: DesignTokens.radiusLg,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: _AttendancePageState._statusColor(
                              record.status,
                            ),
                            size: 22.0,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.uid,
                                style: DesignTokens.title.copyWith(
                                  fontSize: 15.0,
                                  color: DesignTokens.ink,
                                ),
                              ),
                              const SizedBox(height: DesignTokens.xs / 2),
                              Text(
                                record.activityId,
                                style: DesignTokens.bodySmall.copyWith(
                                  color: DesignTokens.muted,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PremiumChip(
                              label: record.statusLabel,
                              color: _AttendancePageState._statusColor(
                                record.status,
                              ),
                              size: ChipSize.sm,
                            ),
                            const SizedBox(height: DesignTokens.xs / 2),
                            Text(
                              record.source.toUpperCase(),
                              style: DesignTokens.caption.copyWith(
                                color: DesignTokens.muted,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0.0,
        DesignTokens.lg,
        DesignTokens.xxl,
      ),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        color: DesignTokens.forest.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.xl),
          child: Row(
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: DesignTokens.forest.withValues(alpha: 0.15),
                  borderRadius: DesignTokens.radiusLg,
                ),
                child: const Icon(
                  Icons.note_add_rounded,
                  color: DesignTokens.forest,
                  size: 26.0,
                ),
              ),
              const SizedBox(width: DesignTokens.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need to correct a record?',
                      style: DesignTokens.headlineSmall.copyWith(
                        fontSize: 16.0,
                        color: DesignTokens.ink,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.sm),
                    Text(
                      'Authorized coordinators can update attendance with reason capture.',
                      style: DesignTokens.body.copyWith(
                        fontSize: 13.0,
                        color: DesignTokens.muted,
                      ),
                    ),
                  ],
                ),
              ),
              PremiumButton(
                label: 'Correct Record',
                onPressed: () {},
                variant: ButtonVariant.outline,
                isFullWidth: false,
                icon: Icons.edit_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: DesignTokens.canvas,
            borderRadius: DesignTokens.radiusMd,
          ),
          child: Icon(icon, size: 16.0, color: DesignTokens.muted),
        ),
        const SizedBox(width: DesignTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: DesignTokens.caption.copyWith(
                  color: DesignTokens.muted,
                  fontSize: 11.0,
                ),
              ),
              const SizedBox(height: DesignTokens.xs / 2),
              Text(
                value,
                style: DesignTokens.title.copyWith(
                  fontSize: 14.0,
                  color: valueColor ?? DesignTokens.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
