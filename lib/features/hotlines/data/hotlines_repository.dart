import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/hotline_entry.dart';

/// Repository contract for hotlines.
abstract class HotlinesRepository {
  Stream<List<HotlineEntry>> get hotlines;
  Stream<List<HotlineEntry>> getVerifiedActiveHotlines();
  Future<AppResult<void>> verifyHotline(String id, String verifiedBy);
  Future<AppResult<void>> expireHotline(String id);
}

/// Preview implementation for development.
class PreviewHotlinesRepository implements HotlinesRepository {
  PreviewHotlinesRepository();

  final List<HotlineEntry> _hotlines = [
    HotlineEntry(
      id: 'hl_001',
      label: 'Campus Security',
      phoneE164: '+639170000001',
      coverage: 'CMU Main Campus',
      hours: '24/7',
      verificationState: 'verified',
      verifiedBy: 'admin_001',
      verifiedAt: DateTime(2026, 1, 15),
      reviewDueAt: DateTime(2027, 1, 15),
      active: true,
    ),
    HotlineEntry(
      id: 'hl_002',
      label: 'Barangay Emergency',
      phoneE164: '+639170000002',
      coverage: 'Barangay Partners',
      hours: '08:00-17:00',
      verificationState: 'verified',
      verifiedBy: 'admin_001',
      verifiedAt: DateTime(2026, 2, 1),
      reviewDueAt: DateTime(2027, 2, 1),
      active: true,
    ),
    HotlineEntry(
      id: 'hl_003',
      label: 'Expired Number',
      phoneE164: '+639170000003',
      coverage: 'Old Contact',
      hours: 'N/A',
      verificationState: 'expired',
      verifiedBy: 'admin_001',
      verifiedAt: DateTime(2024, 1, 1),
      reviewDueAt: DateTime(2025, 1, 1),
      active: false,
    ),
  ];

  @override
  Stream<List<HotlineEntry>> get hotlines => Stream.value(_hotlines);

  @override
  Stream<List<HotlineEntry>> getVerifiedActiveHotlines() =>
      Stream.value(_hotlines.where((h) => h.isVerified).toList());

  @override
  Future<AppResult<void>> verifyHotline(String id, String verifiedBy) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AppResult.data(null);
  }

  @override
  Future<AppResult<void>> expireHotline(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AppResult.data(null);
  }
}

/// Firestore-backed implementation.
class FirestoreHotlinesRepository implements HotlinesRepository {
  FirestoreHotlinesRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _hotlines =>
      _firestore.collection('hotlines');

  @override
  Stream<List<HotlineEntry>> get hotlines =>
      _hotlines.snapshots().map((s) => s.docs.map((d) => _fromFirestore(d)).toList());

  @override
  Stream<List<HotlineEntry>> getVerifiedActiveHotlines() =>
      _hotlines
          .where('verificationState', isEqualTo: 'verified')
          .where('active', isEqualTo: true)
          .snapshots()
          .map((s) => s.docs.map((d) => _fromFirestore(d)).toList());

  HotlineEntry _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HotlineEntry(
      id: doc.id,
      label: data['label'] as String? ?? '',
      phoneE164: data['phoneE164'] as String? ?? '',
      coverage: data['coverage'] as String? ?? '',
      hours: data['hours'] as String? ?? '',
      verificationState: data['verificationState'] as String? ?? 'draft',
      verifiedBy: data['verifiedBy'] as String? ?? '',
      verifiedAt: _parseTimestamp(data['verifiedAt']) ?? DateTime.now(),
      reviewDueAt: _parseTimestamp(data['reviewDueAt']) ?? DateTime.now(),
      active: data['active'] as bool? ?? false,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  @override
  Future<AppResult<void>> verifyHotline(String id, String verifiedBy) async {
    try {
      await _hotlines.doc(id).update({
        'verificationState': 'verified',
        'verifiedBy': verifiedBy,
        'verifiedAt': FieldValue.serverTimestamp(),
        'active': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('hotline.verify_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> expireHotline(String id) async {
    try {
      await _hotlines.doc(id).update({
        'verificationState': 'expired',
        'active': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('hotline.expire_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

HotlinesRepository createHotlinesRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreHotlinesRepository(firestore: firestore, logger: logger);
  }
  return PreviewHotlinesRepository();
}

HotlinesRepository hotlinesRepositoryOf(BuildContext context) {
  return Provider.of<HotlinesRepository>(context, listen: false);
}
