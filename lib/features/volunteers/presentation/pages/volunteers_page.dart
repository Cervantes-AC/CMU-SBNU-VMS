import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/volunteer.dart';
import '../view_models/volunteers_view_model.dart';

/// Volunteers page - roster and profiles.
///
/// Rendered as content inside the workspace shell; no AppBar here.
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

        return AppStateWrapper(
          status: viewModel.status,
          onRetry: viewModel.init,
          errorMessage: viewModel.error?.message,
          child: filtered.isEmpty
              ? const AppEmptyState(
                  icon: Icons.groups_outlined,
                  title: 'No volunteers found.',
                  subtitle: 'Check back later for new volunteer profiles.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: viewModel.collegeFilter,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Filter by college',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            items: colleges
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                viewModel.setCollegeFilter(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ResponsiveListView(
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
                  ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: const Color(0xFFDFE5DF)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    profile.fullName.isNotEmpty
                        ? profile.fullName.substring(0, 1).toUpperCase()
                        : '?',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF173423),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF829B8B),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: profile.isActive
                                ? const Color(0xFFE7F1E9)
                                : const Color(0xFFF8E9E7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            profile.status.toUpperCase(),
                            style: GoogleFonts.dmSans(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: profile.isActive
                                  ? const Color(0xFF23603F)
                                  : const Color(0xFFB63D34),
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${profile.college ?? '-'} · ${profile.course ?? '-'}',
                          style: GoogleFonts.dmSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9AA29D),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 14,
                color: Color(0xFFADB5AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
