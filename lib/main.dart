import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'firebase_options.dart';

const _useFirebaseEmulators = bool.fromEnvironment(
  'USE_FIREBASE_EMULATORS',
  defaultValue: false,
);
const _firebaseEmulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: 'localhost',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (_useFirebaseEmulators) {
      await _connectFirebaseEmulators();
    }
  } on UnsupportedError {
    // Keep the local preview available on platforms without Firebase options.
  } catch (_) {
    // Firebase setup is not required to browse the synthetic local preview.
  }

  runApp(const NSRCApp());
}

Future<void> _connectFirebaseEmulators() async {
  // Services are only instantiated in explicit emulator mode. The app does
  // not read or write Firebase data until feature repositories are connected.
  await _initializeEmulatorServices();
}

Future<void> _initializeEmulatorServices() async {
  final auth = FirebaseAuth.instance;
  await auth.useAuthEmulator(_firebaseEmulatorHost, 9099);

  final firestore = FirebaseFirestore.instance;
  firestore.useFirestoreEmulator(_firebaseEmulatorHost, 8080);
}
