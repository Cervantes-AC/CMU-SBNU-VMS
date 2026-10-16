import 'models/volunteer_preview.dart';

abstract interface class VolunteersRepository {
  List<VolunteerPreview> get volunteers;
  List<OrganizationPreview> get organizations;
}

class PreviewVolunteersRepository implements VolunteersRepository {
  static const _volunteers = [
    VolunteerPreview(
      initials: 'MA',
      name: 'Mika Alvarez',
      college: 'College of Forestry',
      serviceHoursLabel: '32 hrs',
      accentColorValue: 0xFF155E3B,
    ),
    VolunteerPreview(
      initials: 'JR',
      name: 'Jon Reyes',
      college: 'College of Engineering',
      serviceHoursLabel: '28 hrs',
      accentColorValue: 0xFFB88318,
    ),
    VolunteerPreview(
      initials: 'CL',
      name: 'Cathy Lim',
      college: 'College of Nursing',
      serviceHoursLabel: '24 hrs',
      accentColorValue: 0xFF315E70,
    ),
    VolunteerPreview(
      initials: 'AS',
      name: 'Aira Santos',
      college: 'College of Arts & Sciences',
      serviceHoursLabel: '21 hrs',
      accentColorValue: 0xFF765341,
    ),
    VolunteerPreview(
      initials: 'DN',
      name: 'Daniel Navarro',
      college: 'College of Agriculture',
      serviceHoursLabel: '18 hrs',
      accentColorValue: 0xFF566231,
    ),
  ];

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
  List<VolunteerPreview> get volunteers => _volunteers;

  @override
  List<OrganizationPreview> get organizations => _organizations;
}
