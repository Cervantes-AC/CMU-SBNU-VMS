import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/volunteer.dart';
import '../view_models/volunteers_view_model.dart';

/// Volunteers page - roster and profiles.
class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  State<VolunteersPage> createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VolunteersViewModel>(
      builder: (context, viewModel, _) {
        final colleges = viewModel.colleges;
        final filtered = viewModel.filteredVolunteers;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Volunteers'),
            actions: [
              DropdownButton<String>(
                value: viewModel.collegeFilter,
                items: colleges
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) viewModel.setCollegeFilter(value);
                },
              ),
            ],
          ),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: filtered.isEmpty
                ? const AppEmptyState(
                    icon: Icons.groups_outlined,
                    title: 'No volunteers found.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
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
        );
      },
    );
  }
}

class _VolunteerCard extends StatelessWidget {
  const _VolunteerCard({required this.profile, required this.onTap});

  final VolunteerProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outlined,
                  color: Color(0xFF134F35),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17231C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF68766D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${profile.college ?? '-'} · ${profile.course ?? '-'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF748078),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: profile.isActive
                            ? const Color(0xFFE5EFE7)
                            : const Color(0xFFF5E5E5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        profile.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: profile.isActive
                              ? const Color(0xFF196142)
                              : const Color(0xFFB63D34),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFADB5AF)),
            ],
          ),
        ),
      ),
    );
  }
}
