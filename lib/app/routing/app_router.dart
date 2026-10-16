import 'package:go_router/go_router.dart';

import '../../features/activities/presentation/pages/activities_page.dart';
import '../../features/announcements/presentation/pages/announcements_page.dart';
import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/password_recovery_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/emergency/presentation/pages/emergency_page.dart';
import '../../features/hotlines/presentation/pages/hotlines_page.dart';
import '../../features/incidents/presentation/pages/incidents_page.dart';
import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/organizations/presentation/pages/organizations_page.dart';
import '../../features/overview/presentation/pages/overview_page.dart';
import '../../features/reporting/presentation/pages/reports_page.dart';
import '../../features/sos/presentation/pages/sos_page.dart';
import '../../features/volunteers/presentation/pages/volunteers_page.dart';
import '../../features/audit/presentation/pages/audit_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LandingPage()),
    GoRoute(
      path: '/account/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/account/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/account/recover',
      builder: (context, state) => const PasswordRecoveryPage(),
    ),
    GoRoute(
      path: '/workspace',
      builder: (context, state) => const OverviewPage(),
    ),
    GoRoute(
      path: '/activities',
      builder: (context, state) => const ActivitiesPage(),
    ),
    GoRoute(
      path: '/volunteers',
      builder: (context, state) => const VolunteersPage(),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendancePage(),
    ),
    GoRoute(
      path: '/announcements',
      builder: (context, state) => const AnnouncementsPage(),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyPage(),
    ),
    GoRoute(path: '/reports', builder: (context, state) => const ReportsPage()),
    GoRoute(path: '/sos', builder: (context, state) => const SosPage()),
    GoRoute(
      path: '/incidents',
      builder: (context, state) => const IncidentsPage(),
    ),
    GoRoute(
      path: '/hotlines',
      builder: (context, state) => const HotlinesPage(),
    ),
    GoRoute(path: '/audit', builder: (context, state) => const AuditPage()),
    GoRoute(
      path: '/organizations',
      builder: (context, state) => const OrganizationsPage(),
    ),
  ],
);
