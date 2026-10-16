import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/sos_alert.dart';

/// Repository contract for SOS alerts.
abstract class SosRepository {
  Stream<List<SosAlert>> get alerts;
  Stream<List<SosAlert>> getMyAlerts(String uid);
  Stream<SosAlert?> getAlertById(String id);
  Future<AppResult<SosAlert>> createAlert(SosAlert alert);
  Future<AppResult<SosAlert>> updateAlertStatus(
    String id, {
    required SosLifecycleStatus lifecycleStatus,
    SosDeliveryState? deliveryState,
    String? assignedHandlerUid,
    String? actorUid,
  });
}

/// Preview implementation - clearly labeled as not connected to real services.
class PreviewSosRepository implements SosRepository {
  PreviewSosRepository();

  final List<SosAlert> _alerts = [];

  @override
  Stream<List<SosAlert>> get alerts => Stream.value(_alerts);

  @override
  Stream<List<SosAlert>> getMyAlerts(String uid) =>
      Stream.value(_alerts.where((a) => a.reporterUid == uid).toList());

  @override
  Stream<SosAlert?> getAlertById(String id) => Stream.value(
    _alerts.firstWhere((a) => a.id == id, orElse: () => _alerts.first),
  );

  @override
  Future<AppResult<SosAlert>> createAlert(SosAlert alert) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _alerts.add(alert);
    return AppResult.data(alert);
  }

  @override
  Future<AppResult<SosAlert>> updateAlertStatus(
    String id, {
    required SosLifecycleStatus lifecycleStatus,
    SosDeliveryState? deliveryState,
    String? assignedHandlerUid,
    String? actorUid,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      final old = _alerts[idx];
      _alerts[idx] = SosAlert(
        id: old.id,
        reporterUid: old.reporterUid,
        clientRequestId: old.clientRequestId,
        createdAt: old.createdAt,
        details: old.details,
        locationShared: old.locationShared,
        latitude: old.latitude,
        longitude: old.longitude,
        locationLabel: old.locationLabel,
        lifecycleStatus: lifecycleStatus,
        deliveryState: deliveryState ?? old.deliveryState,
        assignedHandlerUid: assignedHandlerUid ?? old.assignedHandlerUid,
        acknowledgedAt: old.acknowledgedAt,
        version: old.version + 1,
        retentionExpiresAt: old.retentionExpiresAt,
        updatedAt: DateTime.now(),
      );
      return AppResult.data(_alerts[idx]);
    }
    return AppResult.error(const NotFoundFailure(message: 'Alert not found.'));
  }
}

/// Firestore-backed implementation.
class FirestoreSosRepository implements SosRepository {
  FirestoreSosRepository({
    FirebaseFirestore? firestore,
    required AppLogger logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> get _alerts =>
      _firestore.collection('sosAlerts');

  @override
  Stream<List<SosAlert>> get alerts => _alerts.snapshots().map(
    (s) => s.docs.map((d) => SosAlert.fromFirestore(d)).toList(),
  );

  @override
  Stream<List<SosAlert>> getMyAlerts(String uid) => _alerts
      .where('reporterUid', isEqualTo: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => SosAlert.fromFirestore(d)).toList());

  @override
  Stream<SosAlert?> getAlertById(String id) =>
      _alerts.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        return SosAlert.fromFirestore(doc);
      });

  @override
  Future<AppResult<SosAlert>> createAlert(SosAlert alert) async {
    try {
      await _alerts.doc(alert.id).set(alert.toFirestore());
      _logger.security(
        'sos.create',
        fields: {'alertId': alert.id, 'reporterUid': alert.reporterUid},
      );
      return AppResult.data(alert);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('sos.create_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<SosAlert>> updateAlertStatus(
    String id, {
    required SosLifecycleStatus lifecycleStatus,
    SosDeliveryState? deliveryState,
    String? assignedHandlerUid,
    String? actorUid,
  }) async {
    try {
      final docRef = _alerts.doc(id);
      final doc = await docRef.get();
      if (!doc.exists) {
        return AppResult.error(
          const NotFoundFailure(message: 'Alert not found.'),
        );
      }

      final current = SosAlert.fromFirestore(doc);
      await docRef.update({
        'lifecycleStatus': lifecycleStatus.name,
        if (deliveryState != null) 'deliveryState': deliveryState.name,
        if (assignedHandlerUid != null)
          'assignedHandlerUid': assignedHandlerUid,
        'version': current.version + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updated = SosAlert.fromFirestore(await docRef.get());
      return AppResult.data(updated);
    } on AppFailure catch (e) {
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('sos.update_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }
}

SosRepository createSosRepository({
  bool useFirestore = false,
  FirebaseFirestore? firestore,
  required AppLogger logger,
}) {
  if (useFirestore && firestore != null) {
    return FirestoreSosRepository(firestore: firestore, logger: logger);
  }
  return PreviewSosRepository();
}

SosRepository sosRepositoryOf(BuildContext context) {
  return Provider.of<SosRepository>(context, listen: false);
}
