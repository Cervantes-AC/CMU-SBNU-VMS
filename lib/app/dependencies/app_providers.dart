import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../features/activities/data/activities_repository.dart';
import '../../features/activities/presentation/view_models/activities_view_model.dart';
import '../../features/announcements/data/announcements_repository.dart';
import '../../features/announcements/presentation/view_models/announcements_view_model.dart';
import '../../features/attendance/data/attendance_repository.dart';
import '../../features/attendance/presentation/view_models/attendance_view_model.dart';
import '../../features/audit/data/audit_preview_repository.dart';
import '../../features/audit/presentation/view_models/audit_preview_view_model.dart';
import '../../features/incidents/data/incidents_repository.dart';
import '../../features/incidents/presentation/view_models/incidents_view_model.dart';
import '../../features/organizations/data/organizations_repository.dart';
import '../../features/organizations/presentation/view_models/organizations_view_model.dart';
import '../../features/reporting/data/reports_repository.dart';
import '../../features/reporting/presentation/view_models/reports_view_model.dart';
import '../../features/volunteers/data/volunteers_repository.dart';
import '../../features/volunteers/presentation/view_models/volunteers_view_model.dart';

Widget withAppProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ActivitiesViewModel(PreviewActivitiesRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => AttendanceViewModel(PreviewAttendanceRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => AnnouncementsViewModel(PreviewAnnouncementsRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => IncidentsViewModel(PreviewIncidentsRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => VolunteersViewModel(PreviewVolunteersRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => OrganizationsViewModel(PreviewOrganizationsRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => ReportsViewModel(PreviewReportsRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => AuditPreviewViewModel(SampleAuditPreviewRepository()),
      ),
    ],
    child: child,
  );
}
