import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/quiz_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class DetailKategoriPage extends StatelessWidget {
  const DetailKategoriPage({super.key, required this.id});

  final CategoryId id;

  @override
  Widget build(BuildContext context) {
    final cat = categoryById(id);
    final app = context.watch<AppState>();
    // Header height: 30% of screen, min 220, max 320
    final headerH = (MediaQuery.sizeOf(context).height * 0.30).clamp(
      220.0,
      320.0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Hero header
          SizedBox(
            height: headerH,
            child: Stack(
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF070B1E),
                        Color(0xFF141A45),
                        Color(0xFF2B1D4A),
                        AppColors.background,
                      ],
                      stops: [0, 0.55, 0.85, 1],
                    ),
                  ),
                  child: SizedBox.expand(),
                ),
                StarField(height: headerH),
                Positioned.fill(
                  top: 52,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/astrolab.svg',
                      width: headerH * 0.65,
                      height: headerH * 0.65,
                    ),
                  ),
                ),
                SafeArea(
                  child: SizedBox(
                    height: 64,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        BackIconButton(
                          label: 'Kembali ke daftar kategori',
                          onTap: () => context.pop(),
                        ),
                        Text(
                          'Detail Kategori',
                          style: AppTheme.onest(
                            size: 16,
                            heightPx: 22,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cat.name,
                          style: AppTheme.onest(
                            size: 26,
                            heightPx: 34,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Tersedia',
                          style: AppTheme.onest(
                            size: 12,
                            heightPx: 20,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat.description,
                    style: AppTheme.onest(
                      size: 14,
                      heightPx: 22,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in cat.tags)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderStrong),
                          ),
                          child: Text(
                            t,
                            style: AppTheme.onest(
                              size: 12,
                              heightPx: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pilih tingkat kesulitan',
                    style: AppTheme.onest(
                      size: 14,
                      heightPx: 20,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _diff(context, app, Difficulty.pemula, 'Pemula'),
                      const SizedBox(width: 10),
                      _diff(context, app, Difficulty.menengah, 'Menengah'),
                      const SizedBox(width: 10),
                      _diff(context, app, Difficulty.ahli, 'Ahli'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _row(
                          Icons.assignment_outlined,
                          '${cat.questionCount} Soal',
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _row(
                          Icons.emoji_events_outlined,
                          'Skor Terbaik',
                          trailing: Text(
                            '${app.bestFor(id)}',
                            style: AppTheme.onest(
                              size: 18,
                              heightPx: 24,
                              weight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Mulai',
                    onTap: () {
                      app.startQuiz(id);
                      context.push('/kuis');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _diff(BuildContext context, AppState app, Difficulty d, String label) {
    final on = app.selectedDifficulty == d;
    return Expanded(
      child: GestureDetector(
        onTap: () => app.setDifficulty(d),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on
                ? AppColors.success.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: on ? AppColors.success : AppColors.borderStrong,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: AppTheme.onest(
              size: 13,
              heightPx: 20,
              weight: on ? FontWeight.w600 : FontWeight.w500,
              color: on ? AppColors.success : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, {required Widget trailing}) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.onest(
                  size: 15,
                  heightPx: 22,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
