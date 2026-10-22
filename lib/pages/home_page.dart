import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/questions_data.dart';
import '../models/category.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/category_card.dart';
import '../widgets/empty_score_card.dart';
import '../widgets/score_tile.dart';

/// Tab Beranda: sapaan, banner, daftar kategori, skor terakhir, dan tips.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onOpenQuizTab,
    required this.onCategoryTap,
  });

  final VoidCallback onOpenQuizTab;
  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final auth = context.watch<AuthProvider>();
    final quiz = context.watch<QuizProvider>();

    final name = auth.currentUser?.name ?? 'Sobat';
    final lastScore = quiz.lastScore;

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: responsive.contentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $name',
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
                'Mau menguji pemahaman Flutter & Dart hari ini?',
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.92,
                  height: 1.45,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: responsive.gap * 1.3),
              _HomeBanner(onTap: onOpenQuizTab),
              SizedBox(height: responsive.gap * 1.5),
              _SectionHeader(
                title: 'Kategori Kuis',
                actionLabel: 'Lihat semua',
                onAction: onOpenQuizTab,
              ),
              SizedBox(height: responsive.smallGap * 0.7),
              ...quizCategories.map(
                (category) => Padding(
                  padding: EdgeInsets.only(bottom: responsive.gap * 0.7),
                  child: CategoryCard(
                    category: category,
                    onTap: () => onCategoryTap(category),
                  ),
                ),
              ),
              SizedBox(height: responsive.gap * 0.4),
              const _SectionHeader(title: 'Skor Terakhir'),
              SizedBox(height: responsive.smallGap * 0.7),
              if (lastScore != null)
                ScoreTile(record: lastScore)
              else
                const EmptyScoreCard(),
              SizedBox(height: responsive.gap * 1.5),
              const _TipsCard(),
              SizedBox(height: responsive.gap),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner pembuka di Beranda. Mengetuk banner membuka tab Kuis.
class _HomeBanner extends StatelessWidget {
  const _HomeBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(responsive.radius),
      child: AspectRatio(
        aspectRatio: 1.9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/bg_temple.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.background.withValues(alpha: 0.94),
                    AppColors.background.withValues(alpha: 0.28),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(responsive.pagePadding * 0.6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MULAI DARI SINI',
                        style: TextStyle(
                          fontSize: responsive.bodySize * 0.66,
                          fontWeight: FontWeight.w400,
                          letterSpacing: responsive.bodySize * 0.12,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(height: responsive.smallGap * 0.4),
                      Text(
                        'Uji pemahamanmu\nhari ini',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: responsive.bodySize * 1.45,
                          height: 1.08,
                          letterSpacing: responsive.letterSpacing * 0.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: responsive.smallGap * 0.5),
                      Text(
                        'Pilih kategori dan mulai kuis singkat.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: responsive.bodySize * 0.72,
                          height: 1.35,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: responsive.bodySize * 1.05,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: responsive.bodySize * 0.76,
                fontWeight: FontWeight.w400,
                color: AppColors.accent,
              ),
            ),
          ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: responsive.iconSize,
            color: AppColors.accent,
          ),
          SizedBox(width: responsive.pagePadding * 0.45),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips belajar',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.92,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.3),
                Text(
                  'Baca soal dengan teliti dan pilih satu jawaban sebelum menekan Lanjut.',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.76,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
