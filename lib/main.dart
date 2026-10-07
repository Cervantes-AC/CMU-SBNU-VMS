import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/cache/cache_service.dart';
import 'package:cmu_sbnu_vms/core/utils/logger.dart';
import 'package:cmu_sbnu_vms/data/repositories/announcement_repository.dart';
import 'package:cmu_sbnu_vms/data/repositories/attendance_repository.dart';
import 'package:cmu_sbnu_vms/data/repositories/auth_repository.dart';
import 'package:cmu_sbnu_vms/data/repositories/event_repository.dart';
import 'package:cmu_sbnu_vms/data/repositories/user_repository.dart';
import 'package:cmu_sbnu_vms/data/services/auth_service.dart';
import 'package:cmu_sbnu_vms/data/services/firestore_service.dart';
import 'package:cmu_sbnu_vms/firebase_options.dart';

/// Target Firebase project identity (D-04). Startup fails closed if the
/// generated options point anywhere else.
const _targetProjectId = 'cmu-sbnu-vms';

/// Local emulator usage is opt-in: `flutter run --dart-define=USE_FIREBASE_EMULATORS=true`.
const _useEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
const _emulatorHost =
    String.fromEnvironment('FIREBASE_EMULATOR_HOST', defaultValue: 'localhost');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _installErrorHandlers();

  runApp(const _StartupScreen());

  try {
    await _bootstrapFirebase();
  } catch (error) {
    // Safe startup failure: log category only (never payloads), then stop
    // before any protected feature can render.
    Logger.error('bootstrap.firebase', error);
    runApp(_StartupErrorScreen(onRetry: main));
    return;
  }

  final firestoreService = FirestoreService();
  final authService = AuthService();
  if (_useEmulators) {
    authService.configureEmulator(host: _emulatorHost);
    firestoreService.configureEmulator(host: _emulatorHost);
    Logger.info('bootstrap.emulators', fields: {'host': _emulatorHost});
  }

  final cacheService = CacheService();
  await cacheService.initialize();

  runApp(NSRCApp(
    authRepository: AuthRepositoryImpl(
      authService: authService,
      firestoreService: firestoreService,
      cacheService: cacheService,
    ),
    userRepository: UserRepositoryImpl(
      firestoreService: firestoreService,
      cacheService: cacheService,
    ),
    eventRepository: EventRepositoryImpl(
      firestoreService: firestoreService,
      currentUid: authService.currentUid,
    ),
    announcementRepository: AnnouncementRepositoryImpl(
      firestoreService: firestoreService,
      currentUid: authService.currentUid,
    ),
    attendanceRepository: AttendanceRepositoryImpl(
      firestoreService: firestoreService,
      currentUid: authService.currentUid,
    ),
    cacheService: cacheService,
  ));
}

Future<void> _bootstrapFirebase() async {
  final options = DefaultFirebaseOptions.currentPlatform;

  // Validate target identity: never fall through to another project.
  if (options.projectId != _targetProjectId) {
    throw StateError(
        'Firebase project ${options.projectId} does not match target $_targetProjectId');
  }

  await Firebase.initializeApp(options: options);
}

void _installErrorHandlers() {
  FlutterError.onError = (details) {
    // details.exception may carry user input; log the safe operation name only.
    Logger.error('flutter.error', details.exception.runtimeType);
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    Logger.error('platform.dispatcher', error);
    return true; // Prevent silent crashes from bypassing the safe screen.
  };
}

/// Minimal first-frame screen shown while Firebase bootstraps.
class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

/// Safe, recoverable startup-error screen. Shows no technical details,
/// tokens, or configuration — only a neutral explanation and retry.
class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF245B4B))),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 40),
                    const SizedBox(height: 18),
                    Text(
                      'We couldn’t start the app',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The app couldn’t reach its required configuration. '
                      'Check your connection and try again. If the problem '
                      'continues, contact your unit administrator.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => onRetry(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
