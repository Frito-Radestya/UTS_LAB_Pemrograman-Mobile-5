import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Tombol utama dengan warna aksen dan ukuran responsif.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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
      fontSize: responsive.bodySize * 1.05,
      fontWeight: AppTypography.button,
      letterSpacing: responsive.headingSize * -0.006,
    );

    return SizedBox(
      width: double.infinity,
      height: responsive.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textSecondary,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: responsive.smallGap),
              Icon(icon, size: responsive.bodySize * 1.2),
            ],
          ],
        ),
      ),
    );
  }
}
