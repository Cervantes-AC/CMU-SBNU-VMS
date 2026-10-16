import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Responsive breakpoints matching common device classes.
///
/// These are layout-independent logical pixel widths. Use them with
/// [DeviceInfo.of] to decide which layout variant to render.
class AppBreakpoints {
  /// Compact handset portrait (phones).
  static const double mobile = 600;

  /// Small tablet portrait / large phone landscape.
  static const double tablet = 900;

  /// Desktop / large tablet landscape.
  static const double desktop = 1200;
}

/// Device class categories derived from the smallest usable width.
enum DeviceClass { mobile, tablet, desktop }

/// Reads device/screen information from the BuildContext.
///
/// Provides screen width, height, orientation, device class, and platform
/// so views can adapt layout without each widget importing `dart:io` or
/// duplicating breakpoint logic. This is presentation-only: it never makes
/// authorization or data-access decisions.
class DeviceInfo {
  const DeviceInfo._();

  /// The current [BuildContext]-based device info.
  static DeviceInfo of(BuildContext context) {
    final media = MediaQuery.of(context);
    return DeviceInfo._(
      width: media.size.width,
      height: media.size.height,
      orientation: media.orientation,
      platform: defaultTargetPlatform,
      isWeb: kIsWeb,
      shortestSide: media.size.shortestSide,
    );
  }

  const DeviceInfo._({
    required this.width,
    required this.height,
    required this.orientation,
    required this.platform,
    required this.isWeb,
    required this.shortestSide,
  });

  /// Screen width in logical pixels.
  final double width;

  /// Screen height in logical pixels.
  final double height;

  /// Current orientation.
  final Orientation orientation;

  /// Target platform.
  final TargetPlatform platform;

  /// Whether running on the web.
  final bool isWeb;

  /// Shortest side in logical pixels.
  final double shortestSide;

  /// Whether the device is a compact handset.
  bool get isMobile => shortestSide < AppBreakpoints.mobile;

  /// Whether the device is a tablet-sized screen.
  bool get isTablet =>
      shortestSide >= AppBreakpoints.mobile &&
      shortestSide < AppBreakpoints.desktop;

  /// Whether the device is desktop-sized.
  bool get isDesktop => shortestSide >= AppBreakpoints.desktop;

  /// The device class for the current screen.
  DeviceClass get deviceClass {
    if (isMobile) return DeviceClass.mobile;
    if (isTablet) return DeviceClass.tablet;
    return DeviceClass.desktop;
  }

  /// Whether the screen is in landscape orientation.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Whether a navigation drawer should be used instead of a persistent
  /// sidebar (true on mobile, false on tablet+desktop).
  bool get useDrawer => isMobile || isTablet;

  /// Whether the topbar search field should be visible.
  bool get showTopbarSearch => !isMobile;
}

/// Convenience: responsive width as a fraction of available width, clamped.
double responsiveWidth(BuildContext context, {double fraction = 1.0}) {
  return DeviceInfo.of(context).width * fraction;
}

/// Returns a value based on device class (mobile-first fallback).
T deviceValue<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  final info = DeviceInfo.of(context);
  switch (info.deviceClass) {
    case DeviceClass.mobile:
      return mobile;
    case DeviceClass.tablet:
      return tablet ?? mobile;
    case DeviceClass.desktop:
      return desktop ?? tablet ?? mobile;
  }
}

/// Returns padding based on device class (mobile-first fallback).
EdgeInsetsGeometry responsivePadding(
  BuildContext context, {
  EdgeInsetsGeometry? mobile,
  EdgeInsetsGeometry? tablet,
  EdgeInsetsGeometry? desktop,
}) {
  return deviceValue(
    context,
    mobile: mobile ?? const EdgeInsets.all(16),
    tablet: tablet,
    desktop: desktop,
  );
}
