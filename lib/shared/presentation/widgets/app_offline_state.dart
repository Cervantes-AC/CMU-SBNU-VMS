import 'package:flutter/material.dart';

import 'app_button.dart';

/// An offline state.
class AppOfflineState extends StatelessWidget {
  const AppOfflineState({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Color(0xFFB63D34)),
            const SizedBox(height: 16),
            const Text(
              'You appear to be offline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17231C),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Check your connection and try again.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF68766D),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              AppButton(
                label: 'Try again',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
