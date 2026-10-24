import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/kage_achievement_badge.dart';
import '../widgets/kage_stat_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'quiz_page.dart';

/// Halaman hasil: menyimpan skor, lalu menampilkan ringkasan dan pesan.
class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();

    // Simpan tepat sekali setelah frame pertama. Dengan begitu perubahan
    // provider tidak terjadi saat pohon widget sedang dibangun, dan rotasi
    // atau rebuild tidak menggandakan riwayat.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<QuizProvider>().saveResult();
    });
  }

  String _messageFor(double percentage) {
    if (percentage >= 80) {
      return 'Kamu Hebat!';
    }
    if (percentage >= 50) {
      return 'Kerja Bagus!';
    }
    return 'Ayo Coba Lagi';
  }

  String _descriptionFor(double percentage) {
    if (percentage >= 80) {
      return 'Pemahamanmu sudah sangat kuat. Pertahankan api semangat ini.';
    }
    if (percentage >= 50) {
      return 'Dasar-dasarnya sudah dikuasai. Sedikit latihan lagi!';
    }
    return 'Tidak masalah. Baca ulang materinya lalu coba sekali lagi.';
  }

  void _playAgain(BuildContext context, QuizProvider provider) {
    // Ulangi kategori yang sama dengan progres kosong. Riwayat skor tetap
    // tersimpan karena hanya resetQuiz() yang dipanggil.
    provider.resetQuiz();
    Navigator.pushReplacement(context, AppRoute.fade(const QuizPage()));
  }

  Widget _buildSummary(
    Responsive responsive,
    QuizProvider provider,
    double percentage,
  ) {
    // Di landscape jarak antarbagian dirapatkan supaya badge persentase
    // tidak terpotong di layar pendek.
    final gap = responsive.isLandscape
        ? responsive.smallGap * 1.2
        : responsive.gap;
    final scoreSize =
        responsive.headingSize * (responsive.isLandscape ? 1.3 : 1.8);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KageAchievementBadge(
          percentage: percentage,
          isFirstAttempt: provider.completedCount <= 1,
        ),
        SizedBox(height: gap),
        Text(
          'HASIL AKHIR',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: responsive.bodySize * 0.72,
            fontWeight: AppTypography.label,
            letterSpacing: responsive.bodySize * 0.18,
            color: AppColors.antiqueGold,
          ),
        ),
        SizedBox(height: responsive.smallGap * 0.6),
        Text(
          provider.activeCategory.title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: responsive.bodySize * 1.02,
            fontWeight: AppTypography.title,
            color: AppColors.ivory,
          ),
        ),
        SizedBox(height: responsive.smallGap * 0.35),
        Text(
          provider.playerName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: responsive.bodySize * 0.78,
            fontWeight: AppTypography.label,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: gap),
        // Angka skor dianimasikan naik dari 0.
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: provider.score.toDouble()),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Text(
              value.round().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: scoreSize,
                height: 1,
                fontWeight: AppTypography.hero,
                letterSpacing: responsive.letterSpacing * 1.5,
                color: AppColors.vermilionLight,
              ),
            );
          },
        ),
        SizedBox(height: responsive.smallGap * 0.3),
        Text(
          'dari ${provider.totalQuestions} soal',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: responsive.bodySize * 0.82,
            fontWeight: AppTypography.label,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: gap),
        Row(
          children: [
            Expanded(
              child: KageStatCard(label: 'Benar', value: '${provider.score}'),
            ),
            SizedBox(width: responsive.smallGap),
            Expanded(
              child: KageStatCard(
                label: 'Salah',
                value: '${provider.wrongCount}',
              ),
            ),
            SizedBox(width: responsive.smallGap),
            Expanded(
              child: KageStatCard(
                label: 'Akurasi',
                value: '${percentage.round()}%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedback(
    BuildContext context,
    Responsive responsive,
    QuizProvider provider,
    double percentage,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _messageFor(percentage),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: responsive.headingSize * 0.55,
            fontWeight: AppTypography.heading,
            letterSpacing: responsive.letterSpacing,
            color: AppColors.ivory,
          ),
        ),
        SizedBox(height: responsive.smallGap),
        Text(
          _descriptionFor(percentage),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: responsive.bodySize,
            height: 1.5,
            fontWeight: AppTypography.body,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: responsive.gap * 1.6),
        PrimaryButton(
          label: 'Coba Lagi',
          icon: Icons.replay_rounded,
          onPressed: () => _playAgain(context, provider),
        ),
        SizedBox(height: responsive.smallGap * 0.8),
        SecondaryButton(
          label: 'Kembali',
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = context.watch<QuizProvider>();
    final percentage = provider.percentage;

    return Scaffold(
      body: AppBackground(
        imageAsset: AppAssets.result,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final verticalPadding =
                responsive.pagePadding * (responsive.isLandscape ? 0.45 : 1);
            final minHeight = (constraints.maxHeight - verticalPadding * 2)
                .clamp(0.0, double.infinity);

            final summary = _buildSummary(responsive, provider, percentage);
            final feedback = _buildFeedback(
              context,
              responsive,
              provider,
              percentage,
            );

            // Di landscape, ringkasan skor dan pesan disusun berdampingan
            // agar tombol Coba Lagi tetap terlihat tanpa scroll.
            final content = responsive.isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: summary),
                      SizedBox(width: responsive.pagePadding),
                      Expanded(child: feedback),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      summary,
                      SizedBox(height: responsive.gap),
                      feedback,
                    ],
                  );

            return SingleChildScrollView(
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
                    child: content,
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
