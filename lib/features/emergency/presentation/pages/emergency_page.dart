import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/features/hotlines/presentation/pages/hotlines_page.dart';
import 'package:cmu_sbnu_vms/features/incidents/presentation/pages/incidents_page.dart';
import 'package:cmu_sbnu_vms/features/sos/presentation/pages/sos_page.dart';
import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';

/// Emergency & Safety page — premium tabbed composition.
class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  leading: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.all(DesignTokens.md),
                    decoration: DesignTokens.card3D(
                      color: DesignTokens.canvas,
                      shadowLevel: 1,
                    ),
                    child: ClipRRect(
                      borderRadius: DesignTokens.radiusMd,
                      child: Image.asset(
                        'assets/images/sbnu_app_icon.png',
                        semanticLabel: 'SBNU logo',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'Emergency & Safety',
                    style: DesignTokens.headline.copyWith(
                      fontSize: 18,
                      color: DesignTokens.ink,
                    ),
                  ),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: DesignTokens.forestGradient,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    labelColor: DesignTokens.forest,
                    unselectedLabelColor: DesignTokens.muted,
                    indicatorColor: DesignTokens.forest,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(icon: Icon(Icons.warning_amber_rounded), text: 'SOS'),
                      Tab(icon: Icon(Icons.report_outlined), text: 'Incidents'),
                      Tab(icon: Icon(Icons.phone_outlined), text: 'Hotlines'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [SosPage(), IncidentsPage(), HotlinesPage()],
          ),
        ),
      ),
    );
  }
}
