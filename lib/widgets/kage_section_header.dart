import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Judul bagian halaman dengan aksi opsional di kanan.
class KageSectionHeader extends StatelessWidget {
  const KageSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: responsive.bodySize * 1.05,
              fontWeight: AppTypography.title,
              color: AppColors.ivory,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: responsive.bodySize * 0.76,
                fontWeight: AppTypography.button,
                color: AppColors.vermilionLight,
              ),
            ),
          ),
      ],
    );
  }
}
