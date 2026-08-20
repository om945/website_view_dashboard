import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'radii.dart';

abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accent,
      fontFamily: AppTypography.fontSans,
      fontFamilyFallback: AppTypography.fontFallback,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.cyan,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        labelStyle: AppTypography.bodySmall,
        hintStyle: AppTypography.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(color: AppColors.accentBorder),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: AppColors.surfaceElevated,
        textStyle: AppTypography.bodyMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
        titleTextStyle: AppTypography.h3,
        contentTextStyle: AppTypography.bodyMedium,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }
}
