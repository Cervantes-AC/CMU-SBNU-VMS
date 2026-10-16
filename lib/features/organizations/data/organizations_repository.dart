import 'models/organization_preview.dart';

abstract interface class OrganizationsRepository {
  List<OrganizationPreview> get organizations;
}

class PreviewOrganizationsRepository implements OrganizationsRepository {
  static const _organizations = [
    OrganizationPreview(
      name: 'College of Agriculture',
      description: 'Environment and community programs',
      kind: OrganizationKind.agriculture,
    ),
    OrganizationPreview(
      name: 'College of Engineering',
      description: 'Preparedness and technical support',
      kind: OrganizationKind.engineering,
    ),
    OrganizationPreview(
      name: 'College of Forestry',
      description: 'Watershed and campus initiatives',
      kind: OrganizationKind.forestry,
    ),
    OrganizationPreview(
      name: 'College of Nursing',
      description: 'First aid and health preparedness',
      kind: OrganizationKind.nursing,
    ),
  ];

  @override
  List<OrganizationPreview> get organizations => _organizations;
}
