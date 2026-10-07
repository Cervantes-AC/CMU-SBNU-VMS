import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/auth/auth_screen.dart';
import 'package:cmu_sbnu_vms/features/auth/demo_admin_credentials.dart';
import 'package:cmu_sbnu_vms/features/auth/password_reset_screen.dart';
import 'package:cmu_sbnu_vms/features/dashboard/demo_admin_dashboard_screen.dart';
import 'package:cmu_sbnu_vms/features/landing/landing_page.dart';

/// Application composition root for the landing-to-sign-in flow.
///
/// The authenticated router, Firebase initialization, and approved public
/// route are not implemented. A debug-only local demo credential opens a
/// synthetic dashboard preview and does not authenticate a real account.
class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF245B4B);

    return MaterialApp(
      title: 'Volunteer Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF5F7F1),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LandingPage(),
        '/sign-in': (context) => AuthScreen(
          demoMode: kDebugMode,
          onSignIn: kDebugMode
              ? (email, password) async {
                  if (email.trim() != DemoAdminCredentials.email ||
                      password != DemoAdminCredentials.password) {
                    throw StateError('Invalid local demo credentials.');
                  }
                  Navigator.of(context).pushReplacementNamed('/demo-admin');
                }
              : null,
        ),
        '/password-reset': (_) => const PasswordResetScreen(),
        if (kDebugMode) '/demo-admin': (_) => const DemoAdminDashboardScreen(),
      },
    );
  }
}
