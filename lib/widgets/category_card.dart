import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu kategori kuis untuk halaman Beranda dan daftar kuis.
class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final iconBoxSize = responsive.bodySize * 2.8;

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
          padding: EdgeInsets.all(responsive.pagePadding * 0.5),
          child: Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(responsive.radius * 0.7),
                ),
                child: Icon(
                  category.icon,
                  size: responsive.iconSize,
                  color: AppColors.accent,
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
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: responsive.smallGap * 0.35),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: responsive.bodySize * 0.78,
                        fontWeight: FontWeight.w300,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: responsive.smallGap * 0.55),
                    Text(
                      '${category.questions.length} soal',
                      style: TextStyle(
                        fontSize: responsive.bodySize * 0.72,
                        fontWeight: FontWeight.w400,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.smallGap),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: responsive.bodySize * 0.8,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
