import '../constants/app_constants.dart';

/// Structured validation result. Field-level messages map to form fields.
class ValidationResult {
  const ValidationResult.valid()
      : isValid = true,
        fieldErrors = const {};
  const ValidationResult.invalid(this.fieldErrors)
      : isValid = false;

  final bool isValid;
  final Map<String, String> fieldErrors;

  String? operator [](String field) => fieldErrors[field];
}

/// Pure validators for required text, length, email, phone, and safe free
/// text. Client validation improves UX but duplicates authoritative backend
/// checks. Does not normalize away meaningful user content.
class Validators {
  Validators._();

  static final _emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
  // Accepts +63 and 0-prefix PH-style numbers and generic E.164; display only.
  static final _phoneRegex = RegExp(r'^\+?[0-9\-\s()]{7,20}$');
  // Blocks control characters and common markup triggers in free text.
  static final _unsafeCharRegex = RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F<>]');

  /// Returns an error message for [value], or null when acceptable.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required.';
    return null;
  }

  static String? length(
    String? value, {
    int? min,
    int? max,
    String fieldName = 'This field',
  }) {
    final v = value ?? '';
    final length = v.trim().length;
    if (min != null && length < min) {
      return '$fieldName must be at least $min characters.';
    }
    if (max != null && length > max) {
      return '$fieldName must be at most $max characters.';
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email address.';
    if (v.length > 254) return 'Email address is too long.';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address.';
    return null;
  }

  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null; // Optional by default.
    if (!_phoneRegex.hasMatch(v)) return 'Enter a valid phone number.';
    return null;
  }

  /// Safe free text: required + length + no control/markup characters.
  static String? safeText(
    String? value, {
    int? min,
    int max = AppConstants.longTextMaxLength,
    String fieldName = 'This field',
  }) {
    final v = value ?? '';
    if (min != null && min > 0 && v.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final trimmedLength = v.trim().length;
    if (min != null && trimmedLength < min) {
      return '$fieldName must be at least $min characters.';
    }
    if (trimmedLength > max) {
      return '$fieldName must be at most $max characters.';
    }
    if (_unsafeCharRegex.hasMatch(v)) {
      return '$fieldName contains characters that are not allowed.';
    }
    return null;
  }

  /// Validates an identifier (document ID segment).
  static String? docId(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Identifier is required.';
    if (v.contains('/')) return 'Identifier is invalid.';
    if (v.length > 1500) return 'Identifier is too long.';
    return null;
  }

  /// Runs several validators; returns the first error per field.
  static String? combine(List<String? Function()> validators) {
    for (final v in validators) {
      final error = v();
      if (error != null) return error;
    }
    return null;
  }
}
