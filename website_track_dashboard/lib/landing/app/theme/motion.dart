import 'package:flutter/material.dart';

abstract final class AppMotion {
  // Durations
  static const fast = Duration(milliseconds: 160);
  static const normal = Duration(milliseconds: 280);
  static const medium = Duration(milliseconds: 420);
  static const slow = Duration(milliseconds: 650);

  // Easing Curves
  static const curveFast = Curves.easeOutCubic;
  static const curveStandard = Curves.easeInOutCubic;
  static const curveEntrance = Curves.easeOutQuart;
  static const curveSpring = Curves.easeOutBack;
}
