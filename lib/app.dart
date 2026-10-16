import 'package:flutter/material.dart';

import 'app/dependencies/app_providers.dart';
import 'app/routing/app_router.dart';
import 'app/theme/app_theme.dart';

class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return withAppProviders(
      child: MaterialApp.router(
        title: 'CMU–SBNU Volunteer Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: appRouter,
      ),
    );
  }
}
