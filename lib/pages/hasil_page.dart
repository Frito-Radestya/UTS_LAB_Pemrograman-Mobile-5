import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/quiz_data.dart';
import '../models/models.dart';
import '../state/quiz_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class HasilPage extends StatelessWidget {
  const HasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizController>();
    final r = quiz.lastResult;
    if (r == null) {
      return const Scaffold(backgroundColor: AppColors.background);
    }
    final cat = categoryById(r.categoryId);
    final time =
        '${r.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${r.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    final title = r.score >= 90
        ? 'Luar Biasa!'
        : r.score >= 70
        ? 'Kamu Hebat!'
        : r.score >= 50
        ? 'Terus Berlatih!'
        : 'Jangan Menyerah!';
    final subtitle = r.score >= 90
        ? 'Penguasaan materimu sangat baik.'
        : r.score >= 70
        ? 'Sedikit lagi menuju skor sempurna.'
        : 'Setiap percobaan membuatmu semakin paham.';
    final difficulty = switch (r.difficulty) {
      Difficulty.pemula => 'Pemula',
      Difficulty.menengah => 'Menengah',
      Difficulty.ahli => 'Ahli',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top radial glow
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 380,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.44),
                  radius: 0.9,
                  colors: [
                    Color(0x73B9232C),
                    Color(0x405A1428),
                    Color(0x000B0D12),
                  ],
                  stops: [0, 0.38, 0.72],
                ),
              ),
            ),
          ),
          // Animated petals
          const AnimatedSakuraPetal(
            left: 16,
            top: 40,
            width: 11,
            height: 8,
            angle: 30,
            opacity: 0.85,
            duration: Duration(seconds: 5),
            delayFraction: 0.0,
          ),
          const AnimatedSakuraPetal(
            left: 60,
            top: 20,
            width: 9,
            height: 6,
            angle: -20,
            opacity: 0.8,
            color: Color(0xFFF09AB0),
            duration: Duration(seconds: 6),
            delayFraction: 0.4,
          ),
          // Right side petals via LayoutBuilder so they don't overflow
          LayoutBuilder(
            builder: (context, constraints) {
              final w = MediaQuery.sizeOf(context).width;
              return Stack(
                children: [
                  AnimatedSakuraPetal(
                    left: w - 52,
                    top: 30,
                    width: 12,
                    height: 8,
                    angle: 60,
                    opacity: 0.85,
                    duration: const Duration(seconds: 4),
                    delayFraction: 0.65,
                  ),
                  AnimatedSakuraPetal(
                    left: w - 72,
                    top: 20,
                    width: 9,
                    height: 6,
                    angle: 10,
                    opacity: 0.8,
                    color: const Color(0xFFF09AB0),
                    duration: const Duration(seconds: 7),
                    delayFraction: 0.2,
                  ),
                  const AnimatedSakuraPetal(
                    left: 16,
                    top: 80,
                    width: 10,
                    height: 7,
                    angle: -50,
                    opacity: 0.7,
                    duration: Duration(seconds: 5),
                    delayFraction: 0.8,
                  ),
                  AnimatedSakuraPetal(
                    left: w - 62,
                    top: 60,
                    width: 10,
                    height: 7,
                    angle: 40,
                    opacity: 0.7,
                    color: const Color(0xFFF09AB0),
                    duration: const Duration(seconds: 6),
                    delayFraction: 0.5,
                  ),
                ],
              );
            },
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                children: [
                  const _HasilEmblem(),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppTheme.onest(
                      size: 28,
                      heightPx: 36,
                      weight: FontWeight.w700,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.onest(
                      size: 13,
                      heightPx: 19,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryIconBadge(category: cat, size: 28, iconSize: 14),
                      const SizedBox(width: 8),
                      Text(
                        '${cat.name} · $difficulty',
                        style: AppTheme.onest(
                          size: 13,
                          heightPx: 18,
                          weight: FontWeight.w500,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Skor Akhir',
                    style: AppTheme.onest(
                      size: 14,
                      heightPx: 20,
                      color: AppColors.textSoft,
                    ),
                  ),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: r.score),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      '$value',
                      style:
                          AppTheme.onest(
                            size: 72,
                            heightPx: 80,
                            weight: FontWeight.w700,
                          ).copyWith(
                            shadows: [
                              Shadow(
                                color: AppColors.primary.withValues(alpha: 0.6),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${r.correct}/${r.total} Benar',
                      style: AppTheme.onest(
                        size: 14,
                        heightPx: 24,
                        weight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _card(Icons.schedule, 'Waktu', time),
                      const SizedBox(width: 12),
                      _card(Icons.gps_fixed, 'Akurasi', '${r.accuracy}%'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
                    child: Text(
                      '"Pengetahuan adalah cahaya yang tak pernah padam."',
                      textAlign: TextAlign.center,
                      style: AppTheme.onest(
                        size: 14,
                        heightPx: 22,
                        color: AppColors.textQuote,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  PrimaryButton(
                    label: 'Coba Lagi',
                    onTap: () {
                      quiz.startQuiz(r.categoryId);
                      context.go('/kuis');
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlineButton(
                    label: 'Kembali ke Beranda',
                    onTap: () => context.go('/beranda'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTheme.onest(
                    size: 13,
                    heightPx: 18,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTheme.onest(
                size: 24,
                heightPx: 32,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HasilEmblem extends StatelessWidget {
  const _HasilEmblem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(painter: _EmblemPainter()),
    );
  }
}

class _EmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      c,
      74,
      Paint()
        ..color = const Color(0xFF1A0E12)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      c,
      74,
      Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(
      c,
      54,
      Paint()
        ..color = const Color(0xFFE0B86A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final petal = Paint()..color = AppColors.gold;
    for (var i = 0; i < 5; i++) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(i * 72 * 3.14159 / 180);
      canvas.drawOval(const Rect.fromLTWH(-11, -34, 22, 40), petal);
      canvas.restore();
    }
    canvas.drawCircle(c, 11, Paint()..color = AppColors.primary);
    canvas.drawCircle(
      c,
      11,
      Paint()
        ..color = AppColors.goldLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
