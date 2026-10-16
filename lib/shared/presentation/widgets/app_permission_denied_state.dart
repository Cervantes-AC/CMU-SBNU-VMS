import 'package:flutter/material.dart';

import 'app_button.dart';

/// A permission-denied state.
class AppPermissionDeniedState extends StatelessWidget {
  const AppPermissionDeniedState({super.key, this.message, this.onBack});

  final String? message;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: Color(0xFF748078)),
            const SizedBox(height: 16),
            const Text(
              'Not authorized',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17231C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message ?? 'You do not have permission to view this page.',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF68766D),
              ),
              textAlign: TextAlign.center,
            ),
            if (onBack != null) ...[
              const SizedBox(height: 20),
              AppButton(
                label: 'Back to workspace',
                onPressed: onBack,
                icon: Icons.arrow_back,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
