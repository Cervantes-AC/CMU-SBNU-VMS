import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_page.dart';
import '../../features/landing/presentation/landing_page.dart';
import '../../features/overview/presentation/overview_page.dart';

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
