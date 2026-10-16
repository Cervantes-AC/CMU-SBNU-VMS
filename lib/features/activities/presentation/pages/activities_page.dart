import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/performance/performance.dart';
import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../../../app/theme/app_theme.dart';
import '../../data/models/activity.dart';
import '../view_models/activities_view_model.dart';

/// Activities page - browse and manage activities.
///
/// Rendered as content inside the workspace shell; no AppBar here.
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesViewModel>(
      builder: (context, viewModel, _) {
        final activities = viewModel.publishedActivities;

        return AppStateWrapper(
          status: viewModel.status,
          onRetry: viewModel.init,
          errorMessage: viewModel.error?.message,
          child: activities.isEmpty
              ? const AppEmptyState(
                  icon: Icons.event_outlined,
                  title: 'No activities available.',
                  subtitle: 'Check back later for new service opportunities.',
                )
              : ResponsiveListView(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _ActivityCard(
                      activity: activity,
                      onTap: () => viewModel.selectActivity(activity),
                      onJoin: () =>
                          viewModel.joinActivity(activity.id, 'current_user'),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.onTap,
    required this.onJoin,
  });

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: const Color(0xFFDFE5DF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5B40),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -45,
                      top: -65,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 25,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              activity.statusLabel,
                              style: GoogleFontsDMSans.w700.copyWith(
                                fontSize: 8,
                                color: AppTheme.surface,
                                letterSpacing: 1,
                                height: 1,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                '${activity.participantCount} going',
                                style: GoogleFontsDMSans.w800.copyWith(
                                  fontSize: 50,
                                  color: AppTheme.surface,
                                  height: 0.9,
                                  letterSpacing: -3,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'volunteers',
                                style: GoogleFontsDMSans.w400.copyWith(
                                  fontSize: 9,
                                  color: AppTheme.surface.withValues(
                                    alpha: 0.75,
                                  ),
                                  height: 1,
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
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: GoogleFontsManrope.w700.copyWith(
                        fontSize: 14,
                        color: AppTheme.ink,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Color(0xFF7B877F),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          activity.scheduleLabel,
                          style: GoogleFontsDMSans.w400.copyWith(
                            fontSize: 9,
                            color: const Color(0xFF7B877F),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: Color(0xFF7B877F),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          activity.venue,
                          style: GoogleFontsDMSans.w400.copyWith(
                            fontSize: 9,
                            color: const Color(0xFF7B877F),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      width: double.infinity,
                      height: 37,
                      child: OutlinedButton.icon(
                        onPressed: onJoin,
                        icon: const Icon(
                          Icons.person_add,
                          size: 13,
                          color: Color(0xFF1F5A3D),
                        ),
                        label: Text(
                          'Join activity',
                          style: GoogleFontsDMSans.w700.copyWith(
                            fontSize: 9,
                            color: const Color(0xFF1F5A3D),
                            height: 1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1F5A3D),
                          side: const BorderSide(
                            color: Color(0xFFDBE2DC),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Font weight helpers reused across activity widgets.
abstract class GoogleFontsManrope {
  static TextStyle get w400 => GoogleFonts.manrope(fontWeight: FontWeight.w400);
  static TextStyle get w700 => GoogleFonts.manrope(fontWeight: FontWeight.w700);
  static TextStyle get w800 => GoogleFonts.manrope(fontWeight: FontWeight.w800);
}

abstract class GoogleFontsDMSans {
  static TextStyle get w400 => GoogleFonts.dmSans(fontWeight: FontWeight.w400);
  static TextStyle get w700 => GoogleFonts.dmSans(fontWeight: FontWeight.w700);
  static TextStyle get w800 => GoogleFonts.dmSans(fontWeight: FontWeight.w800);
}
