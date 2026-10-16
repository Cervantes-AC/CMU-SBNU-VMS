import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AuthPageMode { signIn, register, recover }

class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.mode});

  final AuthPageMode mode;

  String get _title => switch (mode) {
    AuthPageMode.signIn => 'Sign in to SBNu',
    AuthPageMode.register => 'Join the volunteer network',
    AuthPageMode.recover => 'Account recovery',
  };

  String get _description => switch (mode) {
    AuthPageMode.signIn =>
      'The approved Firebase development project is configured for this build. Account sign-in is waiting for an approved identity method and account lifecycle.',
    AuthPageMode.register =>
      'Registration and account approval steps are pending owner decisions.',
    AuthPageMode.recover =>
      'Password recovery is not connected because the authentication provider and account lifecycle are not configured.',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Back to landing page',
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('SBNu Volunteer Corps'),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EFE7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF134F35),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      _description,
                      style: const TextStyle(
                        color: Color(0xFF65746A),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF0D7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF895F00),
                            size: 19,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Authentication is not enabled in this preview. Do not enter a password or real personal information here.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.45,
                                color: Color(0xFF6E581F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.go('/workspace'),
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Continue to sample workspace'),
                      ),
                    ),
                    if (mode == AuthPageMode.signIn) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => context.go('/account/recover'),
                          child: const Text('Account recovery'),
                        ),
                      ),
                    ],
                    if (mode != AuthPageMode.register) ...[
                      const Divider(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go('/account/register'),
                          child: const Text('Registration information'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
