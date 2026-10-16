import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/features/organizations/data/models/organization_preview.dart';
import 'package:cmu_sbnu_vms/features/organizations/presentation/view_models/organizations_view_model.dart';

class OrganizationsPage extends StatelessWidget {
  const OrganizationsPage({super.key});

  Future<void> _showDetails(
    BuildContext context,
    OrganizationPreview organization,
  ) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        _organizationIcon(organization.kind),
        color: const Color(0xFF196142),
      ),
      title: Text(organization.name),
      content: Text(
        '${organization.description}. This entry is illustrative; the approved unit hierarchy and coordinator assignments are not configured.',
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
  Widget build(BuildContext context) => Consumer<OrganizationsViewModel>(
    builder: (context, viewModel, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        for (final organization in viewModel.organizations)
          Card(
            margin: const EdgeInsets.only(bottom: 9),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE5EFE7),
                foregroundColor: const Color(0xFF196142),
                child: Icon(_organizationIcon(organization.kind)),
              ),
              title: Text(
                organization.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(organization.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDetails(context, organization),
            ),
          ),
      ],
    ),
  );
}

IconData _organizationIcon(OrganizationKind kind) => switch (kind) {
  OrganizationKind.agriculture => Icons.eco_outlined,
  OrganizationKind.engineering => Icons.engineering_outlined,
  OrganizationKind.forestry => Icons.forest_outlined,
  OrganizationKind.nursing => Icons.medical_services_outlined,
};
