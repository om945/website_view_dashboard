import 'package:flutter/material.dart';
import 'colors.dart';

abstract final class AppShadows {
  static const soft = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const card = [
    BoxShadow(
      color: Color(0x44000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x11FFFFFF),
      blurRadius: 1,
      offset: Offset(0, 1),
    ),
  ];

  static const accentGlow = [
    BoxShadow(
      color: AppColors.accentGlow,
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];
}
