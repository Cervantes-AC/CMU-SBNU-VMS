import 'package:cloud_firestore/cloud_firestore.dart';

enum SosLifecycleStatus {
  submitted,
  acknowledged,
  actionInProgress,
  resolved,
  cancelled,
  falseAlarm,
  closed,
}

enum SosDeliveryState { pending, sent, failed, unknown }

class SosAlert {
  const SosAlert({
    required this.id,
    required this.reporterUid,
    required this.clientRequestId,
    required this.createdAt,
    this.details,
    this.locationShared = false,
    this.latitude,
    this.longitude,
    this.locationLabel,
    required this.lifecycleStatus,
    required this.deliveryState,
    this.assignedHandlerUid,
    this.acknowledgedAt,
    this.version = 1,
    this.retentionExpiresAt,
    this.updatedAt,
  });

  final String id;
  final String reporterUid;
  final String clientRequestId;
  final DateTime createdAt;
  final String? details;
  final bool locationShared;
  final double? latitude;
  final double? longitude;
  final String? locationLabel;
  final SosLifecycleStatus lifecycleStatus;
  final SosDeliveryState deliveryState;
  final String? assignedHandlerUid;
  final DateTime? acknowledgedAt;
  final int version;
  final DateTime? retentionExpiresAt;
  final DateTime? updatedAt;

  String get lifecycleLabel => switch (lifecycleStatus) {
    SosLifecycleStatus.submitted => 'Submitted',
    SosLifecycleStatus.acknowledged => 'Acknowledged',
    SosLifecycleStatus.actionInProgress => 'Action in Progress',
    SosLifecycleStatus.resolved => 'Resolved',
    SosLifecycleStatus.cancelled => 'Cancelled',
    SosLifecycleStatus.falseAlarm => 'False Alarm',
    SosLifecycleStatus.closed => 'Closed',
  };

  String get deliveryLabel => switch (deliveryState) {
    SosDeliveryState.pending => 'Pending',
    SosDeliveryState.sent => 'Sent',
    SosDeliveryState.failed => 'Failed',
    SosDeliveryState.unknown => 'Unknown',
  };

  factory SosAlert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SosAlert(
      id: doc.id,
      reporterUid: data['reporterUid'] as String? ?? '',
      clientRequestId: data['clientRequestId'] as String? ?? '',
      createdAt: _parseTimestamp(data['createdAt']) ?? DateTime.now(),
      details: data['details'] as String?,
      locationShared: data['locationShared'] as bool? ?? false,
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      locationLabel: data['locationLabel'] as String?,
      lifecycleStatus: _parseLifecycle(data['lifecycleStatus']),
      deliveryState: _parseDelivery(data['deliveryState']),
      assignedHandlerUid: data['assignedHandlerUid'] as String?,
      acknowledgedAt: _parseTimestamp(data['acknowledgedAt']),
      version: data['version'] as int? ?? 1,
      retentionExpiresAt: _parseTimestamp(data['retentionExpiresAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reporterUid': reporterUid,
      'clientRequestId': clientRequestId,
      'createdAt': createdAt,
      if (details != null) 'details': details,
      'locationShared': locationShared,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationLabel != null) 'locationLabel': locationLabel,
      'lifecycleStatus': lifecycleStatus.name,
      'deliveryState': deliveryState.name,
      if (assignedHandlerUid != null) 'assignedHandlerUid': assignedHandlerUid,
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt,
      'version': version,
      if (retentionExpiresAt != null) 'retentionExpiresAt': retentionExpiresAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static SosLifecycleStatus _parseLifecycle(dynamic value) {
    if (value is String) {
      return SosLifecycleStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => SosLifecycleStatus.submitted,
      );
    }
    return SosLifecycleStatus.submitted;
  }

  static SosDeliveryState _parseDelivery(dynamic value) {
    if (value is String) {
      return SosDeliveryState.values.firstWhere(
        (e) => e.name == value,
        orElse: () => SosDeliveryState.pending,
      );
    }
    return SosDeliveryState.pending;
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
