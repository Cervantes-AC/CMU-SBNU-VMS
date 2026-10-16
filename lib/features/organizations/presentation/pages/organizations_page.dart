import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/organizations_repository.dart';
import '../../data/models/organization.dart';
import '../view_models/organizations_view_model.dart';

/// Organizations page — premium, fully functional.
class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PageHeader()),
          Consumer<OrganizationsViewModel>(
            builder: (context, viewModel, _) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: DesignTokens.lg),
                    AppStateWrapper(
                      status: viewModel.status,
                      onRetry: viewModel.init,
                      errorMessage: viewModel.error?.message,
                      child: viewModel.organizations.isEmpty
                          ? const PremiumEmptyState(
                              icon: Icons.groups_outlined,
                              title: 'No organizations available.',
                            )
                          : Padding(
                              padding: const EdgeInsets.all(DesignTokens.lg),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
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
                    ),
                    const SizedBox(height: DesignTokens.xxl),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(DesignTokens.lg),
        child: PremiumButton(
          label: 'Create Organization',
          onPressed: () => _showCreateDialog(context),
          icon: Icons.add_circle_rounded,
          isFullWidth: false,
          variant: ButtonVariant.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PremiumCard(
          elevation: 3,
          borderRadius: DesignTokens.radiusXl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(DesignTokens.lg),
                  child: Text(
                    'Create Organization',
                    style: DesignTokens.headline,
                  ),
                ),
                PremiumDivider(),
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PremiumInputField(
                        controller: controller,
                        label: 'Organization name',
                        hint: 'e.g. College of Engineering Unit',
                        icon: Icons.groups_rounded,
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumButton(
                              label: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                              variant: ButtonVariant.outline,
                              isFullWidth: true,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.md),
                          Expanded(
                            child: PremiumButton(
                              label: 'Create',
                              onPressed: () {
                                if (controller.text.trim().isEmpty) return;
                                Navigator.of(context).pop();
                                context
                                    .read<OrganizationsViewModel>()
                                    .createOrganization(
                                      Organization(
                                        id: 'org_${DateTime.now().millisecondsSinceEpoch}',
                                        name: controller.text.trim(),
                                        status: 'active',
                                        coordinatorUids: [],
                                      ),
                                    );
                              },
                              variant: ButtonVariant.primary,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.lg,
        DesignTokens.xl,
        DesignTokens.lg,
        DesignTokens.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organizations',
            style: DesignTokens.displayLarge.copyWith(
              fontSize: 36,
              color: DesignTokens.ink,
            ),
          ),
          const SizedBox(height: DesignTokens.sm),
          Text(
            'Explore CMU units and their volunteer coordinators.',
            style: DesignTokens.body.copyWith(
              fontSize: 15,
              color: DesignTokens.muted,
            ),
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
    final isActive = organization.isActive;
    final statusColor = isActive ? DesignTokens.success : DesignTokens.error;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.md),
      child: PremiumCard(
        elevation: 2,
        borderRadius: DesignTokens.radiusXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignTokens.radiusXl,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: DesignTokens.canvas,
                    borderRadius: DesignTokens.radiusXl,
                    boxShadow: DesignTokens.shadowSoft(
                      blur: 8,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      organization.name.isNotEmpty
                          ? organization.name.substring(0, 1).toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.forest,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name,
                        style: DesignTokens.title.copyWith(
                          fontSize: 16,
                          color: DesignTokens.ink,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.xs / 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              organization.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.md),
                          Text(
                            '${organization.coordinatorUids.length} coordinator(s)',
                            style: DesignTokens.caption.copyWith(
                              color: DesignTokens.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: DesignTokens.card3D(
                    color: DesignTokens.canvas,
                    shadowLevel: 1,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: DesignTokens.muted,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
