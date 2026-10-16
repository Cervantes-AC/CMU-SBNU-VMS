import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'features/activities/data/activities_repository.dart';
import 'features/activities/presentation/view_models/activities_view_model.dart';
import 'features/attendance/data/attendance_repository.dart';
import 'features/attendance/presentation/view_models/attendance_view_model.dart';
import 'features/announcements/data/announcements_repository.dart';
import 'features/announcements/presentation/view_models/announcements_view_model.dart';
import 'features/incidents/data/incidents_repository.dart';
import 'features/incidents/presentation/view_models/incidents_view_model.dart';
import 'features/volunteers/data/volunteers_repository.dart';
import 'features/volunteers/presentation/view_models/volunteers_view_model.dart';
import 'features/organizations/data/organizations_repository.dart';
import 'features/organizations/presentation/view_models/organizations_view_model.dart';
import 'features/reporting/data/reports_repository.dart';
import 'features/reporting/presentation/view_models/reports_view_model.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/landing/presentation/landing_page.dart';
import 'features/overview/presentation/overview_page.dart';

class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  static final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingPage()),
      GoRoute(
        path: '/account/sign-in',
        builder: (context, state) => const AuthPage(mode: AuthPageMode.signIn),
      ),
      GoRoute(
        path: '/account/register',
        builder: (context, state) =>
            const AuthPage(mode: AuthPageMode.register),
      ),
      GoRoute(
        path: '/account/recover',
        builder: (context, state) => const AuthPage(mode: AuthPageMode.recover),
      ),
      GoRoute(
        path: '/workspace',
        builder: (context, state) => const OverviewPage(),
      ),
    ],
  );

  static const _forest = Color(0xFF134F35);
  static const _ink = Color(0xFF17231C);
  static const _canvas = Color(0xFFF3F5F0);

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _forest,
      primary: _forest,
      secondary: const Color(0xFFD5A52F),
      surface: Colors.white,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivitiesViewModel(PreviewActivitiesRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceViewModel(PreviewAttendanceRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AnnouncementsViewModel(PreviewAnnouncementsRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => IncidentsViewModel(PreviewIncidentsRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => VolunteersViewModel(PreviewVolunteersRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              OrganizationsViewModel(PreviewOrganizationsRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportsViewModel(PreviewReportsRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: 'CMU–SBNU Volunteer Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: scheme,
          scaffoldBackgroundColor: _canvas,
          fontFamily: 'Roboto',
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: _ink,
            displayColor: _ink,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE1E6DF)),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
