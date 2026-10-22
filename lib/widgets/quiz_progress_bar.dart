import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Progress bar dengan isian aksen yang dianimasikan.
class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  /// Jumlah soal yang sudah dikerjakan (dimulai dari 1).
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final progress = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(responsive.bodySize * 0.25),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return LinearProgressIndicator(
            value: value,
            minHeight: responsive.bodySize * 0.35,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          );
        },
      ),
    );
  }
}
