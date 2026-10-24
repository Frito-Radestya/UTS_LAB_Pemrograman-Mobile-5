import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu kategori ringkas untuk daftar horizontal di Beranda.
class KageCategoryTile extends StatelessWidget {
  const KageCategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.radius),
        side: BorderSide(
          color: AppColors.border,
          width: responsive.shortestSide * 0.004,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: category.imageAsset == null
                  ? ColoredBox(
                      color: AppColors.vermilion.withValues(alpha: 0.12),
                      child: Icon(
                        category.icon,
                        size: responsive.iconSize,
                        color: AppColors.vermilionLight,
                      ),
                    )
                  : Image.asset(
                      category.imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ColoredBox(
                          color: AppColors.charcoal,
                          child: Icon(
                            category.icon,
                            size: responsive.iconSize,
                            color: AppColors.vermilionLight,
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(responsive.smallGap * 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: responsive.bodySize * 0.74,
                      height: 1.2,
                      fontWeight: AppTypography.title,
                      color: AppColors.ivory,
                    ),
                  ),
                  SizedBox(height: responsive.smallGap * 0.25),
                  Text(
                    '${category.questions.length} soal',
                    style: TextStyle(
                      fontSize: responsive.bodySize * 0.6,
                      fontWeight: AppTypography.label,
                      color: AppColors.antiqueGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
