import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu kategori kuis untuk halaman daftar kuis.
class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final thumbSize = responsive.bodySize * 3.2;

    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.radius),
        side: BorderSide(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(responsive.pagePadding * 0.45),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(responsive.radius * 0.7),
                child: SizedBox(
                  width: thumbSize,
                  height: thumbSize,
                  child: category.imageAsset == null
                      ? ColoredBox(
                          color: AppColors.vermilion.withValues(alpha: 0.12),
                          child: Icon(
                            category.icon,
                            size: responsive.iconSize,
                            color: AppColors.vermilion,
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
                                color: AppColors.vermilion,
                              ),
                            );
                          },
                        ),
                ),
              ),
              SizedBox(width: responsive.pagePadding * 0.45),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: responsive.bodySize * 1.05,
                        fontWeight: AppTypography.title,
                        color: AppColors.ivory,
                      ),
                    ),
                    SizedBox(height: responsive.smallGap * 0.35),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: responsive.bodySize * 0.78,
                        fontWeight: AppTypography.body,
                        height: 1.35,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: responsive.smallGap * 0.55),
                    Text(
                      '${category.questions.length} soal',
                      style: TextStyle(
                        fontSize: responsive.bodySize * 0.72,
                        fontWeight: AppTypography.label,
                        color: AppColors.vermilionLight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.smallGap),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: responsive.bodySize * 0.8,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
