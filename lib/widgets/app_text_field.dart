import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kolom input teks yang dipakai ulang di halaman Login, Register, dan
/// halaman lain yang membutuhkan form.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final borderWidth = responsive.shortestSide * 0.005;

    OutlineInputBorder border(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.radius),
        borderSide: BorderSide(color: color, width: borderWidth),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: responsive.smallGap * 0.4,
            bottom: responsive.smallGap * 0.5,
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: responsive.bodySize * 0.7,
              fontWeight: AppTypography.label,
              letterSpacing: responsive.bodySize * 0.08,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          enabled: enabled,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: AppColors.accent,
          style: TextStyle(
            fontSize: responsive.bodySize,
            fontWeight: AppTypography.body,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: responsive.bodySize,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(
                    prefixIcon,
                    size: responsive.iconSize * 0.9,
                    color: AppColors.textSecondary,
                  ),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.pagePadding * 0.4,
              vertical: responsive.gap * 0.9,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: border(AppColors.border),
            enabledBorder: border(AppColors.border),
            focusedBorder: border(AppColors.accent),
            errorBorder: border(AppColors.accent),
            focusedErrorBorder: border(AppColors.accent),
            errorStyle: TextStyle(
              fontSize: responsive.bodySize * 0.75,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
