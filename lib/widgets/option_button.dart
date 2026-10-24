import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Tombol pilihan jawaban A–D.
/// Saat dipilih, border dan huruf opsi berubah menjadi warna aksen.
class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.optionLabel,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String optionLabel;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final borderColor = selected ? AppColors.accent : AppColors.border;
    final background = selected
        ? AppColors.accent.withValues(alpha: 0.12)
        : AppColors.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: borderColor,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(responsive.radius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.pagePadding * 0.45,
              // Di landscape ruang vertikal lebih sempit, jadi padding
              // dibuat lebih ringkas agar semua opsi tetap terlihat.
              vertical: responsive.gap * (responsive.isLandscape ? 0.55 : 1.1),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: responsive.bodySize * 2.2,
                  child: Text(
                    '$optionLabel.',
                    style: TextStyle(
                      fontSize: responsive.bodySize,
                      fontWeight: AppTypography.label,
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: responsive.bodySize,
                      fontWeight: AppTypography.label,
                      height: 1.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (selected)
                  Padding(
                    padding: EdgeInsets.only(left: responsive.smallGap * 0.5),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: responsive.bodySize * 1.15,
                      color: AppColors.vermilionLight,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
