import 'package:flutter/material.dart';

/// Neutral access-unavailable screen shown by the route guard for pending,
/// denied, disabled, missing-profile, or unauthorized-role situations.
///
/// Does not reveal whether an email exists, rule errors, or role/status
/// details to the unauthorized user. Provides a safe sign-out action and an
/// optional retry.
class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({
    super.key,
    this.onSignOut,
    this.onRetry,
  });

  /// Sign-out callback. When null, falls back to clearing the navigation
  /// stack (safe for signed-out visitors).
  final VoidCallback? onSignOut;

  /// Optional retry callback (e.g. re-check the session/profile).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Access'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.lock_outline_rounded,
                        size: 30, color: muted),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Access unavailable',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This area isn’t available for your account right now. '
                    'If you believe you should have access, contact your unit '
                    'administrator to review your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, height: 1.6, fontSize: 14),
                  ),
                  const SizedBox(height: 26),
                  if (onRetry != null)
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Try again'),
                    ),
                  if (onRetry != null) const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: onSignOut ??
                        () => Navigator.of(context).popUntil(
                            (route) => route.isFirst),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
