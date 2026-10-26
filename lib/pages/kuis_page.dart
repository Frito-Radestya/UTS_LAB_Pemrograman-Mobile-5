import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/quiz_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class KuisPage extends StatelessWidget {
  const KuisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final q = app.currentQuestion;
    final cat = app.activeCategory == null
        ? null
        : categoryById(app.activeCategory!);
    if (q == null || cat == null) {
      return const Scaffold(backgroundColor: AppColors.background);
    }
    final selected = app.answers[app.questionIndex];
    final locked = app.currentQuestionLocked;
    const letters = ['A', 'B', 'C', 'D'];
    final total = app.totalQuestions;
    final diff = switch (app.selectedDifficulty) {
      Difficulty.pemula => 'PEMULA',
      Difficulty.menengah => 'MENENGAH',
      Difficulty.ahli => 'AHLI',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Bottom glow
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, 1),
                  radius: 1.1,
                  colors: [
                    Color(0x47F28C3C),
                    Color(0x1FB9232C),
                    Color(0x000B0D12),
                  ],
                  stops: [0, 0.4, 0.75],
                ),
              ),
            ),
          ),
          // Animated lanterns
          const Positioned(
            left: 16,
            bottom: 100,
            child: AnimatedLantern(
              opacity: 0.75,
              duration: Duration(milliseconds: 1900),
            ),
          ),
          const Positioned(
            right: 16,
            bottom: 120,
            child: AnimatedLantern(
              opacity: 0.75,
              duration: Duration(milliseconds: 2300),
              delayFraction: 0.5,
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-12, 0),
                          child: BackIconButton(
                            label: 'Keluar dari kuis',
                            onTap: () => _confirmExit(context, app),
                          ),
                        ),
                        Expanded(
                          child: KageProgressBar(
                            value: (app.questionIndex + 1) / total,
                            glow: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '${app.questionIndex + 1}/$total',
                            textAlign: TextAlign.right,
                            style: AppTheme.onest(
                              size: 14,
                              heightPx: 20,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Scrollable body so options never overflow
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cat.name.toUpperCase()} · $diff',
                          style: AppTheme.onest(
                            size: 13,
                            heightPx: 18,
                            color: AppColors.gold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          q.prompt,
                          style: AppTheme.onest(
                            size: 20,
                            heightPx: 30,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        for (var i = 0; i < q.options.length; i++) ...[
                          _option(
                            letter: letters[i],
                            text: q.options[i],
                            selected: selected == i,
                            locked: locked,
                            onTap: locked ? null : () => app.selectAnswer(i),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (locked) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.lock_outline,
                                size: 16,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Jawaban sudah dikirim dan terkunci.',
                                  style: AppTheme.onest(
                                    size: 12,
                                    heightPx: 18,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            OutlineButton(
                              label: 'Simpan',
                              width: 112,
                              onTap: () {
                                app.saveProgress();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Progres disimpan. Lanjutkan kapan saja dari Beranda.',
                                    ),
                                    backgroundColor: AppColors.surface,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                label: locked
                                    ? 'Lihat Penjelasan'
                                    : 'Selanjutnya',
                                onTap: locked
                                    ? () => context.push('/penjelasan')
                                    : selected == null
                                    ? null
                                    : () {
                                        app.submitCurrent();
                                        context.push('/penjelasan');
                                      },
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Future<void> _confirmExit(BuildContext context, AppState app) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderStrong),
        ),
        title: Text(
          'Keluar dari kuis?',
          style: AppTheme.onest(
            size: 18,
            heightPx: 26,
            weight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Progres jawabanmu akan disimpan dan bisa dilanjutkan dari Beranda.',
          style: AppTheme.onest(
            size: 14,
            heightPx: 21,
            color: AppColors.textSoft,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Batal',
              style: AppTheme.onest(
                size: 14,
                heightPx: 20,
                weight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Simpan & keluar',
              style: AppTheme.onest(
                size: 14,
                heightPx: 20,
                weight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
    if (shouldLeave == true && context.mounted) {
      app.saveProgress();
      context.pop();
    }
  }

  Widget _option({
    required String letter,
    required String text,
    required bool selected,
    required bool locked,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: locked ? 0.1 : 0.16)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: selected && !locked
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 18,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: selected
                    ? null
                    : Border.all(color: AppColors.outline, width: 1.5),
              ),
              child: Text(
                letter,
                style: AppTheme.onest(
                  size: 14,
                  heightPx: 18,
                  weight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? AppColors.text : AppColors.textSoft,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: AppTheme.onest(
                  size: 15,
                  heightPx: 22,
                  weight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (selected)
              Icon(
                locked ? Icons.lock_outline : Icons.check,
                color: AppColors.text,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
