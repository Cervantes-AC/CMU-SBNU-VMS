import 'package:flutter/material.dart';

/// Displays a form field error message.
class AppFormFieldError extends StatelessWidget {
  const AppFormFieldError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 4),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB63D34),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
