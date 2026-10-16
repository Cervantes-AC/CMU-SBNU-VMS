import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/organization.dart';

/// Repository contract for organizations.
abstract class OrganizationsRepository {
  Stream<List<Organization>> get organizations;
  Stream<Organization?> getOrganizationById(String id);
  Future<AppResult<Organization>> createOrganization(Organization org);
  Future<AppResult<Organization>> updateOrganization(Organization org);
  Future<AppResult<void>> deleteOrganization(String id);
}

/// Preview implementation for development.
class PreviewOrganizationsRepository implements OrganizationsRepository {
  PreviewOrganizationsRepository();

  final List<Organization> _organizations = [
    Organization(
      id: 'org_001',
      name: 'SBNU Main Unit',
      status: 'active',
      coordinatorUids: ['staff_001'],
    ),
    Organization(
      id: 'org_002',
      name: 'College of Arts and Sciences Unit',
      status: 'active',
      coordinatorUids: ['staff_002'],
      parentOrgId: 'org_001',
    ),
    Organization(
      id: 'org_003',
      name: 'College of Engineering Unit',
      status: 'active',
      coordinatorUids: ['staff_003'],
      parentOrgId: 'org_001',
    ),
  ];

  @override
  Stream<List<Organization>> get organizations => Stream.value(_organizations);

  @override
  Stream<Organization?> getOrganizationById(String id) => Stream.value(
    _organizations.firstWhere(
      (o) => o.id == id,
      orElse: () => _organizations.first,
    ),
  );

  @override
  Future<AppResult<Organization>> createOrganization(Organization org) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _organizations.add(org);
    return AppResult.data(org);
  }

  @override
  Future<AppResult<Organization>> updateOrganization(Organization org) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _organizations.indexWhere((o) => o.id == org.id);
    if (idx >= 0) {
      _organizations[idx] = org;
      return AppResult.data(org);
    }
    return AppResult.error(
      const NotFoundFailure(message: 'Organization not found.'),
    );
  }

  @override
  Future<AppResult<void>> deleteOrganization(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _organizations.removeWhere((o) => o.id == id);
    return const AppResult.data(null);
  }
}

/// Firestore-backed implementation.
class FirestoreOrganizationsRepository implements OrganizationsRepository {
  FirestoreOrganizationsRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _orgs =>
      _firestore.collection('organizations');

  @override
  Stream<List<Organization>> get organizations => _orgs.snapshots().map(
    (s) => s.docs.map((d) => Organization.fromFirestore(d)).toList(),
  );

  @override
  Stream<Organization?> getOrganizationById(String id) =>
      _orgs.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        return Organization.fromFirestore(doc);
      });

  @override
  Future<AppResult<Organization>> createOrganization(Organization org) async {
    try {
      await _orgs.doc(org.id).set(org.toFirestore());
      _logger.info('org.create', fields: {'orgId': org.id});
      return AppResult.data(org);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('org.create_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<Organization>> updateOrganization(Organization org) async {
    try {
      await _orgs.doc(org.id).update(org.toFirestore());
      return AppResult.data(org);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('org.update_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<void>> deleteOrganization(String id) async {
    try {
      await _orgs.doc(id).delete();
      return const AppResult.data(null);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('org.delete_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

OrganizationsRepository createOrganizationsRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreOrganizationsRepository(
      firestore: firestore,
      logger: logger,
    );
  }
  return PreviewOrganizationsRepository();
}

OrganizationsRepository organizationsRepositoryOf(BuildContext context) {
  return Provider.of<OrganizationsRepository>(context, listen: false);
}
