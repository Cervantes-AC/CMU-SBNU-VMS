enum OrganizationKind { agriculture, engineering, forestry, nursing }

class OrganizationPreview {
  const OrganizationPreview({
    required this.name,
    required this.description,
    required this.kind,
  });

  final String name;
  final String description;
  final OrganizationKind kind;
}
