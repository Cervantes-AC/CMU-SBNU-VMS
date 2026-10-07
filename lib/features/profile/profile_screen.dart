import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/core/utils/validators.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';

import 'profile_controller.dart';

/// Profile screen for viewing and editing the signed-in member's profile.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    required this.profile,
    required this.onSignOut,
  });

  final ProfileController controller;
  final UserProfile profile;
  final VoidCallback onSignOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _courseController;
  late final TextEditingController _yearLevelController;
  late final TextEditingController _contactNumberController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.profile.displayName);
    _courseController = TextEditingController(text: widget.profile.course ?? '');
    _yearLevelController = TextEditingController(text: widget.profile.yearLevel ?? '');
    _contactNumberController = TextEditingController(text: widget.profile.contactNumber ?? '');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F2),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F7F2),
            surfaceTintColor: Colors.transparent,
            titleSpacing: 8,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E8E1)),
                  ),
                  child: Image.asset('assets/images/SBNU LOGO.png',
                      fit: BoxFit.contain,
                      semanticLabel: 'CMU School-Based NSRC Unit logo'),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'CMU SBNU VMS',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: state.saving ? null : widget.onSignOut,
                icon: const Icon(Icons.logout_rounded, size: 17),
                label: Text(compact ? '' : 'Sign out'),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFF245B4B)),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    compact ? 20 : 32, 8, compact ? 20 : 32, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(
                        displayName: widget.profile.displayName,
                        role: widget.profile.role,
                        email: widget.profile.email,
                        photoUrl: widget.profile.photoUrl,
                      ),
                      const SizedBox(height: 24),
                      _ProfileForm(
                        formKey: _formKey,
                        displayNameController: _displayNameController,
                        courseController: _courseController,
                        yearLevelController: _yearLevelController,
                        contactNumberController: _contactNumberController,
                        isSaving: state.saving,
                        onSave: _save,
                      ),
                      if (state.successMessage != null) ...[
                        const SizedBox(height: 16),
                        _SuccessBanner(message: state.successMessage!),
                      ],
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _ErrorBanner(
                          message: state.errorMessage!,
                          onDismiss: widget.controller.clearMessages,
                        ),
                      ],
                      const SizedBox(height: 24),
                      _ReadOnlySection(profile: widget.profile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    await widget.controller.updateProfile({
      'displayName': _displayNameController.text.trim(),
      'course': _courseController.text.trim().isEmpty
          ? null
          : _courseController.text.trim(),
      'yearLevel': _yearLevelController.text.trim().isEmpty
          ? null
          : _yearLevelController.text.trim(),
      'contactNumber': _contactNumberController.text.trim().isEmpty
          ? null
          : _contactNumberController.text.trim(),
    });
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.displayName,
    required this.role,
    this.email,
    this.photoUrl,
  });

  final String displayName;
  final UserRole role;
  final String? email;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E8E1)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFF245B4B).withAlpha(20),
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? const Icon(Icons.person_rounded, size: 36, color: Color(0xFF245B4B))
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF245B4B).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF245B4B).withAlpha(70)),
                  ),
                  child: Text(
                    _roleLabel(role),
                    style: const TextStyle(
                      color: Color(0xFF245B4B),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (email != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    email!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _roleLabel(UserRole role) => switch (role) {
        UserRole.member => 'Member',
        UserRole.officer => 'Officer',
        UserRole.admin => 'Administrator',
      };
}

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.formKey,
    required this.displayNameController,
    required this.courseController,
    required this.yearLevelController,
    required this.contactNumberController,
    required this.isSaving,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController displayNameController;
  final TextEditingController courseController;
  final TextEditingController yearLevelController;
  final TextEditingController contactNumberController;
  final bool isSaving;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E8E1)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_outlined, color: Color(0xFF245B4B), size: 22),
                const SizedBox(width: 10),
                Text(
                  'Editable Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) => Validators.required(v, fieldName: 'Display name') ??
                  Validators.length(v, max: 80, fieldName: 'Display name'),
              enabled: !isSaving,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course / Program (optional)',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              validator: (v) => Validators.safeText(v, max: 120, fieldName: 'Course'),
              enabled: !isSaving,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: yearLevelController,
              decoration: const InputDecoration(
                labelText: 'Year Level (optional)',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: (v) => Validators.safeText(v, max: 20, fieldName: 'Year level'),
              enabled: !isSaving,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: contactNumberController,
              decoration: const InputDecoration(
                labelText: 'Contact Number (optional)',
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: '+63 9XX XXX XXXX',
              ),
              validator: (v) => Validators.phone(v),
              enabled: !isSaving,
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isSaving ? null : () => onSave(),
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(isSaving ? 'Saving...' : 'Save changes'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Role, status, account ID, and service hours are managed by administrators and cannot be changed here.',
              style: TextStyle(color: muted, fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlySection extends StatelessWidget {
  const _ReadOnlySection({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFB),
        border: Border.all(color: const Color(0xFFE1E8E1)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFF2C6E9E), size: 22),
              const SizedBox(width: 10),
              Text(
                'Account Information (read-only)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Account ID', value: profile.uid),
          _InfoRow(label: 'Status', value: _statusLabel(profile.status)),
          _InfoRow(label: 'Joined', value: _formatDate(profile.createdAt)),
          _InfoRow(label: 'Last updated', value: _formatDate(profile.updatedAt)),
          if (profile.email != null)
            _InfoRow(label: 'Email', value: profile.email!),
        ],
      ),
    );
  }

  static String _statusLabel(AccountStatus status) => switch (status) {
        AccountStatus.pending => 'Pending approval',
        AccountStatus.approved => 'Approved',
        AccountStatus.denied => 'Denied',
        AccountStatus.suspended => 'Suspended',
        AccountStatus.deactivated => 'Deactivated',
        AccountStatus.blocked => 'Blocked',
      };

  static String _formatDate(DateTime dt) =>
      '${dt.day} ${_monthName(dt.month)} ${dt.year}';

  static String _monthName(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D4F).withAlpha(20),
        border: Border.all(color: const Color(0xFF2E7D4F).withAlpha(70)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D4F), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF2E7D4F), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFB3372C).withAlpha(20),
        border: Border.all(color: const Color(0xFFB3372C).withAlpha(70)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_rounded, color: Color(0xFFB3372C), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFB3372C), fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: const Color(0xFFB3372C),
          ),
        ],
      ),
    );
  }
}