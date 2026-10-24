import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/questions_data.dart';
import '../models/category.dart';
import '../models/score_record.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/kage_category_tile.dart';
import '../widgets/kage_section_header.dart';
import '../widgets/kage_stat_card.dart';

/// Tab Beranda: sapaan, progres, petualangan berikutnya, dan kategori.
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
    final initial = auth.currentUser?.initial ?? '?';
    final lastCategory = quiz.lastCategory;
    final lastScore = quiz.lastScore;
    final best = quiz.bestScore;

    // Kategori unik yang sudah diselesaikan, dipakai untuk progres.
    final explored = quiz.history.map((record) => record.categoryTitle).toSet();
    final totalCategories = quizCategories.length;
    final progress = totalCategories == 0
        ? 0.0
        : (explored.length / totalCategories).clamp(0.0, 1.0);
    final accuracy = best?.percentage.round();

    return SingleChildScrollView(
      key: const PageStorageKey<String>('home-scroll'),
      padding: EdgeInsets.all(responsive.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: responsive.contentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $name',
                          style: TextStyle(
                            fontSize: responsive.headingSize * 0.62,
                            height: 1.12,
                            letterSpacing: responsive.letterSpacing,
                            fontWeight: AppTypography.hero,
                            color: AppColors.ivory,
                          ),
                        ),
                        SizedBox(height: responsive.smallGap * 0.4),
                        Text(
                          'Siap menjelajah pengetahuan hari ini?',
                          style: TextStyle(
                            fontSize: responsive.bodySize * 0.88,
                            height: 1.4,
                            fontWeight: AppTypography.body,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: responsive.smallGap),
                  _Avatar(initial: initial),
                ],
              ),
              SizedBox(height: responsive.gap * 1.2),
              _ProgressCard(
                completed: explored.length,
                total: totalCategories,
                progress: progress,
                onTap: onOpenQuizTab,
              ),
              SizedBox(height: responsive.gap * 1.2),
              _JourneyCard(
                category: lastCategory,
                lastScore: lastScore,
                onTap: lastCategory == null
                    ? onOpenQuizTab
                    : () => onCategoryTap(lastCategory),
              ),
              SizedBox(height: responsive.gap * 1.4),
              KageSectionHeader(
                title: 'Kategori Kuis',
                actionLabel: 'Lihat semua',
                onAction: onOpenQuizTab,
              ),
              SizedBox(height: responsive.smallGap * 0.7),
              _CategoryRail(onCategoryTap: onCategoryTap),
              SizedBox(height: responsive.gap * 1.2),
              Row(
                children: [
                  Expanded(
                    child: KageStatCard(
                      label: 'Kuis selesai',
                      value: '${quiz.completedCount}',
                    ),
                  ),
                  SizedBox(width: responsive.smallGap),
                  Expanded(
                    child: KageStatCard(
                      label: 'Akurasi terbaik',
                      value: accuracy == null ? '—' : '$accuracy%',
                    ),
                  ),
                  SizedBox(width: responsive.smallGap),
                  Expanded(
                    child: KageStatCard(
                      label: 'Kategori',
                      value: '${explored.length}/$totalCategories',
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.gap),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = responsive.bodySize * 2.8;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.vermilion.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.antiqueGold.withValues(alpha: 0.55),
          width: responsive.shortestSide * 0.004,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: responsive.bodySize * 1.15,
            fontWeight: AppTypography.title,
            color: AppColors.ivory,
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
    required this.onTap,
  });

  final int completed;
  final int total;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final percent = (progress * 100).round();
    final message = completed == 0
        ? 'Mulai kategori pertamamu.'
        : completed >= total
        ? 'Semua kategori sudah dijelajahi.'
        : '$percent% perjalanan selesai.';

    return Material(
      color: AppColors.surface.withValues(alpha: 0.94),
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
        child: Padding(
          padding: EdgeInsets.all(responsive.pagePadding * 0.55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'PROGRES BELAJAR',
                      style: TextStyle(
                        fontSize: responsive.bodySize * 0.62,
                        fontWeight: AppTypography.label,
                        letterSpacing: responsive.bodySize * 0.1,
                        color: AppColors.antiqueGold,
                      ),
                    ),
                  ),
                  Text(
                    '$completed/$total Kategori',
                    style: TextStyle(
                      fontSize: responsive.bodySize * 0.72,
                      fontWeight: AppTypography.label,
                      color: AppColors.ivory,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.smallGap * 0.8),
              ClipRRect(
                borderRadius: BorderRadius.circular(responsive.bodySize),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: responsive.bodySize * 0.24,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.vermilionLight,
                  ),
                ),
              ),
              SizedBox(height: responsive.smallGap * 0.7),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: responsive.bodySize * 0.76,
                        fontWeight: AppTypography.body,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: responsive.bodySize,
                    color: AppColors.antiqueGold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.category,
    required this.lastScore,
    required this.onTap,
  });

  final Category? category;
  final ScoreRecord? lastScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final isContinuing = category != null;
    final imageAsset = category?.imageAsset ?? AppAssets.home;

    return ClipRRect(
      borderRadius: BorderRadius.circular(responsive.radius),
      child: AspectRatio(
        aspectRatio: responsive.isLandscape ? 2.1 : 1.5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(color: AppColors.charcoal);
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.midnight.withValues(alpha: 0.18),
                    AppColors.midnight.withValues(alpha: 0.94),
                  ],
                  stops: const [0, 0.82],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(responsive.pagePadding * 0.55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isContinuing
                            ? 'LANJUTKAN PETUALANGAN'
                            : 'MULAI PERJALANAN',
                        style: TextStyle(
                          fontSize: responsive.bodySize * 0.62,
                          fontWeight: AppTypography.label,
                          letterSpacing: responsive.bodySize * 0.12,
                          color: AppColors.antiqueGold,
                        ),
                      ),
                      SizedBox(height: responsive.smallGap * 0.35),
                      Text(
                        category?.title ?? 'Gerbang Pengetahuan',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: responsive.bodySize * 1.35,
                          height: 1.08,
                          letterSpacing: responsive.letterSpacing * 0.5,
                          fontWeight: AppTypography.title,
                          color: AppColors.ivory,
                        ),
                      ),
                      SizedBox(height: responsive.smallGap * 0.7),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastScore == null
                                  ? 'Pilih kategori dan uji pemahamanmu.'
                                  : 'Skor terakhir ${lastScore!.score}/'
                                        '${lastScore!.total} benar.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: responsive.bodySize * 0.76,
                                height: 1.35,
                                fontWeight: AppTypography.body,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                          SizedBox(width: responsive.smallGap),
                          Container(
                            width: responsive.bodySize * 2.3,
                            height: responsive.bodySize * 2.3,
                            decoration: const BoxDecoration(
                              color: AppColors.vermilion,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: responsive.bodySize * 1.3,
                              color: AppColors.ivory,
                            ),
                          ),
                        ],
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

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.onCategoryTap});

  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            constraints.maxWidth * (responsive.isLandscape ? 0.21 : 0.34);
        final tileHeight = tileWidth * 1.28;

        return SizedBox(
          height: tileHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: quizCategories.length,
            itemBuilder: (context, index) {
              final category = quizCategories[index];
              return SizedBox(
                width: tileWidth,
                child: KageCategoryTile(
                  category: category,
                  onTap: () => onCategoryTap(category),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: responsive.smallGap);
            },
          ),
        );
      },
    );
  }
}
