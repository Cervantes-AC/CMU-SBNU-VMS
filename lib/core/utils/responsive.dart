import 'package:flutter/material.dart';

/// App breakpoints and layout helpers (no device identity).
class AppBreakpoints {
  AppBreakpoints._();

  /// Phones: width < 600.
  static const double compact = 600;

  /// Tablets / split views: 600 <= width < 1024.
  static const double medium = 1024;

  /// Wide web: width >= 1024.
  static const double expanded = 1024;

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) =>
      width >= compact && width < expanded;
  static bool isWide(double width) => width >= expanded;

  /// Content max width per class of screen.
  static double contentMaxWidth(double width) {
    if (isWide(width)) return 1240;
    if (isMedium(width)) return 900;
    return double.infinity;
  }
}

/// Responsive helpers built on [LayoutBuilder] constraints.
class Responsive {
  Responsive._();

  /// Horizontal page padding for the current width.
  static double horizontalPadding(double width) {
    if (width >= AppBreakpoints.expanded) return 48;
    if (width >= AppBreakpoints.compact) return 32;
    return 20;
  }

  /// Column count for a grid of items (1/2/3/4).
  static int columns(double width, {int max = 4}) {
    int c;
    if (width >= AppBreakpoints.expanded) {
      c = max;
    } else if (width >= AppBreakpoints.compact) {
      c = max >= 3 ? 3 : 2;
    } else {
      c = 2;
    }
    return c.clamp(1, max);
  }

  /// Whether two-pane layouts should stack.
  static bool isStacked(double width) => width < AppBreakpoints.compact;

  /// Whether to use bottom navigation (mobile) vs rail/navigation drawer.
  static bool useBottomNavigation(double width) =>
      width < AppBreakpoints.medium;
}
