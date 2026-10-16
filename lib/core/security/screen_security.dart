/// Screen security utilities for sensitive pages.
///
/// Provides a consistent way to mark screens as "secure" so the OS prevents
/// screenshots and screen recording while they are visible. The concrete
/// platform implementation (Android `FLAG_SECURE`, etc.) is intentionally a
/// no-op here until a window-manager dependency is approved and added. Views
/// should use [SecureScreen] to declare intent without coupling to a plugin.
library cmu_sbnu_vms_security;

import 'package:flutter/material.dart';

/// Whether secure screen mode is active for the given context.
///
/// Returns `false` in this build (no platform plugin wired). Return `true`
/// once a platform implementation is integrated so views can react.
bool isSecureScreenEnabled(BuildContext context) => false;

/// A widget that declares its content as sensitive and requests OS-level
/// screenshot/screen-recording prevention while visible.
///
/// Currently a no-op placeholder. Wire a platform channel (e.g.
/// `flutter_windowmanager`) in the implementation below when approved.
class SecureScreen extends StatelessWidget {
  const SecureScreen({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // TODO: When a secure-window plugin is approved, call it here when
    // `enabled` is true and dispose/restore when removed from the tree.
    if (!enabled) return child;
    return child;
  }
}

/// Applies screenshot prevention to an entire [Scaffold]-based page.
///
/// Wrap the page body or the scaffold itself. On mobile this is most
/// important for SOS, incident, and audit screens.
class SecurePage extends StatelessWidget {
  const SecurePage({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SecureScreen(enabled: enabled, child: child);
  }
}
