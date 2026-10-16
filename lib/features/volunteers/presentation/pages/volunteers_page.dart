import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/features/organizations/presentation/pages/organizations_page.dart';
import 'package:cmu_sbnu_vms/features/volunteers/data/models/volunteer_preview.dart';
import 'package:cmu_sbnu_vms/features/volunteers/presentation/view_models/volunteers_view_model.dart';

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  State<VolunteersPage> createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  bool _showOrganizations = false;

  Future<void> _showVolunteerDetails(
    VolunteerPreview volunteer,
  ) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(volunteer.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(Icons.account_balance_outlined, volunteer.college),
          const SizedBox(height: 10),
          _DetailRow(Icons.schedule_outlined, volunteer.serviceHoursLabel),
          const SizedBox(height: 14),
          const Text(
            'Fictional preview profile. Account status, contact details, membership records, and attendance history are not connected.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: Color(0xFF748078),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Consumer<VolunteersViewModel>(
    builder: (context, viewModel, _) => ListView(
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
          const OrganizationsPage(),
        ] else ...[
          TextField(
            onChanged: viewModel.setQuery,
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
          DropdownButtonFormField<String>(
            initialValue: viewModel.college,
            decoration: const InputDecoration(
              labelText: 'College or unit',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: 'All colleges',
                child: Text('All colleges'),
              ),
              for (final college in viewModel.colleges)
                DropdownMenuItem(value: college, child: Text(college)),
            ],
            onChanged: (value) {
              if (value != null) viewModel.setCollege(value);
            },
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
          if (viewModel.filteredVolunteers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(28),
              child: Text(
                'No sample volunteers match your search.',
                textAlign: TextAlign.center,
              ),
            ),
          for (final volunteer in viewModel.filteredVolunteers)
            Card(
              margin: const EdgeInsets.only(bottom: 9),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                leading: CircleAvatar(
                  backgroundColor: Color(volunteer.accentColorValue),
                  child: Text(
                    volunteer.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  volunteer.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  volunteer.college,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  volunteer.serviceHoursLabel,
                  style: const TextStyle(
                    color: Color(0xFF315E43),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                onTap: () => _showVolunteerDetails(volunteer),
              ),
            ),
        ],
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: const Color(0xFF47745A)),
      const SizedBox(width: 9),
      Expanded(child: Text(label)),
    ],
  );
}
