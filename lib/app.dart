import 'package:flutter/material.dart';

/// Root widget for the CMU SBNU Volunteer Management System.
class NSRCApp extends StatelessWidget {
  const NSRCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMU SBNU Volunteer Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF245B4B)),
        useMaterial3: true,
      ),
      home: const _StartScreen(),
    );
  }
}

class _StartScreen extends StatelessWidget {
  const _StartScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('CMU SBNU VMS'),
      ),
    );
  }
}
