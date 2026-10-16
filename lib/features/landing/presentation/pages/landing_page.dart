import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Public landing page — fully functional entry point.
///
/// Displays the CMU–SBNU brand, mission, programs, and safety features.
/// Sign-in and registration actions are connected to the auth ViewModel.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _PublicHeader()),
            SliverToBoxAdapter(child: _HeroSection()),
            SliverToBoxAdapter(child: _MissionSection()),
            SliverToBoxAdapter(child: _ProgramsSection()),
            SliverToBoxAdapter(child: _SafetySection()),
            SliverToBoxAdapter(child: _CtaSection()),
            SliverToBoxAdapter(child: _PublicFooter()),
          ],
        ),
      ),
    );
  }
}

/// Public header with brand and navigation.
class _PublicHeader extends StatelessWidget {
  const _PublicHeader();

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
          const _AuthActions(),
        ],
      ),
    );
  }
}

/// Sign-in / register actions in the header.
class _AuthActions extends StatelessWidget {
  const _AuthActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => context.go('/account/sign-in'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text(
            'Sign in',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        AppButton(
          label: 'Join the network',
          onPressed: () => context.go('/account/register'),
          icon: Icons.person_add,
          isOutlined: true,
        ),
      ],
    );
  }
}

/// Hero section with mission statement and primary CTAs.
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 30),
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
                TextSpan(text: 'Service that moves a community forward.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'One connected space for CMU volunteers to discover opportunities, '
            'serve with purpose, and build a safer, more resilient community.',
            style: TextStyle(
              color: Color(0xFF68766D),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          _HeroActions(),
          const SizedBox(height: 32),
          _TrustBar(),
        ],
      ),
    );
  }
}

/// Primary action buttons in the hero.
class _HeroActions extends StatelessWidget {
  const _HeroActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Become a volunteer',
            onPressed: () => context.go('/account/register'),
            icon: Icons.person_add,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Explore programs',
            onPressed: () => context.go('/workspace'),
            icon: Icons.event_available,
            isOutlined: true,
          ),
        ),
      ],
    );
  }
}

/// Trust indicators: active volunteers, service hours, engagement.
class _TrustBar extends StatelessWidget {
  const _TrustBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TrustItem(
            label: 'Active volunteers',
            value: '1,248',
            subtitle: 'Serving across CMU',
          ),
        ),
        Expanded(
          child: _TrustItem(
            label: 'Service hours',
            value: '38K+',
            subtitle: 'Since 2022',
          ),
        ),
        Expanded(
          child: _TrustItem(
            label: 'Volunteer engagement',
            value: '87%',
            subtitle: 'Participation rate',
          ),
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final String label;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E6DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF134F35),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17231C),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF748078)),
          ),
        ],
      ),
    );
  }
}

/// Mission / purpose section.
class _MissionSection extends StatelessWidget {
  const _MissionSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.explore_outlined,
        'Discover your purpose',
        'Find service opportunities aligned with your skills, interests, and community priorities.',
      ),
      (
        Icons.groups_outlined,
        'Serve together',
        'Collaborate across colleges and units through organized, high-impact volunteer programs.',
      ),
      (
        Icons.insights_outlined,
        'See your impact',
        'Track attendance, service hours, milestones, and the difference your contribution creates.',
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

/// Programs section showing service areas.
class _ProgramsSection extends StatelessWidget {
  const _ProgramsSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        'Environment',
        const Color(0xFF196142),
        '12 active programs',
        'Restore what sustains us.',
        'Watershed, campus greening, and community clean-up initiatives.',
        Icons.eco_outlined,
      ),
      (
        'Safety',
        const Color(0xFF196142),
        '8 active programs',
        'Build a culture of readiness.',
        'Training, preparedness drills, and resilient community support.',
        Icons.shield_outlined,
      ),
      (
        'Community',
        const Color(0xFFD5A52F),
        '17 active programs',
        'Extend care beyond campus.',
        'Education, outreach, relief, and civic engagement programs.',
        Icons.people_outlined,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROGRAMS',
                style: TextStyle(
                  color: Color(0xFFAA7C10),
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppButton(
                label: 'View all opportunities',
                onPressed: () => context.go('/activities'),
                icon: Icons.event_available,
                isOutlined: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'There is a place for every kind of service.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 16),
          for (final item in items)
            _ProgramCard(
              title: item.$1,
              tint: item.$2,
              programCount: item.$3,
              heading: item.$4,
              description: item.$5,
              icon: item.$6,
              onTap: () => context.go('/activities'),
            ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.title,
    required this.tint,
    required this.programCount,
    required this.heading,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Color tint;
  final String programCount;
  final String heading;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tint, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          programCount,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF748078),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      heading,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17231C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF68766D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFADB5AF)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Safety features section.
class _SafetySection extends StatelessWidget {
  const _SafetySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
      color: const Color(0xFFF3F5F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF134F35),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'POWERED BY ODRRM READINESS',
                      style: TextStyle(
                        color: Color(0xFFAA7C10),
                        fontSize: 10,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Service, with safety at the center.',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Access verified emergency contacts, submit safety reports, '
                      'receive campus advisories, and connect with designated responders.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Color(0xFF68766D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Access the safety center',
              onPressed: () => context.go('/emergency'),
              icon: Icons.shield,
            ),
          ),
        ],
      ),
    );
  }
}

/// Final call-to-action section.
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C402B), Color(0xFF176043)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.eco_outlined, size: 110, color: Color(0x33FFFFFF)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'START SERVING TODAY',
            style: TextStyle(
              color: Color(0xFFE1B747),
              fontSize: 9,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Your time can change someone\'s tomorrow.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Join the CMU SBNu volunteer network and turn your willingness '
            'to help into measurable impact.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Create your volunteer account',
              onPressed: () => context.go('/account/register'),
              icon: Icons.person_add,
            ),
          ),
        ],
      ),
    );
  }
}

/// Public footer with branding.
class _PublicFooter extends StatelessWidget {
  const _PublicFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E5DF))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/sbnu_app_icon.png',
                    semanticLabel: 'SBNU logo',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SBNu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'CMU VOLUNTEER CORPS',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 0.8,
                      color: Color(0xFF748078),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Service • Bayanihan • Nationalism • Unity',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF89948C),
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// A styled primary action button consistent with the SBNU brand.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: effectiveOnPressed,
        icon: icon != null ? Icon(icon, size: 18) : null,
        label: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          side: BorderSide(
            color: isDestructive
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: effectiveOnPressed,
      icon: icon != null ? Icon(icon, size: 18) : null,
      label: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: isDestructive
            ? Theme.of(context).colorScheme.error
            : null,
        foregroundColor: isDestructive ? Colors.white : null,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
