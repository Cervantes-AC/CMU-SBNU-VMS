import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/volunteers_repository.dart';
import '../../data/models/volunteer.dart';
import '../view_models/volunteers_view_model.dart';

/// Volunteers page — premium, fully functional.
class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  State<VolunteersPage> createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          Consumer<VolunteersViewModel>(
            builder: (context, viewModel, _) {
              final colleges = viewModel.colleges;
              final filtered = viewModel.filteredVolunteers;

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    _FilterBar(
                      colleges: colleges,
                      currentFilter: viewModel.collegeFilter,
                      onChanged: (value) {
                        if (value != null) viewModel.setCollegeFilter(value);
                      },
                    ),
                    const SizedBox(height: DesignTokens.lg),
                    AppStateWrapper(
                      status: viewModel.status,
                      onRetry: viewModel.init,
                      errorMessage: viewModel.error?.message,
                      child: filtered.isEmpty
                          ? const PremiumEmptyState(
                              icon: Icons.people_outline_rounded,
                              title: 'No volunteers found.',
                              subtitle:
                                  'Try adjusting your filter or check back later.',
                            )
                          : Padding(
                              padding: const EdgeInsets.all(DesignTokens.lg),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final v = filtered[index];
                                  return _VolunteerCard(
                                    profile: v,
                                    onTap: () => viewModel.select(v),
                                  );
                                },
                              ),
                            ),
                    ),
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
            'Volunteers',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Explore the volunteer roster across CMU colleges.',
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.colleges,
    required this.currentFilter,
    required this.onChanged,
  });

  final List<String> colleges;
  final String currentFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        0,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filter by college',
                style: DesignTokens.captionBold.copyWith(
                  color: DesignTokens.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.sm),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: currentFilter == 'All',
                  onTap: () => onChanged('All'),
                ),
                const SizedBox(width: DesignTokens.sm),
                for (final college in colleges)
                  _FilterChip(
                    label: college,
                    isSelected: currentFilter == college,
                    onTap: () => onChanged(college),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? DesignTokens.forest : Colors.white,
          borderRadius: DesignTokens.radiusXl,
          border: Border.all(
            color: isSelected ? DesignTokens.forest : DesignTokens.line,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? DesignTokens.shadowSoft(
                  color: DesignTokens.forest.withValues(alpha: 0.2),
                  blur: 12,
                  offset: const Offset(0, 4),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : DesignTokens.muted,
          ),
        ),
      ),
    );
  }
}

class _VolunteerCard extends StatelessWidget {
  const _VolunteerCard({required this.profile, required this.onTap});

  final VolunteerProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = profile.isActive;
    final statusColor = isActive ? DesignTokens.success : DesignTokens.error;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignTokens.radiusXl,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: DesignTokens.canvas,
                    borderRadius: DesignTokens.radiusXl,
                    boxShadow: DesignTokens.shadowSoft(
                      blur: 8,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile.fullName.isNotEmpty
                          ? profile.fullName.substring(0, 1).toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.forest,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName,
                        style: DesignTokens.title.copyWith(
                          fontSize: 16,
                          color: DesignTokens.ink,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.xs / 2),
                      Text(
                        profile.email,
                        style: DesignTokens.bodySmall.copyWith(
                          color: DesignTokens.muted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.sm),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              profile.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.md),
                          Text(
                            '${profile.college ?? '-'} · ${profile.course ?? '-'}',
                            style: DesignTokens.caption.copyWith(
                              color: DesignTokens.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: DesignTokens.card3D(
                    color: DesignTokens.canvas,
                    shadowLevel: 1,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: DesignTokens.muted,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
