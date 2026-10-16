import 'package:flutter/material.dart';

class HotlineEntry {
  const HotlineEntry({
    required this.id,
    required this.label,
    required this.phoneE164,
    required this.coverage,
    required this.hours,
    required this.verificationState,
    required this.verifiedBy,
    required this.verifiedAt,
    required this.reviewDueAt,
    required this.active,
  });

  final String id;
  final String label;
  final String phoneE164;
  final String coverage;
  final String hours;
  final String
  verificationState; // draft, pendingVerification, verified, rejected, expired, disabled
  final String verifiedBy;
  final DateTime verifiedAt;
  final DateTime reviewDueAt;
  final bool active;

  bool get isVerified => verificationState == 'verified' && active;
  bool get isCallEnabled => isVerified;

  String get verificationLabel => verificationState.toUpperCase();

  Color get verificationColor => switch (verificationState) {
    'verified' => const Color(0xFF196142),
    'expired' => const Color(0xFFB63D34),
    'rejected' => const Color(0xFFB63D34),
    'disabled' => const Color(0xFF748078),
    _ => const Color(0xFFD5A52F),
  };
}
