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

  Widget _buildOptions(Responsive responsive, QuizProvider provider) {
    final question = provider.currentQuestion;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.options.length; i++)
          Padding(
            // Jarak antaropsi dirapatkan sedikit di landscape.
            padding: EdgeInsets.only(
              bottom: responsive.smallGap * (responsive.isLandscape ? 0.6 : 1),
            ),
            child: OptionButton(
              optionLabel: String.fromCharCode(65 + i),
              label: question.options[i],
              selected: provider.selectedAnswer == i,
              onTap: () => provider.selectAnswer(i),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionContent(
    BuildContext context,
    Responsive responsive,
    QuizProvider provider,
  ) {
    final question = provider.currentQuestion;
    final options = _buildOptions(responsive, provider);
    final nextButton = PrimaryButton(
      label: provider.isLastQuestion ? 'Selesai' : 'Lanjut',
      icon: provider.isLastQuestion
          ? Icons.flag_rounded
          : Icons.arrow_forward_rounded,
      onPressed: provider.selectedAnswer == null
          ? null
          : () => _handleNext(context, provider),
    );

    // Di landscape, kartu soal dan pilihan jawaban berdampingan
    // supaya seluruh konten muat tanpa scroll panjang.
    if (responsive.isLandscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: QuestionCard(text: question.text)),
          SizedBox(width: responsive.gap),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                options,
                // Jarak ke tombol dirapatkan agar tombol tetap terlihat.
                SizedBox(height: responsive.smallGap * 1.2),
                nextButton,
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionCard(text: question.text),
        SizedBox(height: responsive.gap),
        options,
        SizedBox(height: responsive.gap * 1.4),
        nextButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      body: AppBackground(
        imageAsset: AppAssets.quiz,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final verticalPadding =
                responsive.pagePadding * (responsive.isLandscape ? 0.45 : 1);
            final minHeight = (constraints.maxHeight - verticalPadding * 2)
                .clamp(0.0, double.infinity);
            // Jarak antarbagian sedikit dirapatkan di landscape agar
            // tombol Lanjut tetap terlihat tanpa scroll.
            final sectionGap = responsive.isLandscape
                ? responsive.smallGap * 1.2
                : responsive.gap;

            return SingleChildScrollView(
              // Key berubah tiap soal agar posisi scroll kembali ke atas.
              key: ValueKey<int>(provider.currentIndex),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.pagePadding,
                vertical: verticalPadding,
              ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const _QuizBackButton(),
                            SizedBox(width: responsive.pagePadding * 0.35),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.activeCategory.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: responsive.bodySize * 0.7,
                                      letterSpacing: responsive.bodySize * 0.08,
                                      fontWeight: AppTypography.label,
                                      color: AppColors.antiqueGold,
                                    ),
                                  ),
                                  SizedBox(height: responsive.smallGap * 0.3),
                                  Text(
                                    provider.playerName.isEmpty
                                        ? 'Pemain'
                                        : provider.playerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: responsive.bodySize * 1.15,
                                      fontWeight: AppTypography.title,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: responsive.smallGap),
                            Text(
                              'Soal ${provider.currentIndex + 1} dari '
                              '${provider.totalQuestions}',
                              style: TextStyle(
                                fontSize: responsive.bodySize * 0.82,
                                fontWeight: AppTypography.label,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sectionGap),
                        QuizProgressBar(
                          current: provider.currentIndex + 1,
                          total: provider.totalQuestions,
                        ),
                        SizedBox(height: sectionGap),
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
                          child: KeyedSubtree(
                            key: ValueKey<int>(provider.currentIndex),
                            child: _buildQuestionContent(
                              context,
                              responsive,
                              provider,
                            ),
                          ),
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

/// Tombol kembali di layar kuis.
class _QuizBackButton extends StatelessWidget {
  const _QuizBackButton();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = responsive.bodySize * 2.4;
    final radius = responsive.radius * 0.7;

    return Semantics(
      button: true,
      label: 'Kembali',
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
            color: AppColors.border,
            width: responsive.shortestSide * 0.004,
          ),
        ),
        child: InkWell(
          key: const Key('quiz-back'),
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.arrow_back_rounded,
              size: responsive.bodySize * 1.05,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
