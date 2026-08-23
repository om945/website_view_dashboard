import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 640;
  static const double tabletBreakpoint = 1024;
  static const double shellBreakpoint = 860;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isMobile(BuildContext context) =>
      width(context) < shellBreakpoint;

  static bool isCompact(BuildContext context) =>
      width(context) < mobileBreakpoint;

  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w < mobileBreakpoint) return 16;
    if (w < tabletBreakpoint) return 28;
    return 32;
  }

  static int metricColumns(BuildContext context) {
    final w = width(context);
    if (w < 768) return 1;
    if (w < 1200) return 2;
    return 3;
  }
}
