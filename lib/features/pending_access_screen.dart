import 'package:flutter/material.dart';

/// Screen shown to authenticated users whose account is pending approval.
///
/// Shown when the user's profile exists but [AccountStatus] is [pending].
/// Provides clear guidance to contact an administrator for approval.
class PendingAccessScreen extends StatelessWidget {
  const PendingAccessScreen({super.key, this.onSignOut, this.onRetry});

  final VoidCallback? onSignOut;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Account Pending'),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.hourglass_empty_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Account pending approval',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your account has been created but is waiting for administrator approval. '
                    'You will be able to access the app once your account is approved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, height: 1.6, fontSize: 14),
                  ),
                  const SizedBox(height: 26),
                  if (onRetry != null)
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Check again'),
                    ),
                  if (onRetry != null) const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed:
                        onSignOut ??
                        () => Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign out'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'If you believe this is an error, contact your unit administrator.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 12, height: 1.5),
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
