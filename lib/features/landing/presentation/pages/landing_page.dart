import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/cta_section.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/hero_section.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/mission_section.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/programs_section.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/public_footer.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/public_header.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/safety_section.dart';

/// Public landing page — premium, fully functional entry point.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const PublicHeader()),
            SliverToBoxAdapter(child: const HeroSection()),
            SliverToBoxAdapter(child: const MissionSection()),
            SliverToBoxAdapter(child: const ProgramsSection()),
            SliverToBoxAdapter(child: const SafetySection()),
            SliverToBoxAdapter(child: const CtaSection()),
            SliverToBoxAdapter(child: const PublicFooter()),
          ],
        ),
      ),
    );
  }
}
