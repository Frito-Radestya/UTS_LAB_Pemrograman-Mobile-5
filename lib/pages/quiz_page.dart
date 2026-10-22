import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/option_button.dart';
import '../widgets/primary_button.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_bar.dart';
import 'result_page.dart';

/// Halaman kuis: satu soal ditampilkan setiap kali.
/// Seluruh data dibaca dari QuizProvider supaya aman saat rotasi.
class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  void _handleNext(BuildContext context, QuizProvider provider) {
    if (provider.isLastQuestion) {
      // Selesai: ganti halaman kuis dengan halaman hasil memakai fade.
      Navigator.pushReplacement(context, AppRoute.fade(const ResultPage()));
      return;
    }

    provider.next();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = context.watch<QuizProvider>();
    final question = provider.currentQuestion;

    return Scaffold(
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minHeight = (constraints.maxHeight -
                    responsive.pagePadding * 2)
                .clamp(0.0, double.infinity);

            return SingleChildScrollView(
              // Key berubah tiap soal agar posisi scroll kembali ke atas.
              key: ValueKey<int>(provider.currentIndex),
              padding: EdgeInsets.all(responsive.pagePadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.contentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PEMAIN',
                                    style: TextStyle(
                                      fontSize: responsive.bodySize * 0.7,
                                      letterSpacing: responsive.bodySize * 0.14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: responsive.smallGap * 0.4),
                                  Text(
                                    provider.playerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: responsive.bodySize * 1.25,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: responsive.gap),
                            Text(
                              'Soal ${provider.currentIndex + 1} dari '
                              '${provider.totalQuestions}',
                              style: TextStyle(
                                fontSize: responsive.bodySize * 0.9,
                                fontWeight: FontWeight.w400,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.gap),
                        QuizProgressBar(
                          current: provider.currentIndex + 1,
                          total: provider.totalQuestions,
                        ),
                        SizedBox(height: responsive.gap),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Column(
                            key: ValueKey<int>(provider.currentIndex),
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              QuestionCard(text: question.text),
                              SizedBox(height: responsive.gap),
                              for (var i = 0; i < question.options.length; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: responsive.smallGap,
                                  ),
                                  child: OptionButton(
                                    optionLabel: String.fromCharCode(65 + i),
                                    label: question.options[i],
                                    selected: provider.selectedAnswer == i,
                                    onTap: () => provider.selectAnswer(i),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: responsive.gap * 1.4),
                        PrimaryButton(
                          label: provider.isLastQuestion ? 'Selesai' : 'Lanjut',
                          icon: provider.isLastQuestion
                              ? Icons.flag_rounded
                              : Icons.arrow_forward_rounded,
                          onPressed: provider.selectedAnswer == null
                              ? null
                              : () => _handleNext(context, provider),
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
