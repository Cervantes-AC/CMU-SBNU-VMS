class VolunteerPreview {
  const VolunteerPreview({
    required this.initials,
    required this.name,
    required this.college,
    required this.serviceHoursLabel,
    required this.accentColorValue,
  });

  final String initials;
  final String name;
  final String college;
  final String serviceHoursLabel;
  final int accentColorValue;
}

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
