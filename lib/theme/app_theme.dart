import 'package:flutter/material.dart';

/// Token warna KAGE sesuai DESIGN.md.
class AppColors {
  const AppColors._();

  static const Color midnight = Color(0xFF0B0D12);
  static const Color charcoal = Color(0xFF171A22);
  static const Color surface = Color(0xFF20242D);
  static const Color elevated = Color(0xFF272C36);
  static const Color vermilion = Color(0xFFB9232C);
  static const Color vermilionLight = Color(0xFFE1484D);
  static const Color antiqueGold = Color(0xFFC9A56A);
  static const Color ivory = Color(0xFFE8E4DD);
  static const Color muted = Color(0xFF9297A2);
  static const Color success = Color(0xFF53B889);
  static const Color error = Color(0xFFE15A62);
  static const Color border = Color(0xFF343944);

  /// Alias agar widget lama tetap membaca token yang sama.
  static const Color accent = vermilion;
  static const Color background = midnight;
  static const Color textPrimary = ivory;
  static const Color textSecondary = muted;
  static const Color correct = success;
}

/// Bobot Onest sesuai peran teks agar seluruh halaman konsisten.
class AppTypography {
  const AppTypography._();

  static const FontWeight hero = FontWeight.w700;
  static const FontWeight heading = FontWeight.w600;
  static const FontWeight title = FontWeight.w600;
  static const FontWeight body = FontWeight.w400;
  static const FontWeight label = FontWeight.w500;
  static const FontWeight button = FontWeight.w600;
}

/// Durasi animasi yang dipakai ulang di seluruh aplikasi.
class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration page = Duration(milliseconds: 300);
}

/// Path aset lokal KAGE.
class AppAssets {
  const AppAssets._();

  static const String splash = 'assets/images/backgrounds/kage_splash.jpg';
  static const String auth = 'assets/images/backgrounds/kage_auth.jpg';
  static const String home = 'assets/images/backgrounds/kage_home.jpg';
  static const String quiz = 'assets/images/backgrounds/kage_quiz.jpg';
  static const String result = 'assets/images/backgrounds/kage_result.jpg';
  static const String mark = 'assets/images/icons/kage_mark.jpg';
  static const String ornament = 'assets/images/decorations/gold_ornament.jpg';
  static const String badgeFirst = 'assets/images/badges/badge_first_quiz.jpg';
  static const String badgePerfect =
      'assets/images/badges/badge_perfect_score.jpg';
  static const String badgeMaster = 'assets/images/badges/badge_master.jpg';
  static const String badgeStreak = 'assets/images/badges/badge_streak.jpg';
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.vermilion,
      onPrimary: AppColors.ivory,
      surface: AppColors.surface,
      onSurface: AppColors.ivory,
      secondary: AppColors.antiqueGold,
      onSecondary: AppColors.midnight,
      error: AppColors.error,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Onest',
      scaffoldBackgroundColor: AppColors.midnight,
      colorScheme: colorScheme,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.hero,
        ),
        displayMedium: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.hero,
        ),
        displaySmall: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.heading,
        ),
        headlineLarge: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.heading,
        ),
        headlineMedium: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.heading,
        ),
        headlineSmall: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.title,
        ),
        titleLarge: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.title,
        ),
        titleMedium: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.title,
        ),
        titleSmall: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.label,
        ),
        bodyLarge: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.body,
        ),
        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontWeight: AppTypography.body,
        ),
        bodySmall: TextStyle(
          color: AppColors.muted,
          fontWeight: AppTypography.body,
        ),
        labelLarge: TextStyle(
          color: AppColors.ivory,
          fontWeight: AppTypography.button,
        ),
        labelMedium: TextStyle(
          color: AppColors.muted,
          fontWeight: AppTypography.label,
        ),
        labelSmall: TextStyle(
          color: AppColors.muted,
          fontWeight: AppTypography.label,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Onest',
            fontWeight: AppTypography.button,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Onest',
            fontWeight: AppTypography.button,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Onest',
            fontWeight: AppTypography.button,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Onest',
            fontWeight: AppTypography.button,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: TextStyle(
          color: AppColors.muted,
          fontWeight: AppTypography.body,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.vermilion),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.vermilion,
        linearTrackColor: AppColors.border,
      ),
    );
  }
}
