import 'package:flutter/material.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/landing_header.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/landing_hero.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/landing_sections.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/brand_logos_section.dart';
import 'package:cmu_sbnu_vms/features/landing/presentation/widgets/scroll_reveal.dart';

/// Composes the landing page sections and owns in-page navigation.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollController = ScrollController();
  final _platformKey = GlobalKey();
  final _principlesKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 820;
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: LandingHeader(
                    isWide: isWide,
                    onPlatform: () => _scrollTo(_platformKey),
                    onPrinciples: () => _scrollTo(_principlesKey),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ScrollReveal(
                    child: LandingHero(
                      isWide: isWide,
                      onExplore: () => _scrollTo(_platformKey),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: BrandLogosSection(isWide: isWide)),
                SliverToBoxAdapter(
                  child: ScrollReveal(
                    child: PlatformSection(key: _platformKey, isWide: isWide),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ScrollReveal(
                    child: PrinciplesSection(
                      key: _principlesKey,
                      isWide: isWide,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: LandingFooter()),
              ],
            );
          },
        ),
      ),
    );
  }
}
