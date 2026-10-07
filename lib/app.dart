import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/landing/landing_page.dart';

/// Temporary application root for the local landing concept preview.
///
/// The authenticated router, Firebase initialization, and approved public
/// route are not implemented. Do not treat this preview root as release-ready.
class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF245B4B);

    return MaterialApp(
      title: 'Local Landing Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF5F7F1),
      ),
      home: const LandingPage(),
    );
  }
}
