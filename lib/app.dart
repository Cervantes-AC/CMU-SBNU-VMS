import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/auth/auth_screen.dart';
import 'package:cmu_sbnu_vms/features/auth/password_reset_screen.dart';
import 'package:cmu_sbnu_vms/features/landing/landing_page.dart';

/// Application composition root for the landing-to-sign-in flow.
///
/// The authenticated router, Firebase initialization, and approved public
/// route are not implemented. Sign-in screens remain disabled until auth is
/// injected by the approved application bootstrap.
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
        '/sign-in': (_) => const AuthScreen(),
        '/password-reset': (_) => const PasswordResetScreen(),
      },
    );
  }
}
