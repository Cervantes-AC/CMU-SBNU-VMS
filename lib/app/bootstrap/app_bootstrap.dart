import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/performance/performance.dart';
import '../../firebase_options.dart';

/// When true, the app is allowed to talk to local Firebase emulators.
///
/// Emulators are only enabled when the build explicitly opts in via
/// `--dart-define=USE_FIREBASE_EMULATORS=true` AND the build is a debug
/// profile. Release builds never connect to emulators, even if the define is
/// present.
const bool _useFirebaseEmulators = bool.fromEnvironment(
  'USE_FIREBASE_EMULATORS',
  defaultValue: false,
);
const String _firebaseEmulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: 'localhost',
);

/// Whether emulator connections are permitted in this build.
bool get _emulatorsAllowed {
  assert(() {
    // In debug builds we allow the opt-in define.
    return true;
  }());
  return _useFirebaseEmulators && kDebugMode;
}

abstract final class AppBootstrap {
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      configureImageCache();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (_emulatorsAllowed) {
        await _connectFirebaseEmulators();
      }

      runApp(const NSRCApp());
    } catch (_) {
      runApp(const _StartupFailureApp());
    }
  }

  static Future<void> _connectFirebaseEmulators() async {
    await FirebaseAuth.instance.useAuthEmulator(_firebaseEmulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(
      _firebaseEmulatorHost,
      8080,
    );
  }
}

class _StartupFailureApp extends StatelessWidget {
  const _StartupFailureApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 44),
                const SizedBox(height: 16),
                Text(
                  'The app could not connect to its configured services.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check the Firebase configuration and network, then restart the app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
