import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Tombol sekunder dengan garis tepi, dipakai untuk aksi cadangan.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final textStyle = TextStyle(
      fontFamily: 'Onest',
      fontSize: responsive.bodySize * 1.02,
      fontWeight: AppTypography.button,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(responsive.radius),
    );
    final style = OutlinedButton.styleFrom(
      foregroundColor: AppColors.ivory,
      side: BorderSide(
        color: AppColors.border,
        width: responsive.shortestSide * 0.004,
      ),
      shape: shape,
      textStyle: textStyle,
    );

    return SizedBox(
      width: double.infinity,
      height: responsive.buttonHeight,
      child: icon == null
          ? OutlinedButton(
              onPressed: onPressed,
              style: style,
              child: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: responsive.bodySize * 1.15),
              label: Text(label),
              style: style,
            ),
    );
  }
}
