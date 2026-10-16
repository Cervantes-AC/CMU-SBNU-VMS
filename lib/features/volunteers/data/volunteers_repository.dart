import 'models/volunteer_preview.dart';

abstract interface class VolunteersRepository {
  List<VolunteerPreview> get volunteers;
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

  @override
  List<VolunteerPreview> get volunteers => _volunteers;
}
