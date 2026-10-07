import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';

/// Low-level Firestore adapter.
///
/// Owns the injected [FirebaseFirestore] instance, emulator configuration,
/// and typed path helpers. Deliberately does NOT expose a generic
/// read/write-any-collection API — repositories receive narrow references.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Underlying instance for narrow repository use.
  FirebaseFirestore get instance => _firestore;

  /// Connects Firestore to the local emulator. Only call in development
  /// (see main.dart bootstrap, gated by USE_FIREBASE_EMULATORS).
  void configureEmulator({String host = 'localhost', int port = 8080}) {
    _firestore.useFirestoreEmulator(host, port);
    // Emulator-backed development disables disk persistence so local state
    // cannot leak between sessions.
    _firestore.settings = const Settings(persistenceEnabled: false);
  }

  /// Typed path helper for the current user's profile document.
  DocumentReference<Map<String, dynamic>> userDocument(String uid) {
    if (!FirestorePaths.isValidDocId(uid)) {
      throw ArgumentError.value(uid, 'uid', 'Invalid document ID');
    }
    return _firestore.doc(FirestorePaths.userDoc(uid));
  }

  /// Typed reference to the users collection (for authorized queries).
  CollectionReference<Map<String, dynamic>> usersCollection() =>
      _firestore.collection(FirestorePaths.users);

  /// Converts Firestore server timestamp fields safely.
  static DateTime? toUtc(Object? value) {
    if (value is Timestamp) return value.toDate().toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    return null;
  }

  /// Server timestamp sentinel for writes.
  static FieldValue serverTimestamp() => FieldValue.serverTimestamp();
}
