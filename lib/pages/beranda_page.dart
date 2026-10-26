import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/quiz_data.dart';
import '../state/auth_controller.dart';
import '../state/history_controller.dart';
import '../state/quiz_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final history = context.watch<HistoryController>();
    final quiz = context.watch<QuizController>();
    final resume = quiz.resume;
    final categoryCount = categories.length;

    return ScreenScaffold(
      navIndex: 0,
      stack: const [TopWash(height: 220)],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        children: [
          // Header
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${auth.firstName}',
                        style: AppTheme.onest(
                          size: 22,
                          heightPx: 28,
                          weight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Terus belajar, terus berkembang.',
                        style: AppTheme.onest(
                          size: 14,
                          heightPx: 20,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/profil'),
                  child: Semantics(
                    button: true,
                    label: 'Buka profil ${auth.firstName}',
                    child: _avatar(auth.initial, 44, 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Akun baru mendapat ajakan memulai, bukan progres kosong.
          if (history.history.isEmpty)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.gold,
                    size: 22,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mulai kuis pertamamu',
                    style: AppTheme.onest(
                      size: 18,
                      heightPx: 26,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih satu kategori dan mulai perjalanan pengetahuanmu.',
                    style: AppTheme.onest(
                      size: 14,
                      heightPx: 21,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Pilih kategori',
                    onTap: () => context.go('/kategori'),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Progres Belajar',
                        style: AppTheme.onest(
                          size: 14,
                          heightPx: 20,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${((history.learningPathDone / categoryCount) * 100).round()}%',
                        style: AppTheme.onest(
                          size: 14,
                          heightPx: 20,
                          weight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${history.learningPathDone} / $categoryCount Kategori',
                    style: AppTheme.onest(
                      size: 18,
                      heightPx: 26,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  KageProgressBar(
                    value: history.learningPathDone / categoryCount,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // "Lanjutkan Petualangan" hanya muncul jika ada kuis tersimpan.
          if (resume != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1440),
                      Color(0xFF2D1534),
                      Color(0xFF0F1A2A),
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.gold),
                                ),
                                child: Text(
                                  categoryById(resume.categoryId).name,
                                  style: AppTheme.onest(
                                    size: 12,
                                    heightPx: 18,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Lanjutkan Petualangan',
                                style: AppTheme.onest(
                                  size: 18,
                                  heightPx: 26,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Soal ${resume.index + 1} dari '
                                '${questionsFor(resume.categoryId, resume.difficulty).length}',
                                style: AppTheme.onest(
                                  size: 14,
                                  heightPx: 20,
                                  color: AppColors.textSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Torii art + moon as decorative overlay
                        Stack(
                          children: [
                            const Opacity(
                              opacity: 0.55,
                              child: ToriiArt(width: 120, height: 100),
                            ),
                            const Positioned(
                              right: 12,
                              top: 8,
                              child: MoonGlow(size: 22, glow: 16),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  quiz.continueAdventure();
                                  context.push('/kuis');
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    KageProgressBar(
                      value:
                          (resume.index + 1) /
                          questionsFor(
                            resume.categoryId,
                            resume.difficulty,
                          ).length,
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              _stat('${history.totalQuizzes}', 'Total Kuis'),
              const SizedBox(width: 12),
              _stat('${history.accuracyPercent}%', 'Akurasi'),
              const SizedBox(width: 12),
              _stat('${history.streak}', 'Streak'),
            ],
          ),
          const SizedBox(height: 18),
          // Category section header
          Row(
            children: [
              Text(
                'Kategori Kuis',
                style: AppTheme.onest(
                  size: 18,
                  heightPx: 26,
                  weight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/kategori'),
                child: SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      'Lihat Semua',
                      style: AppTheme.onest(
                        size: 14,
                        heightPx: 20,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Category icons – uses Row with Expanded so each is equally spaced
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final c in categories)
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/kategori/${c.id.name}'),
                    child: Column(
                      children: [
                        CategoryIconBadge(category: c),
                        const SizedBox(height: 6),
                        Text(
                          c.shortName,
                          textAlign: TextAlign.center,
                          style: AppTheme.onest(size: 11, heightPx: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Quote banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const EmblemMark(size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pengetahuan adalah cahaya yang tak pernah padam.',
                    style: AppTheme.onest(
                      size: 14,
                      heightPx: 20,
                      color: AppColors.textQuote,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.onest(
                size: 22,
                heightPx: 28,
                weight: FontWeight.w700,
                color: AppColors.gold,
              ),
            ),
            Text(
              label,
              style: AppTheme.onest(
                size: 12,
                heightPx: 16,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String initial, double size, double font) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.4, -0.5),
          colors: [Color(0xFF3B2A4E), AppColors.surface],
        ),
        border: Border.all(color: AppColors.gold, width: 1.5),
      ),
      child: Text(
        initial,
        style: AppTheme.onest(
          size: font,
          heightPx: font + 4,
          weight: FontWeight.w600,
          color: AppColors.gold,
        ),
      ),
    );
  }
}
