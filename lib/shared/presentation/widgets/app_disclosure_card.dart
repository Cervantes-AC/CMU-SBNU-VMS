import 'package:flutter/material.dart';

/// A disclosure card explaining that a feature is not yet connected to real services.
class AppDisclosureCard extends StatelessWidget {
  const AppDisclosureCard({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconColor = const Color(0xFF52715E),
  });

  final String message;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: const Color(0xFF59685E),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
