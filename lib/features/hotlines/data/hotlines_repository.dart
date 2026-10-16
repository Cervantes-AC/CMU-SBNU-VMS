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
      id: 'hl_maramag_pnp',
      label: 'Maramag PNP',
      phoneE164: '+639351256859',
      coverage: 'Maramag, Bukidnon · PNP',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_maramag_mdrrmo',
      label: 'Maramag MDRRMO',
      phoneE164: '+639667682770',
      coverage: 'Maramag, Bukidnon · MDRRMO',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_maramag_bfp',
      label: 'Maramag BFP',
      phoneE164: '+639175163291',
      coverage: 'Maramag, Bukidnon · BFP',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_maramag_health',
      label: 'Maramag Health',
      phoneE164: '+639660422004',
      coverage: 'Maramag, Bukidnon · Health',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_cmu_uh',
      label: 'CMU UH',
      phoneE164: '+639171005100',
      coverage: 'CMU Main Campus · University Hospital',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_cmu_crcyc',
      label: 'CMU CRCYC',
      phoneE164: '+639274049425',
      coverage: 'CMU Main Campus · CRCYC',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_cmu_odrrm',
      label: 'CMU ODRRM',
      phoneE164: '+639178083312',
      coverage: 'CMU Main Campus · ODRRM',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
      active: false,
    ),
    HotlineEntry(
      id: 'hl_dologon_bdrrm',
      label: 'Dologon BDRRM',
      phoneE164: '+639977904295',
      coverage: 'Dologon, Maramag · BDRRM',
      hours: 'To be confirmed',
      verificationState: 'pendingVerification',
      verifiedBy: '',
      verifiedAt: DateTime.now(),
      reviewDueAt: DateTime.now().add(const Duration(days: 365)),
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
  Stream<List<HotlineEntry>> get hotlines => _hotlines.snapshots().map(
    (s) => s.docs.map((d) => _fromFirestore(d)).toList(),
  );

  @override
  Stream<List<HotlineEntry>> getVerifiedActiveHotlines() => _hotlines
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
