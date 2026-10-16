import 'package:flutter/material.dart';

/// Placeholder overview section widget.
class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Overview section'),
      ),
    );
  }
}
