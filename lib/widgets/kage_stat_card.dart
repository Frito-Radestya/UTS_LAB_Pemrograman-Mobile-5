import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu ringkas untuk angka statistik yang berasal dari data aktual.
class KageStatCard extends StatelessWidget {
  const KageStatCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.004,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: responsive.bodySize * 1.15,
              fontWeight: AppTypography.title,
              color: AppColors.ivory,
            ),
          ),
          SizedBox(height: responsive.smallGap * 0.25),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: responsive.bodySize * 0.7,
              fontWeight: AppTypography.label,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
