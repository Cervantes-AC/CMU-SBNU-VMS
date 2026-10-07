import 'package:flutter/material.dart';

/// Unbranded, static landing-page concept for local development.
///
/// This preview does not represent approved public copy. It loads no remote or
/// member data and intentionally has no sign-in, contact, or external-link
/// actions. Keep it local until the landing-page decision gates are approved.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const _ink = Color(0xFF1C2B2A);
  static const _mutedInk = Color(0xFF53615D);
  static const _canvas = Color(0xFFF5F7F1);
  static const _green = Color(0xFF245B4B);
  static const _mint = Color(0xFFDCEBE1);
  static const _line = Color(0xFFDCE3DC);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _canvas,
      body: SelectionArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final horizontalPadding = constraints.maxWidth >= 1200
                ? 48.0
                : constraints.maxWidth >= 700
                ? 32.0
                : 20.0;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            _PreviewHeader(
                              ink: _ink,
                              green: _green,
                              line: _line,
                            ),
                            const SizedBox(height: 28),
                            _PreviewNotice(
                              green: _green,
                              mint: _mint,
                              ink: _ink,
                            ),
                            const SizedBox(height: 36),
                            if (wide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 11,
                                    child: _HeroCopy(
                                      textTheme: textTheme,
                                      ink: _ink,
                                      mutedInk: _mutedInk,
                                      green: _green,
                                    ),
                                  ),
                                  const SizedBox(width: 56),
                                  const Expanded(
                                    flex: 9,
                                    child: _WorkspaceConcept(
                                      ink: _ink,
                                      mutedInk: _mutedInk,
                                      green: _green,
                                      mint: _mint,
                                      line: _line,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _HeroCopy(
                                    textTheme: textTheme,
                                    ink: _ink,
                                    mutedInk: _mutedInk,
                                    green: _green,
                                  ),
                                  const SizedBox(height: 32),
                                  const _WorkspaceConcept(
                                    ink: _ink,
                                    mutedInk: _mutedInk,
                                    green: _green,
                                    mint: _mint,
                                    line: _line,
                                  ),
                                ],
                              ),
                            const SizedBox(height: 64),
                            Semantics(
                              header: true,
                              child: Text(
                                'A considered starting point',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: _ink,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.7,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 620),
                              child: Text(
                                'These are concept areas for the future product. '
                                'They are shown here as design placeholders and '
                                'are not working services.',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: _mutedInk,
                                  height: 1.55,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            LayoutBuilder(
                              builder: (context, cardConstraints) {
                                final columns = cardConstraints.maxWidth >= 820
                                    ? 3
                                    : cardConstraints.maxWidth >= 560
                                    ? 2
                                    : 1;
                                const gap = 14.0;
                                final cardWidth =
                                    (cardConstraints.maxWidth -
                                        gap * (columns - 1)) /
                                    columns;

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: [
                                    SizedBox(
                                      width: cardWidth,
                                      child: const _ConceptCard(
                                        icon: Icons.event_available_rounded,
                                        title: 'Events',
                                        description:
                                            'A planned space for event details '
                                            'and participation.',
                                        ink: _ink,
                                        mutedInk: _mutedInk,
                                        green: _green,
                                        mint: _mint,
                                        line: _line,
                                      ),
                                    ),
                                    SizedBox(
                                      width: cardWidth,
                                      child: const _ConceptCard(
                                        icon: Icons.campaign_rounded,
                                        title: 'Unit updates',
                                        description:
                                            'A planned place for approved '
                                            'announcements and notices.',
                                        ink: _ink,
                                        mutedInk: _mutedInk,
                                        green: _green,
                                        mint: _mint,
                                        line: _line,
                                      ),
                                    ),
                                    SizedBox(
                                      width: cardWidth,
                                      child: const _ConceptCard(
                                        icon: Icons.fact_check_rounded,
                                        title: 'Participation records',
                                        description:
                                            'A planned view of attendance and '
                                            'service summaries.',
                                        ink: _ink,
                                        mutedInk: _mutedInk,
                                        green: _green,
                                        mint: _mint,
                                        line: _line,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 48),
                            const Divider(color: _line, height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    'Local concept preview · no account or records loaded',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: _mutedInk,
                                    ),
                                  ),
                                  Text(
                                    'Public logo use and release are pending approval.',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: _mutedInk,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({
    required this.ink,
    required this.green,
    required this.line,
  });

  final Color ink;
  final Color green;
  final Color line;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        _LogoMark(
          assetPath: 'assets/images/cmu_logo.png',
          semanticLabel: 'Central Mindanao University logo',
          line: line,
        ),
        const SizedBox(width: 8),
        _LogoMark(
          assetPath: 'assets/images/SBNU LOGO.png',
          semanticLabel: 'School-Based National Service Reserve Corps logo',
          line: line,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Volunteer workspace',
            style: textTheme.titleMedium?.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'PREVIEW',
            style: textTheme.labelSmall?.copyWith(
              color: green,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({
    required this.assetPath,
    required this.semanticLabel,
    required this.line,
  });

  final String assetPath;
  final String semanticLabel;
  final Color line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

class _PreviewNotice extends StatelessWidget {
  const _PreviewNotice({
    required this.green,
    required this.mint,
    required this.ink,
  });

  final Color green;
  final Color mint;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: mint.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Concept only. Sign-in, member records, and public services are not connected.',
              style: textTheme.bodyMedium?.copyWith(
                color: ink,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.textTheme,
    required this.ink,
    required this.mutedInk,
    required this.green,
  });

  final TextTheme textTheme;
  final Color ink;
  final Color mutedInk;
  final Color green;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A LOCAL DESIGN PREVIEW',
          style: textTheme.labelLarge?.copyWith(
            color: green,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(
            'A clearer view of volunteer work.',
            style: textTheme.displaySmall?.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.8,
              height: 1.06,
            ),
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 530),
          child: Text(
            'This static concept explores how a future volunteer operations '
            'workspace could bring common activities into one calm, easy-to-use place.',
            style: textTheme.titleMedium?.copyWith(
              color: mutedInk,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: green, size: 19),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No personal data or Firebase records are used in this page.',
                style: textTheme.bodyMedium?.copyWith(
                  color: ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkspaceConcept extends StatelessWidget {
  const _WorkspaceConcept({
    required this.ink,
    required this.mutedInk,
    required this.green,
    required this.mint,
    required this.line,
  });

  final Color ink;
  final Color mutedInk;
  final Color green;
  final Color mint;
  final Color line;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x101C2B2A),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Workspace concept',
                  style: textTheme.titleLarge?.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.more_horiz_rounded, color: mutedInk),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.calendar_month_rounded, color: green),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming activity',
                        style: textTheme.titleSmall?.copyWith(
                          color: ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Sample layout · no event data',
                        style: textTheme.bodySmall?.copyWith(color: mutedInk),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PreviewTile(
                  label: 'Updates',
                  icon: Icons.campaign_outlined,
                  ink: ink,
                  mutedInk: mutedInk,
                  line: line,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PreviewTile(
                  label: 'Participation',
                  icon: Icons.groups_2_outlined,
                  ink: ink,
                  mutedInk: mutedInk,
                  line: line,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'All cards above are non-interactive design samples.',
            style: textTheme.bodySmall?.copyWith(
              color: mutedInk,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.label,
    required this.icon,
    required this.ink,
    required this.mutedInk,
    required this.line,
  });

  final String label;
  final IconData icon;
  final Color ink;
  final Color mutedInk;
  final Color line;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: mutedInk, size: 20),
          const SizedBox(height: 12),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Concept',
            style: textTheme.bodySmall?.copyWith(color: mutedInk),
          ),
        ],
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.ink,
    required this.mutedInk,
    required this.green,
    required this.mint,
    required this.line,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color ink;
  final Color mutedInk;
  final Color green;
  final Color mint;
  final Color line;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 188),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: mint,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: green, size: 21),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(color: mutedInk, height: 1.5),
          ),
          const SizedBox(height: 14),
          Text(
            'PLANNED',
            style: textTheme.labelSmall?.copyWith(
              color: green,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
