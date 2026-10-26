import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kage/data/repositories/question_repository.dart';
import 'package:kage/models/models.dart';
import 'package:kage/theme/app_colors.dart';
import 'package:kage/theme/app_theme.dart';
import 'package:kage/widgets/category_icon_badge.dart';

class ScoreRow extends StatelessWidget {
  const ScoreRow({super.key, required this.result, this.compact = false});

  final QuizResult result;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cat = context.read<QuestionRepository>().categoryById(
      result.categoryId,
    );
    final date =
        '${result.playedAt.day.toString().padLeft(2, '0')} ${_month(result.playedAt.month)} ${result.playedAt.year}';
    final dur = _fmt(result.duration);
    return Container(
      height: compact ? 64 : 68,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CategoryIconBadge(
            category: cat,
            size: compact ? 40 : 44,
            iconSize: compact ? 20 : 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: AppTheme.onest(
                    size: compact ? 15 : 16,
                    heightPx: compact ? 20 : 22,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$date · $dur',
                  style: AppTheme.onest(
                    size: 12,
                    heightPx: 16,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${result.score}',
            style: AppTheme.onest(
              size: compact ? 20 : 22,
              heightPx: 28,
              weight: FontWeight.w700,
              color: scoreTint(result.score),
            ),
          ),
        ],
      ),
    );
  }

  static String _month(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return names[m - 1];
  }

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
