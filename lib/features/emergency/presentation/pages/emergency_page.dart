import 'package:flutter/material.dart';

import '../../../hotlines/presentation/pages/hotlines_page.dart';
import '../../../incidents/presentation/pages/incidents_page.dart';
import '../../../sos/presentation/pages/sos_page.dart';

/// Emergency & Safety page - composition of safety workflows.
class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Emergency & Safety'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.warning_amber_rounded), text: 'SOS'),
              Tab(icon: Icon(Icons.report_outlined), text: 'Incidents'),
              Tab(icon: Icon(Icons.phone_outlined), text: 'Hotlines'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SosPage(),
            IncidentsPage(),
            HotlinesPage(),
          ],
        ),
      ),
    );
  }
}
