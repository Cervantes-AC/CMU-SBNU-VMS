import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/organization.dart';
import '../view_models/organizations_view_model.dart';

/// Organizations page - directory of units.
class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Organizations')),
          body: AppStateWrapper(
            status: viewModel.status,
            onRetry: viewModel.init,
            errorMessage: viewModel.error?.message,
            child: viewModel.organizations.isEmpty
                ? const AppEmptyState(
                    icon: Icons.groups_outlined,
                    title: 'No organizations available.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.organizations.length,
                    itemBuilder: (context, index) {
                      final org = viewModel.organizations[index];
                      return _OrgCard(
                        organization: org,
                        onTap: () => viewModel.select(org),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateDialog(context, viewModel),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showCreateDialog(
    BuildContext context,
    OrganizationsViewModel viewModel,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Organization'),
        content: AppInputField(
          controller: controller,
          label: 'Organization name',
          hint: 'e.g. College of Engineering Unit',
          icon: Icons.groups_outlined,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Create',
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.of(context).pop();
              viewModel.createOrganization(
                Organization(
                  id: 'org_${DateTime.now().millisecondsSinceEpoch}',
                  name: controller.text.trim(),
                  status: 'active',
                  coordinatorUids: [],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrgCard extends StatelessWidget {
  const _OrgCard({required this.organization, required this.onTap});

  final Organization organization;
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups_outlined,
                  color: Color(0xFF134F35),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17231C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      organization.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        color: organization.isActive
                            ? const Color(0xFF196142)
                            : const Color(0xFFB63D34),
                        fontWeight: FontWeight.w700,
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
