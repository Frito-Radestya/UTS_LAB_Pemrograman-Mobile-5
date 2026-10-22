import 'package:flutter/material.dart';

/// Warna dan tema aplikasi sesuai DESIGN.md.
class AppColors {
  const AppColors._();

  static const Color accent = Color(0xFFE0231C);
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color border = Color(0xFF2E2E2E);
  static const Color textPrimary = Color(0xFFF5F2EC);
  static const Color textSecondary = Color(0xFFA8A39A);
  static const Color correct = Color(0xFF4CAF50);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      secondary: AppColors.textSecondary,
      onSecondary: AppColors.background,
      error: AppColors.accent,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Onest',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w300),
        bodyMedium: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w300),
        labelLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.border,
      ),
    );
  }
}
