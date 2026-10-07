import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';

/// Filter bar for events list.
class EventFilterBar extends StatelessWidget {
  const EventFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  static const List<_FilterOption> _filters = [
    _FilterOption('all', 'All'),
    _FilterOption('members', 'Members'),
    _FilterOption('officers', 'Officers'),
    _FilterOption('admins', 'Admins'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          for (final filter in _filters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter.label),
                selected: selectedFilter == filter.value,
                onSelected: (_) => onFilterChanged(filter.value),
                selectedColor: AppTheme.seed.withAlpha(30),
                checkmarkColor: AppTheme.seed,
                labelStyle: TextStyle(
                  color: selectedFilter == filter.value
                      ? AppTheme.seed
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: selectedFilter == filter.value
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selectedFilter == filter.value
                        ? AppTheme.seed
                        : const Color(0xFFE1E8E1),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption(this.value, this.label);

  final String value;
  final String label;
}