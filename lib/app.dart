import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'features/activities/data/activities_repository.dart';
import 'features/activities/presentation/view_models/activities_view_model.dart';
import 'features/landing/presentation/landing_page.dart';
import 'features/overview/presentation/overview_page.dart';

class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  static final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingPage()),
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

    return ChangeNotifierProvider(
      create: (_) => ActivitiesViewModel(PreviewActivitiesRepository()),
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
