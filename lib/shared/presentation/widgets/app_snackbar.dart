import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

void showAppSnackbar(
  BuildContext context,
  String message, {
  bool isError = false,
  Duration duration = const Duration(seconds: 4),
}) {
  showPremiumSnackbar(
    context,
    message: message,
    isError: isError,
    duration: duration,
  );
}
