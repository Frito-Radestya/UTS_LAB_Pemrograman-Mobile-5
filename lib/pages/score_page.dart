import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/empty_score_card.dart';
import '../widgets/score_tile.dart';

/// Tab Skor: skor terakhir dan riwayat percobaan selama aplikasi berjalan.
class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final quiz = context.watch<QuizProvider>();
    final lastScore = quiz.lastScore;
    final olderScores = quiz.history.skip(1).toList(growable: false);

    return SingleChildScrollView(
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
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: responsive.smallGap * 0.6),
              Text(
                'Lihat hasil terakhir dan riwayat percobaanmu selama '
                'aplikasi berjalan.',
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.92,
                  height: 1.45,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: responsive.gap * 1.3),
              _ScoreSectionTitle(title: 'Skor Terakhir'),
              SizedBox(height: responsive.smallGap * 0.7),
              if (lastScore != null)
                ScoreTile(record: lastScore)
              else
                const EmptyScoreCard(
                  message: 'Selesaikan kuis pertamamu untuk melihat riwayat di sini.',
                ),
              if (olderScores.isNotEmpty) ...[
                SizedBox(height: responsive.gap * 1.5),
                _ScoreSectionTitle(title: 'Riwayat Sebelumnya'),
                SizedBox(height: responsive.smallGap * 0.7),
                ...olderScores.map(
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
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
    );
  }
}
