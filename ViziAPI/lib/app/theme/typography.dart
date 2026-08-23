import 'package:flutter/material.dart';
import 'colors.dart';

abstract final class AppTypography {
  static const fontSans = 'Plus Jakarta Sans';
  static const fontMono = 'JetBrains Mono';
  static const fontFallback = <String>[
    'Segoe UI',
    'Arial',
    'Roboto',
    'sans-serif',
  ];

  static const h1 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 22,
    height: 1.2,
    letterSpacing: -0.6,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 18,
    height: 1.25,
    letterSpacing: -0.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 14,
    height: 1.3,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 15,
    height: 1.5,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 13,
    height: 1.5,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 11.5,
    height: 1.4,
    color: AppColors.textMuted,
  );

  static const eyebrow = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 10,
    height: 1.2,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const chip = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 10,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const code = TextStyle(
    fontFamily: fontMono,
    fontFamilyFallback: <String>['Consolas', 'Courier New', 'monospace'],
    fontSize: 12.5,
    height: 1.5,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );
}
