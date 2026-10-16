import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/volunteer.dart';

/// Repository contract for volunteers.
abstract class VolunteersRepository {
  Stream<List<VolunteerProfile>> get volunteers;
  Stream<VolunteerProfile?> getVolunteerByUid(String uid);
  Stream<List<VolunteerProfile>> getVolunteersByOrganization(String orgId);
  Future<AppResult<VolunteerProfile>> createOrUpdateProfile(VolunteerProfile profile);
  Future<AppResult<void>> updateProfileField(String uid, String field, dynamic value);
}

/// Preview implementation for development.
class PreviewVolunteersRepository implements VolunteersRepository {
  PreviewVolunteersRepository();

  final List<VolunteerProfile> _volunteers = [
    VolunteerProfile(
      uid: 'vol_001',
      fullName: 'Maria Santos',
      email: 'maria.santos@cmu.edu.ph',
      college: 'College of Arts and Sciences',
      course: 'Biology',
      studentId: '2023-001',
      status: 'active',
    ),
    VolunteerProfile(
      uid: 'vol_002',
      fullName: 'Carlos Reyes',
      email: 'carlos.reyes@cmu.edu.ph',
      college: 'College of Engineering',
      course: 'Civil Engineering',
      studentId: '2023-045',
      status: 'active',
    ),
    VolunteerProfile(
      uid: 'vol_003',
      fullName: 'Ana Lopez',
      email: 'ana.lopez@cmu.edu.ph',
      college: 'College of Nursing',
      course: 'Nursing',
      studentId: '2023-102',
      status: 'pending',
    ),
  ];

  @override
  Stream<List<VolunteerProfile>> get volunteers => Stream.value(_volunteers);

  @override
  Stream<VolunteerProfile?> getVolunteerByUid(String uid) =>
      Stream.value(_volunteers.firstWhere((v) => v.uid == uid, orElse: () => _volunteers.first));

  @override
  Stream<List<VolunteerProfile>> getVolunteersByOrganization(String orgId) =>
      Stream.value(_volunteers.where((v) => v.organizationIds.contains(orgId)).toList());

  @override
  Future<AppResult<VolunteerProfile>> createOrUpdateProfile(VolunteerProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _volunteers.indexWhere((v) => v.uid == profile.uid);
    if (idx >= 0) {
      _volunteers[idx] = profile;
    } else {
      _volunteers.add(profile);
    }
    return AppResult.data(profile);
  }

  @override
  Future<AppResult<void>> updateProfileField(String uid, String field, dynamic value) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AppResult.data(null);
  }
}

/// Firestore-backed implementation.
class FirestoreVolunteersRepository implements VolunteersRepository {
  FirestoreVolunteersRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _vols => _firestore.collection('volunteers');

  @override
  Stream<List<VolunteerProfile>> get volunteers =>
      _vols.snapshots().map((s) => s.docs.map((d) => VolunteerProfile.fromFirestore(d)).toList());

  @override
  Stream<VolunteerProfile?> getVolunteerByUid(String uid) =>
      _vols.doc(uid).snapshots().map((doc) {
        if (!doc.exists) return null;
        return VolunteerProfile.fromFirestore(doc);
      });

  @override
  Stream<List<VolunteerProfile>> getVolunteersByOrganization(String orgId) =>
      _vols.where('organizationIds', arrayContains: orgId).snapshots().map(
        (s) => s.docs.map((d) => VolunteerProfile.fromFirestore(d)).toList(),
      );

  @override
  Future<AppResult<VolunteerProfile>> createOrUpdateProfile(VolunteerProfile profile) async {
    try {
      await _vols.doc(profile.uid).set(profile.toFirestore(), SetOptions(merge: true));
      _logger.info('volunteer.profile_updated', fields: {'uid': profile.uid});
      return AppResult.data(profile);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('volunteer.profile_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> updateProfileField(String uid, String field, dynamic value) async {
    try {
      await _vols.doc(uid).update({field: value, 'updatedAt': FieldValue.serverTimestamp()});
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('volunteer.field_update_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

VolunteersRepository createVolunteersRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreVolunteersRepository(firestore: firestore, logger: logger);
  }
  return PreviewVolunteersRepository();
}

VolunteersRepository volunteersRepositoryOf(BuildContext context) {
  return Provider.of<VolunteersRepository>(context, listen: false);
}
