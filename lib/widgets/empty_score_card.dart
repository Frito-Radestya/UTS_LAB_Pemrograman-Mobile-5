import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu kosong saat pengguna belum menyelesaikan kuis.
class EmptyScoreCard extends StatelessWidget {
  const EmptyScoreCard({
    super.key,
    this.message = 'Selesaikan kuis pertamamu untuk melihat skor di sini.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: responsive.iconSize * 1.25,
            color: AppColors.accent,
          ),
          SizedBox(width: responsive.pagePadding * 0.45),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum ada skor',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.95,
                    fontWeight: AppTypography.title,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.3),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.76,
                    height: 1.35,
                    fontWeight: AppTypography.body,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
