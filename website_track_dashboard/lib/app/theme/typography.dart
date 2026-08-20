import 'package:flutter/material.dart';
import 'colors.dart';

abstract final class AppTypography {
  static const fontSans = 'Plus Jakarta Sans';
  static const fontMono = 'JetBrains Mono';
  static const fontFallback = <String>[
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];

  static const h1 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 30,
    height: 1.12,
    letterSpacing: -1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 22,
    height: 1.2,
    letterSpacing: -0.6,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 16,
    height: 1.3,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 16,
    height: 1.6,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 14,
    height: 1.6,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 12,
    height: 1.5,
    color: AppColors.textMuted,
  );

  static const eyebrow = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const chip = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 10.5,
    letterSpacing: 0.8,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const code = TextStyle(
    fontFamily: fontMono,
    fontFamilyFallback: <String>['Courier New', 'monospace'],
    fontSize: 13,
    height: 1.65,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );
}
