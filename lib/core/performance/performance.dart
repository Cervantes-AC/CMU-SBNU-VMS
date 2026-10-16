/// Performance utilities for the CMU–SBNU VMS app.
///
/// Provides image cache sizing, repaint boundaries for expensive widgets,
/// and responsive list views to reduce jank and memory usage.

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../platform/device_info.dart';

/// Configures the image cache based on device class and platform.
///
/// Call once during app bootstrap (before runApp) to set appropriate cache
/// limits so the app does not consume excessive memory on low-end devices.
void configureImageCache({
  int mobileMaxImages = 100,
  int mobileMaxSizeBytes = 25 * 1024 * 1024,
  int tabletMaxImages = 150,
  int tabletMaxSizeBytes = 50 * 1024 * 1024,
  int desktopMaxImages = 200,
  int desktopMaxSizeBytes = 100 * 1024 * 1024,
}) {
  final instance = ui.PaintingBinding.instance.imageCache;
  instance.maximumSize = _deviceMaxImages(
    mobile: mobileMaxImages,
    tablet: tabletMaxImages,
    desktop: desktopMaxImages,
  );
  instance.maximumSizeBytes = _deviceMaxSizeBytes(
    mobile: mobileMaxSizeBytes,
    tablet: tabletMaxSizeBytes,
    desktop: desktopMaxSizeBytes,
  );
}

int _deviceMaxImages({
  required int mobile,
  required int tablet,
  required int desktop,
}) {
  final shortest = ui.window.physicalSize.shortestSide /
      ui.window.devicePixelRatio;
  if (shortest < 600) return mobile;
  if (shortest < 1200) return tablet;
  return desktop;
}

int _deviceMaxSizeBytes({
  required int mobile,
  required int tablet,
  required int desktop,
}) {
  final shortest = ui.window.physicalSize.shortestSide /
      ui.window.devicePixelRatio;
  if (shortest < 600) return mobile;
  if (shortest < 1200) return tablet;
  return desktop;
}

/// Wraps an expensive-to-paint child (maps, charts, large lists) in a
/// [RepaintBoundary] so that unrelated parent rebuilds do not repaint it.
///
/// Use sparingly: boundaries themselves have a small cost.
class PaintBoundary extends StatelessWidget {
  const PaintBoundary({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}

/// A [ListView] variant that applies responsive padding based on device
/// class and avoids over-building off-screen items.
class ResponsiveListView extends StatelessWidget {
  const ResponsiveListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.reverse = false,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool reverse;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: physics,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      padding: padding ??
          responsivePadding(
            context,
            mobile: const EdgeInsets.all(12),
            tablet: const EdgeInsets.all(16),
            desktop: const EdgeInsets.all(24),
          ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

/// Returns padding based on device class (mobile-first fallback).
EdgeInsetsGeometry responsivePadding(BuildContext context,
    {EdgeInsetsGeometry? mobile, EdgeInsetsGeometry? tablet, EdgeInsetsGeometry? desktop}) {
  final device = DeviceInfo.of(context);
  switch (device.deviceClass) {
    case DeviceClass.mobile:
      return mobile ?? const EdgeInsets.all(12);
    case DeviceClass.tablet:
      return tablet ?? const EdgeInsets.all(16);
    case DeviceClass.desktop:
      return desktop ?? const EdgeInsets.all(24);
  }
}
