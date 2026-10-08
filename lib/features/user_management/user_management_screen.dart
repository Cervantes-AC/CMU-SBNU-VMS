import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/user_management/user_management.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/shared/empty_state.dart';
import 'package:cmu_sbnu_vms/shared/status_badge.dart';

import 'user_management_controller.dart';
import 'widgets/user_list_item.dart';
import 'widgets/user_statistics_card.dart';

/// User management screen for admins.
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
  });

  final UserManagementController controller;
  final SessionController sessionController;
  final AuthController authController;

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.controller.load();
    widget.controller.loadStatistics();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.controller,
        widget.sessionController,
        widget.authController,
      ]),
      builder: (context, _) {
        final state = widget.controller.state;
        final profile = widget.sessionController.profile;
        final isAdmin = profile?.role == UserRole.officer ||
            profile?.role == UserRole.admin;

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
                onPressed: widget.authController.signOut,
                icon: const Icon(Icons.logout_rounded, size: 17),
                label: Text(compact ? '' : 'Sign out'),
                style: TextButton.styleFrom(foregroundColor: AppTheme.seed),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // Search and filter bar
                _buildSearchAndFilterBar(widget.controller.state),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => widget.controller.load(),
                    child: _buildBody(widget.controller.state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilterBar(UserManagementViewState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users by name...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (value) {
              // TODO: Implement search
            },
            onSubmitted: (value) {
              // TODO: Trigger search
            },
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: state.selectedFilter == null,
                  onSelected: () => widget.controller.load(filter: null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pending',
                  selected: state.selectedFilter == UserManagementFilter.pending,
                  onSelected: () => widget.controller.load(filter: UserManagementFilter.pending),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Approved',
                  selected: state.selectedFilter == UserManagementFilter.approved,
                  onSelected: () => widget.controller.load(filter: UserManagementFilter.approved),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Suspended',
                  selected: state.selectedFilter == UserManagementFilter.suspended,
                  onSelected: () => widget.controller.load(filter: UserManagementFilter.suspended),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Deactivated',
                  selected: state.selectedFilter == UserManagementFilter.deactivated,
                  onSelected: () => widget.controller.load(filter: UserManagementFilter.deactivated),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(UserManagementViewState state) {
    if (state.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => widget.controller.load(),
        onDismiss: widget.controller.clearError,
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        title: 'No users found',
        explanation: 'Users will appear here as they register or are added by administrators.',
        icon: Icons.people_outline,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: state.items.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          if (state.loading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox.shrink();
        }
        final user = state.items[index];
        return UserListItem(
          user: user,
          onTap: () => _showUserActionsDialog(state.items[index]),
        );
      },
    );
  }

  void _showUserActionsDialog(UserProfile user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(user.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit User'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to edit user
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_rounded, color: Colors.red),
              title: const Text('Deactivate', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _confirmDeactivateUser(user);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeactivateUser(UserProfile user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Deactivate User'),
        content: Text('Are you sure you want to deactivate ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.controller.updateUserStatus(user.uid, AccountStatus.deactivated);
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog() {
    widget.controller.loadStatistics().then((_) {
      final stats = widget.controller.state.statistics;
      if (stats != null && mounted) {
        showDialog(
          context: context,
          builder: (context) => _StatisticsDialog(statistics: widget.controller.state.statistics!),
        );
      }
    });
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppTheme.seed.withAlpha(30),
      checkmarkColor: AppTheme.seed,
      labelStyle: TextStyle(
        color: selected ? AppTheme.seed : Theme.of(context).colorScheme.onSurface,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? AppTheme.seed : const Color(0xFFE1E8E1),
        ),
      ),
    );
  }
}

// Error view
class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 40),
            const SizedBox(height: 16),
            Text(
              'Couldn\'t load users',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsDialog extends StatelessWidget {
  const _StatisticsDialog({required this.statistics});

  final UserStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('User Statistics'),
      content: SingleChildScrollView(
        child: UserStatisticsCard(statistics: statistics),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}