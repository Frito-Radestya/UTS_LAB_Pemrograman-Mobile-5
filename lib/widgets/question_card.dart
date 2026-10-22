import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu berisi teks pertanyaan.
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: responsive.bodySize * 1.12,
          fontWeight: FontWeight.w300,
          height: 1.45,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
