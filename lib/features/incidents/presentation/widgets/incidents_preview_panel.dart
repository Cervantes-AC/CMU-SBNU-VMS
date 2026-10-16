import 'package:flutter/material.dart';

/// Placeholder panel for incidents preview.
class IncidentsPreviewPanel extends StatelessWidget {
  const IncidentsPreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Incident reports are managed through the Incidents page.',
          style: TextStyle(color: Color(0xFF68766D)),
        ),
      ),
    );
  }
}
