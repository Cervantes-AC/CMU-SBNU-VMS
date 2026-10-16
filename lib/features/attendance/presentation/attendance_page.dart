import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _activity = 'Preparedness workshop';
  final Set<String> _present = {'Mika Alvarez', 'Cathy Lim'};

  static const _names = [
    'Mika Alvarez',
    'Jon Reyes',
    'Cathy Lim',
    'Aira Santos',
    'Daniel Navarro',
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    children: [
      Text(
        'Participation records',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFFAA7C10),
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Attendance',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      const Text(
        'Review the sample roster or mark a local preview record. No attendance is written to a service.',
        style: TextStyle(color: Color(0xFF748078), height: 1.4),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF0D7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'QR check-in is unavailable until a trusted server can issue and validate short-lived sessions.',
          style: TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF6E581F)),
        ),
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        initialValue: _activity,
        decoration: const InputDecoration(
          labelText: 'Sample activity',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(
            value: 'Preparedness workshop',
            child: Text('Preparedness workshop'),
          ),
          DropdownMenuItem(
            value: 'River clean-up',
            child: Text('River clean-up'),
          ),
        ],
        onChanged: (value) => setState(() => _activity = value ?? _activity),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          Expanded(
            child: Text(
              'Sample roster',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '${_present.length}/${_names.length} present',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF47745A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      for (final name in _names)
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            value: _present.contains(name),
            onChanged: (checked) => setState(() {
              if (checked ?? false) {
                _present.add(name);
              } else {
                _present.remove(name);
              }
            }),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _present.contains(name)
                  ? 'Present · local preview'
                  : 'Not recorded',
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: const Color(0xFF176043),
          ),
        ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.qr_code_2,
              size: 38,
              color: Color(0xFF47745A),
            ),
            title: const Text('QR session not connected'),
            content: const Text(
              'A valid QR session must be issued and checked by a trusted backend, including expiry, activity eligibility, and replay protection. This preview cannot start one.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
        icon: const Icon(Icons.qr_code_2),
        label: const Text('QR check-in setup requirements'),
      ),
    ],
  );
}
