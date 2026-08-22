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

  static const hero = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 58,
    height: 1.04,
    letterSpacing: -2.4,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const heroTablet = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 46,
    height: 1.08,
    letterSpacing: -1.8,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const heroMobile = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 34,
    height: 1.12,
    letterSpacing: -1.4,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const heroMobileSmall = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 28,
    height: 1.15,
    letterSpacing: -1.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const h1 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 38,
    height: 1.12,
    letterSpacing: -1.6,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 26,
    height: 1.2,
    letterSpacing: -0.8,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 19,
    height: 1.3,
    letterSpacing: -0.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 17,
    height: 1.6,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 14.5,
    height: 1.6,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontSans,
    fontFamilyFallback: fontFallback,
    fontSize: 12.5,
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
