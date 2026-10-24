import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _bodyFont = 'Onest';
  static const _displayFont = 'Cinzel';

  static TextStyle onest({
    double size = 16,
    double heightPx = 24,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: _bodyFont,
      fontSize: size,
      height: heightPx / size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
    );
  }

  static TextStyle cinzel({
    double size = 40,
    double heightPx = 48,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.gold,
    double letterSpacing = 8,
  }) {
    return TextStyle(
      fontFamily: _displayFont,
      fontSize: size,
      height: heightPx / size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
        onPrimary: AppColors.text,
        onSurface: AppColors.text,
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: _bodyFont,
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
