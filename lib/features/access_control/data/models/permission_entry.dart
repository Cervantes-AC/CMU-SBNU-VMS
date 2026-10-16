import 'package:flutter/material.dart';

class PermissionEntry {
  const PermissionEntry({
    required this.dataArea,
    required this.volunteer,
    required this.officer,
    required this.admin,
    required this.server,
  });

  final String dataArea;
  final String volunteer;
  final String officer;
  final String admin;
  final String server;

  Color get volunteerColor => _colorFor(volunteer);
  Color get officerColor => _colorFor(officer);
  Color get adminColor => _colorFor(admin);
  Color get serverColor => _colorFor(server);

  Color _colorFor(String level) => switch (level.toLowerCase()) {
        'none' => const Color(0xFF748078),
        'read' => const Color(0xFF4C735E),
        'write' => const Color(0xFFD5A52F),
        'manage' => const Color(0xFF134F35),
        _ => const Color(0xFF748078),
      };
}
