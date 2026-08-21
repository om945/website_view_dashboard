import 'package:flutter/material.dart';

/// Centralized responsive design system for ViziAPI
class Responsive {
  static const double mobileSmallBreakpoint = 380;
  static const double mobileBreakpoint = 640;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  static bool isMobileSmall(BuildContext context) =>
      width(context) < mobileSmallBreakpoint;

  static bool isMobile(BuildContext context) =>
      width(context) < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= mobileBreakpoint && w < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      width(context) >= tabletBreakpoint;

  static bool isLargeDesktop(BuildContext context) =>
      width(context) >= desktopBreakpoint;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// Returns responsive horizontal page padding based on viewport width
  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w < mobileSmallBreakpoint) return 14.0;
    if (w < mobileBreakpoint) return 20.0;
    if (w < tabletBreakpoint) return 32.0;
    if (w < desktopBreakpoint) return 48.0;
    return 64.0;
  }

  /// Returns responsive section vertical spacing
  static double sectionVerticalSpacing(BuildContext context) {
    final w = width(context);
    if (w < mobileBreakpoint) return 56.0;
    if (w < tabletBreakpoint) return 72.0;
    return 96.0;
  }

  /// Utility to select a value based on the current breakpoint
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? mobileSmall,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final w = width(context);
    if (w >= desktopBreakpoint && largeDesktop != null) return largeDesktop;
    if (w >= tabletBreakpoint && desktop != null) return desktop;
    if (w >= mobileBreakpoint && tablet != null) return tablet;
    if (w < mobileSmallBreakpoint && mobileSmall != null) return mobileSmall;
    return mobile;
  }

  /// Calculate clamp-like fluid font size based on screen width
  static double fluidFontSize(
    BuildContext context, {
    required double minSize,
    required double maxSize,
    double minWidth = 360,
    double maxWidth = 1280,
  }) {
    final w = width(context);
    if (w <= minWidth) return minSize;
    if (w >= maxWidth) return maxSize;
    final ratio = (w - minWidth) / (maxWidth - minWidth);
    return minSize + (maxSize - minSize) * ratio;
  }
}
