import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/primary_button.dart';
import 'welcome_page.dart';

/// Halaman hasil: menampilkan nama, skor, persentase, dan pesan.
class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  String _messageFor(double percentage) {
    if (percentage >= 80) {
      return 'Luar biasa!';
    }
    if (percentage >= 50) {
      return 'Bagus!';
    }
    return 'Ayo coba lagi';
  }

  String _descriptionFor(double percentage) {
    if (percentage >= 80) {
      return 'Pemahaman Flutter dan Dart kamu sudah sangat kuat.';
    }
    if (percentage >= 50) {
      return 'Dasar-dasarnya sudah dikuasai. Sedikit latihan lagi!';
    }
    return 'Tidak masalah. Baca ulang materinya lalu coba sekali lagi.';
  }

  void _playAgain(BuildContext context, QuizProvider provider) {
    // Reset seluruh state lalu hapus semua halaman sebelumnya,
    // supaya back tidak membuka halaman kuis yang sudah selesai.
    provider.reset();
    Navigator.pushAndRemoveUntil(
      context,
      AppRoute.fade(const WelcomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = context.watch<QuizProvider>();
    final percentage = provider.percentage;
    final iconSize = responsive.shortestSide * 0.26;

    return Scaffold(
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minHeight = (constraints.maxHeight -
                    responsive.pagePadding * 2)
                .clamp(0.0, double.infinity);

            return SingleChildScrollView(
              padding: EdgeInsets.all(responsive.pagePadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.contentWidth,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/trophy.png',
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: responsive.gap),
                        Text(
                          'HASIL AKHIR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.bodySize * 0.72,
                            fontWeight: FontWeight.w400,
                            letterSpacing: responsive.bodySize * 0.18,
                            color: AppColors.accent,
                          ),
                        ),
                        SizedBox(height: responsive.smallGap),
                        Text(
                          provider.playerName,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: responsive.headingSize * 0.8,
                            fontWeight: FontWeight.w400,
                            letterSpacing: responsive.letterSpacing,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: responsive.gap),
                        // Angka skor dianimasikan naik dari 0.
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: provider.score.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Text(
                              value.round().toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: responsive.headingSize * 1.8,
                                height: 1,
                                fontWeight: FontWeight.w400,
                                letterSpacing: responsive.letterSpacing * 1.5,
                                color: AppColors.accent,
                              ),
                            );
                          },
                        ),
                        Text(
                          'dari ${provider.totalQuestions} soal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.bodySize,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: responsive.gap),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.pagePadding * 0.5,
                              vertical: responsive.smallGap,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                responsive.radius,
                              ),
                              border: Border.all(
                                color: AppColors.border,
                                width: responsive.shortestSide * 0.005,
                              ),
                            ),
                            child: Text(
                              '${percentage.round()}% benar',
                              style: TextStyle(
                                fontSize: responsive.bodySize,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.gap * 1.2),
                        Text(
                          _messageFor(percentage),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.headingSize * 0.5,
                            fontWeight: FontWeight.w400,
                            letterSpacing: responsive.letterSpacing,
                            color: AppColors.correct,
                          ),
                        ),
                        SizedBox(height: responsive.smallGap),
                        Text(
                          _descriptionFor(percentage),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.bodySize,
                            height: 1.5,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: responsive.gap * 1.6),
                        PrimaryButton(
                          label: 'Main Lagi',
                          icon: Icons.replay_rounded,
                          onPressed: () => _playAgain(context, provider),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
