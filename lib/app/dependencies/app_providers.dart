import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../features/activities/data/activities_repository.dart';
import '../../features/activities/presentation/view_models/activities_view_model.dart';
import '../../features/announcements/data/announcements_repository.dart';
import '../../features/announcements/presentation/view_models/announcements_view_model.dart';
import '../../features/attendance/data/attendance_repository.dart';
import '../../features/attendance/presentation/view_models/attendance_view_model.dart';
import '../../features/audit/data/audit_repository.dart';
import '../../features/audit/presentation/view_models/audit_view_model.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/sources/auth_remote_source.dart';
import '../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../features/hotlines/data/hotlines_repository.dart';
import '../../features/hotlines/presentation/view_models/hotlines_view_model.dart';
import '../../features/incidents/data/incidents_repository.dart';
import '../../features/incidents/presentation/view_models/incidents_view_model.dart';
import '../../features/organizations/data/organizations_repository.dart';
import '../../features/organizations/presentation/view_models/organizations_view_model.dart';
import '../../features/overview/data/overview_repository.dart';
import '../../features/overview/presentation/view_models/overview_view_model.dart';
import '../../features/reporting/data/reports_repository.dart';
import '../../features/reporting/presentation/view_models/reports_view_model.dart';
import '../../features/sos/data/sos_repository.dart';
import '../../features/sos/presentation/view_models/sos_view_model.dart';
import '../../features/volunteers/data/volunteers_repository.dart';
import '../../features/volunteers/presentation/view_models/volunteers_view_model.dart';

import '../../../core/logging/app_logger.dart';

Widget withAppProviders({required Widget child}) {
  final logger = ConsoleAppLogger();

  // Repositories
  final authRepository = FirebaseAuthRepository(
    remoteSource: AuthRemoteSource(),
    logger: logger,
  );
  final activitiesRepository = createActivitiesRepository(
    useFirestore: false,
    logger: logger,
  );
  final announcementsRepository = createAnnouncementsRepository(
    useFirestore: false,
    logger: logger,
  );
  final attendanceRepository = createAttendanceRepository(
    useFirestore: false,
    logger: logger,
  );
  final auditRepository = createAuditRepository(
    useFirestore: false,
    logger: logger,
  );
  final hotlinesRepository = createHotlinesRepository(
    useFirestore: false,
    logger: logger,
  );
  final incidentsRepository = createIncidentsRepository(
    useFirestore: false,
    logger: logger,
  );
  final organizationsRepository = createOrganizationsRepository(
    useFirestore: false,
    logger: logger,
  );
  final overviewRepository = createOverviewRepository();
  final reportsRepository = createReportsRepository(
    useFirestore: false,
    logger: logger,
  );
  final sosRepository = createSosRepository(
    useFirestore: false,
    logger: logger,
  );
  final volunteersRepository = createVolunteersRepository(
    useFirestore: false,
    logger: logger,
  );

  return MultiProvider(
    providers: [
      // Cross-cutting
      Provider<AppLogger>.value(value: logger),

      // Repositories
      Provider<AuthRepository>.value(value: authRepository),
      Provider<ActivitiesRepository>.value(value: activitiesRepository),
      Provider<AnnouncementsRepository>.value(value: announcementsRepository),
      Provider<AttendanceRepository>.value(value: attendanceRepository),
      Provider<AuditRepository>.value(value: auditRepository),
      Provider<HotlinesRepository>.value(value: hotlinesRepository),
      Provider<IncidentsRepository>.value(value: incidentsRepository),
      Provider<OrganizationsRepository>.value(value: organizationsRepository),
      Provider<OverviewRepository>.value(value: overviewRepository),
      Provider<ReportsRepository>.value(value: reportsRepository),
      Provider<SosRepository>.value(value: sosRepository),
      Provider<VolunteersRepository>.value(value: volunteersRepository),

      // ViewModels
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(repository: authRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createActivitiesViewModel(activitiesRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) =>
            createAnnouncementsViewModel(announcementsRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createAttendanceViewModel(attendanceRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createAuditViewModel(auditRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createHotlinesViewModel(hotlinesRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createIncidentsViewModel(incidentsRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) =>
            createOrganizationsViewModel(organizationsRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createOverviewViewModel(overviewRepository),
      ),
      ChangeNotifierProvider(
        create: (_) => createReportsViewModel(reportsRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createSosViewModel(sosRepository)..init(),
      ),
      ChangeNotifierProvider(
        create: (_) => createVolunteersViewModel(volunteersRepository)..init(),
      ),
    ],
    child: child,
  );
}
