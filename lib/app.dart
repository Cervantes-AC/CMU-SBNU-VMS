import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/landing_page.dart';

/// Root widget and composition point for the CMU SBNU Volunteer Management System.
class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMU SBNU Volunteer Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LandingPage(),
    );
  }
}
