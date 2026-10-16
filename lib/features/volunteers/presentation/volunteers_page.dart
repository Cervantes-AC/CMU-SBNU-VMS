import 'package:flutter/material.dart';

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  State<VolunteersPage> createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  String _query = '';
  bool _showOrganizations = false;

  static const _volunteers = [
    ('MA', 'Mika Alvarez', 'College of Forestry', '32 hrs', Color(0xFF155E3B)),
    ('JR', 'Jon Reyes', 'College of Engineering', '28 hrs', Color(0xFFB88318)),
    ('CL', 'Cathy Lim', 'College of Nursing', '24 hrs', Color(0xFF315E70)),
    (
      'AS',
      'Aira Santos',
      'College of Arts & Sciences',
      '21 hrs',
      Color(0xFF765341),
    ),
    (
      'DN',
      'Daniel Navarro',
      'College of Agriculture',
      '18 hrs',
      Color(0xFF566231),
    ),
  ];

  static const _organizations = [
    (
      'College of Agriculture',
      'Environment and community programs',
      Icons.eco_outlined,
    ),
    (
      'College of Engineering',
      'Preparedness and technical support',
      Icons.engineering_outlined,
    ),
    (
      'College of Forestry',
      'Watershed and campus initiatives',
      Icons.forest_outlined,
    ),
    (
      'College of Nursing',
      'First aid and health preparedness',
      Icons.medical_services_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _volunteers
        .where(
          (volunteer) => '${volunteer.$2} ${volunteer.$3}'
              .toLowerCase()
              .contains(_query.toLowerCase()),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'People directory',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: const Color(0xFFAA7C10),
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Volunteers and organizations',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        const Text(
          'Browse a synthetic volunteer directory or illustrative organization list. Contact details and membership records are not included.',
          style: TextStyle(color: Color(0xFF748078), height: 1.4),
        ),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              label: Text('Volunteers'),
              icon: Icon(Icons.groups_outlined),
            ),
            ButtonSegment(
              value: true,
              label: Text('Organizations'),
              icon: Icon(Icons.account_tree_outlined),
            ),
          ],
          selected: {_showOrganizations},
          onSelectionChanged: (selection) =>
              setState(() => _showOrganizations = selection.first),
        ),
        const SizedBox(height: 14),
        if (_showOrganizations) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF0D7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Illustrative unit list · The approved organization hierarchy and coordinator assignments are not configured.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Color(0xFF6E581F),
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final organization in _organizations)
            Card(
              margin: const EdgeInsets.only(bottom: 9),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE5EFE7),
                  foregroundColor: const Color(0xFF196142),
                  child: Icon(organization.$3),
                ),
                title: Text(
                  organization.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(organization.$2),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
        ] else ...[
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search volunteers',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: Color(0xFFE1E6DF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: Color(0xFFE1E6DF)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF0D7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Synthetic directory · This preview contains fictional sample profiles.',
              style: TextStyle(fontSize: 11, color: Color(0xFF6E581F)),
            ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(28),
              child: Text(
                'No sample volunteers match your search.',
                textAlign: TextAlign.center,
              ),
            ),
          for (final volunteer in filtered)
            Card(
              margin: const EdgeInsets.only(bottom: 9),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                leading: CircleAvatar(
                  backgroundColor: volunteer.$5,
                  child: Text(
                    volunteer.$1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  volunteer.$2,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  volunteer.$3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  volunteer.$4,
                  style: const TextStyle(
                    color: Color(0xFF315E43),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
