import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu berisi teks pertanyaan dengan label kecil di atasnya.
class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.pagePadding * 0.75),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: responsive.bodySize * 0.12,
                height: responsive.bodySize * 0.75,
                decoration: BoxDecoration(
                  color: AppColors.antiqueGold,
                  borderRadius: BorderRadius.circular(responsive.bodySize),
                ),
              ),
              SizedBox(width: responsive.smallGap * 0.7),
              Expanded(
                child: Text(
                  'PERTANYAAN',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.6,
                    fontWeight: AppTypography.label,
                    letterSpacing: responsive.bodySize * 0.12,
                    color: AppColors.antiqueGold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.smallGap * 0.8),
          Text(
            text,
            style: TextStyle(
              fontSize: responsive.bodySize * 1.12,
              fontWeight: AppTypography.body,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
