import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(child: _Hero()),
            SliverToBoxAdapter(child: _PreviewNotice()),
            SliverToBoxAdapter(child: _PurposeSection()),
            SliverToBoxAdapter(child: _SafetyNote()),
            SliverToBoxAdapter(child: _Footer()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE5EFE7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/sbnu_app_icon.png',
                semanticLabel: 'SBNU logo',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SBNu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  'CMU VOLUNTEER CORPS',
                  style: TextStyle(
                    color: Color(0xFF748078),
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF0D7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'PREVIEW',
              style: TextStyle(
                color: Color(0xFF895F00),
                fontSize: 10,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 22, height: 2, color: const Color(0xFFD5A52F)),
              const SizedBox(width: 9),
              const Text(
                'CENTRAL MINDANAO UNIVERSITY',
                style: TextStyle(
                  color: Color(0xFFAA7C10),
                  fontSize: 10,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 39,
                height: 1.08,
                letterSpacing: -1.7,
                fontWeight: FontWeight.w800,
                color: Color(0xFF15281D),
              ),
              children: const [
                TextSpan(text: 'A clearer view of volunteer work.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'One connected space for volunteers to discover opportunities, coordinate service, and support a safer, more resilient community.',
            style: TextStyle(
              color: Color(0xFF68766D),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          const _PreviewButton(),
          const SizedBox(height: 28),
          const _ImpactCard(),
        ],
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.icon(
          onPressed: () => context.go('/workspace'),
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Explore the volunteer workspace'),
        ),
        const SizedBox(height: 6),
        Wrap(
          children: [
            TextButton.icon(
              onPressed: () => context.go('/account/sign-in'),
              icon: const Icon(Icons.login, size: 17),
              label: const Text('Sign in'),
            ),
            TextButton(
              onPressed: () => context.go('/account/register'),
              child: const Text('Join the network'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C402B), Color(0xFF176043)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 0,
            top: -18,
            child: Icon(
              Icons.eco_outlined,
              size: 110,
              color: Color(0x33FFFFFF),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SERVICE • COMMUNITY • UNITY',
                style: TextStyle(
                  color: Color(0xFFE1B747),
                  fontSize: 9,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Many hands make\na stronger community.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Connect people, programs, and purpose across CMU.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF52715E)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Concept only. Sign-in, member records, and public services are not connected.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: const Color(0xFF59685E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurposeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.explore_outlined,
        'Discover opportunities',
        'Find activities and ways to serve.',
      ),
      (
        Icons.groups_outlined,
        'Coordinate together',
        'Keep teams and programs connected.',
      ),
      (
        Icons.insights_outlined,
        'Understand impact',
        'Make participation and service visible.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHY SBNu',
            style: TextStyle(
              color: Color(0xFFAA7C10),
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'A stronger culture of service starts here.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 14),
          for (final item in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE5EFE7),
                  foregroundColor: const Color(0xFF134F35),
                  child: Icon(item.$1),
                ),
                title: Text(
                  item.$2,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(item.$3),
              ),
            ),
        ],
      ),
    );
  }
}

class _SafetyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EEE8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE5DD)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_outlined, color: Color(0xFF134F35)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Safety is part of service. Emergency features require approved procedures and designated responders before real use.',
                style: TextStyle(height: 1.45, color: Color(0xFF43564A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E5DF))),
      ),
      child: const Text(
        'CMU–SBNU VOLUNTEER MANAGEMENT SYSTEM',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF89948C),
          fontSize: 9,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
