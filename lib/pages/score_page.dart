import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/questions_data.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/empty_score_card.dart';
import '../widgets/kage_stat_card.dart';
import '../widgets/score_tile.dart';

/// Tab Skor: skor terakhir dan riwayat percobaan selama aplikasi berjalan.
class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final quiz = context.watch<QuizProvider>();
    final lastScore = quiz.lastScore;
    final olderScores = quiz.history.skip(1).toList(growable: false);
    final filterOptions = <String>[
      'Semua',
      ...quizCategories.map((category) => category.title),
    ];

    final visibleOlder = _filter == 'Semua'
        ? olderScores
        : olderScores
              .where((record) => record.categoryTitle == _filter)
              .toList(growable: false);

    final showLast =
        lastScore != null &&
        (_filter == 'Semua' || lastScore.categoryTitle == _filter);

    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.pagePadding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsive.contentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skor',
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
                  'Riwayat hanya tersimpan selama aplikasi berjalan, '
                  'bukan penyimpanan permanen.',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.92,
                    height: 1.45,
                    fontWeight: AppTypography.body,
                    color: AppColors.muted,
                  ),
                ),
                SizedBox(height: responsive.gap),
                Row(
                  children: [
                    Expanded(
                      child: KageStatCard(
                        label: 'Total kuis',
                        value: '${quiz.completedCount}',
                      ),
                    ),
                    SizedBox(width: responsive.smallGap),
                    Expanded(
                      child: KageStatCard(
                        label: 'Terbaik',
                        value: quiz.bestScore == null
                            ? '—'
                            : '${quiz.bestScore!.percentage.round()}%',
                      ),
                    ),
                  ],
                ),
                if (quiz.history.isNotEmpty) ...[
                  SizedBox(height: responsive.gap),
                  SizedBox(
                    height: responsive.buttonHeight * 0.7,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final option in filterOptions)
                          Padding(
                            padding: EdgeInsets.only(
                              right: responsive.smallGap * 0.6,
                            ),
                            child: ChoiceChip(
                              label: Text(option),
                              selected: _filter == option,
                              onSelected: (_) =>
                                  setState(() => _filter = option),
                              labelStyle: TextStyle(
                                fontSize: responsive.bodySize * 0.72,
                                fontWeight: AppTypography.label,
                                color: _filter == option
                                    ? AppColors.ivory
                                    : AppColors.muted,
                              ),
                              selectedColor: AppColors.vermilion.withValues(
                                alpha: 0.35,
                              ),
                              backgroundColor: AppColors.charcoal,
                              side: BorderSide(color: AppColors.border),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: responsive.gap * 1.1),
                const _ScoreSectionTitle(title: 'Skor Terakhir'),
                SizedBox(height: responsive.smallGap * 0.7),
                if (showLast)
                  ScoreTile(record: lastScore)
                else if (lastScore == null)
                  const EmptyScoreCard(
                    message: 'Selesaikan kuis pertamamu untuk melihat riwayat di sini.',
                  )
                else
                  EmptyScoreCard(
                    message: 'Tidak ada skor untuk filter $_filter.',
                  ),
                if (visibleOlder.isNotEmpty) ...[
                  SizedBox(height: responsive.gap * 1.5),
                  const _ScoreSectionTitle(title: 'Riwayat Sebelumnya'),
                  SizedBox(height: responsive.smallGap * 0.7),
                  ...visibleOlder.map(
                    (record) => Padding(
                      padding: EdgeInsets.only(bottom: responsive.gap * 0.7),
                      child: ScoreTile(record: record),
                    ),
                  ),
                ],
                SizedBox(height: responsive.gap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreSectionTitle extends StatelessWidget {
  const _ScoreSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: responsive.bodySize * 1.05,
        fontWeight: AppTypography.title,
        color: AppColors.ivory,
      ),
    );
  }
}
