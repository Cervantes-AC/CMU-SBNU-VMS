import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/features/auth/presentation/pages/auth_page.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/pages/landing_page.dart';
import 'package:cmu_sbnu_vms/features/overview/presentation/pages/overview_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LandingPage()),
    GoRoute(
      path: '/account/sign-in',
      builder: (context, state) => const AuthPage(mode: AuthPageMode.signIn),
    ),
    GoRoute(
      path: '/account/register',
      builder: (context, state) => const AuthPage(mode: AuthPageMode.register),
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
