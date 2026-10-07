import 'package:flutter/material.dart';

import 'parts/landing_content.dart';
import 'parts/landing_header.dart';
import 'parts/landing_hero.dart';

/// Public welcome page for the CMU School-Based NSRC unit.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const background = Color(0xFFF7F7F2);

  void _openSignIn(BuildContext context) =>
      Navigator.of(context).pushNamed('/sign-in');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1100
        ? 56.0
        : width >= 700
        ? 32.0
        : 20.0;
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LandingHeader(
              compact: width < 760,
              horizontalPadding: horizontal,
              onSignIn: () => _openSignIn(context),
            ),
          ),
          SliverToBoxAdapter(
            child: LandingHero(
              compact: width < 760,
              horizontalPadding: horizontal,
              onSignIn: () => _openSignIn(context),
            ),
          ),
          SliverToBoxAdapter(
            child: LandingContent(horizontalPadding: horizontal),
          ),
        ],
      ),
    );
  }
}
