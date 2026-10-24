import 'package:flutter/material.dart';

import '../data/questions_data.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/category_card.dart';

/// Tab Kuis: daftar kategori yang bisa dipilih pengguna.
class QuizListPage extends StatelessWidget {
  const QuizListPage({super.key, required this.onCategoryTap});

  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: responsive.contentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori',
                style: TextStyle(
                  fontSize: responsive.headingSize * 0.72,
                  height: 1.12,
                  letterSpacing: responsive.letterSpacing,
                  fontWeight: AppTypography.heading,
                  color: AppColors.ivory,
                ),
              ),
              SizedBox(height: responsive.smallGap * 0.6),
              Text(
                'Pilih satu perjalanan pengetahuan. Jumlah soal mengikuti '
                'data kategori yang tersedia.',
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.92,
                  height: 1.45,
                  fontWeight: AppTypography.body,
                  color: AppColors.muted,
                ),
              ),
              SizedBox(height: responsive.gap * 1.4),
              ...quizCategories.map(
                (category) => Padding(
                  padding: EdgeInsets.only(bottom: responsive.gap * 0.7),
                  child: CategoryCard(
                    category: category,
                    onTap: () => onCategoryTap(category),
                  ),
                ),
              ),
              SizedBox(height: responsive.gap),
            ],
          ),
        ),
      ),
    );
  }
}
