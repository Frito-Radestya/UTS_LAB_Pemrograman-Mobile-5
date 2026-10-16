import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/quiz_data.dart';
import '../models/quiz_models.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/bolt_widgets.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.result});

  final QuizResult result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _retrying = false;

  QuizCategory? get _category {
    for (final category in quizCategories) {
      if (category.id == widget.result.categoryId) return category;
    }
    return null;
  }

  Future<void> _retry(QuizCategory category) async {
    if (_retrying) return;
    final state = AppScope.of(context);
    setState(() => _retrying = true);
    try {
      final active = state.activeCategory;
      // Even the same category may now contain a newer attempt from history.
      if (active != null) {
        final replace = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              active.id == category.id
                  ? 'Mulai ulang kuis?'
                  : 'Ganti kuis yang sedang berjalan?',
            ),
            content: Text(
              'Progres kuis ${active.title} yang belum selesai akan diganti. '
              'Hasil kuis yang sudah selesai tetap tersimpan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Mulai kuis baru'),
              ),
            ],
          ),
        );
        if (!mounted || replace != true) return;
      }
      await state.startQuiz(category, restart: true);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const QuizScreen()),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kuis belum dapat disimpan. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Review uses the supplied snapshot, never the mutable active quiz.
    final result = widget.result;
    final category = _category;
    final accuracy = result.accuracy;
    final space = context.space;
    final praise = accuracy >= 0.8
        ? 'Luar biasa!'
        : accuracy >= 0.6
        ? 'Kerja bagus!'
        : 'Tetap semangat!';
    final encouragement = accuracy >= 0.8
        ? 'Pemahamanmu sudah mantap. Siap untuk tantangan berikutnya?'
        : accuracy >= 0.6
        ? 'Sedikit latihan lagi, kamu bisa meraih hasil yang lebih baik.'
        : 'Setiap percobaan adalah langkah maju. Pelajari pembahasannya, yuk!';
    final completed = result.completedAt.toLocal();
    final date =
        '${completed.day.toString().padLeft(2, '0')}/'
        '${completed.month.toString().padLeft(2, '0')}/${completed.year} '
        '${completed.hour.toString().padLeft(2, '0')}:'
        '${completed.minute.toString().padLeft(2, '0')}';

    return PopScope(
      canPop: !_retrying,
      child: Scaffold(
        backgroundColor: context.colors.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(space),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ScreenHeader(title: 'Hasil kuis'),
                    SizedBox(height: space * 1.5),
                    Center(
                      child: StatusPill(
                        label: 'Kuis selesai',
                        icon: Icons.verified_rounded,
                        color: AppColors.green,
                      ),
                    ),
                    SizedBox(height: space),
                    Text(
                      praise,
                      textAlign: TextAlign.center,
                      style: context.text.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.playerName,
                      textAlign: TextAlign.center,
                      style: context.text.titleLarge,
                    ),
                    SizedBox(height: space / 2),
                    Text(
                      encouragement,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: space * 1.5),
                    BoltCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            result.categoryTitle,
                            textAlign: TextAlign.center,
                            style: context.text.titleMedium,
                          ),
                          SizedBox(height: space * 1.5),
                          _ScoreRing(accuracy: accuracy),
                          SizedBox(height: space),
                          Text(
                            '${result.correct} dari ${result.total} jawaban benar',
                            textAlign: TextAlign.center,
                            style: context.text.bodyLarge,
                          ),
                          SizedBox(height: space),
                          Center(
                            child: StatusPill(
                              label: '+${result.points} poin',
                              icon: Icons.bolt_rounded,
                              color: AppColors.yellow,
                            ),
                          ),
                          SizedBox(height: space),
                          Text(
                            'Diselesaikan $date',
                            textAlign: TextAlign.center,
                            style: context.text.bodySmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: space),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final largeText =
                            MediaQuery.textScalerOf(context).scale(14) > 20;
                        final columns =
                            constraints.maxWidth >= 270 && !largeText ? 3 : 1;
                        final width =
                            (constraints.maxWidth - (columns - 1) * 12) /
                            columns;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: width,
                              child: StatTile(
                                icon: Icons.check_circle_outline_rounded,
                                value: '${result.correct}',
                                label: 'Benar',
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: StatTile(
                                icon: Icons.cancel_outlined,
                                value: '${result.total - result.correct}',
                                label: 'Salah',
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: StatTile(
                                icon: Icons.timer_outlined,
                                value: _elapsed(result.elapsedSeconds),
                                label: 'Waktu pengerjaan',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: space * 1.5),
                    const SectionHeading(title: 'Pembahasan jawaban'),
                    const SizedBox(height: 8),
                    Text(
                      'Ketuk setiap soal untuk melihat jawaban dan penjelasannya.',
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: space),
                    if (category == null)
                      const BoltCard(
                        child: Text(
                          'Kategori ini tidak lagi tersedia. Ringkasan hasilmu '
                          'tetap dapat dilihat, tetapi pembahasan dan coba lagi '
                          'tidak tersedia.',
                        ),
                      )
                    else
                      for (
                        var index = 0;
                        index < category.questions.length;
                        index++
                      )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ReviewQuestion(
                            key: ValueKey('${result.completedAt}-$index'),
                            number: index + 1,
                            question: category.questions[index],
                            answer: index < result.answers.length
                                ? result.answers[index]
                                : null,
                          ),
                        ),
                    SizedBox(height: space),
                    BoltButton(
                      label: _retrying ? 'Menyiapkan kuis…' : 'Coba lagi',
                      icon: Icons.replay_rounded,
                      onPressed:
                          _retrying ||
                              category == null ||
                              category.questions.isEmpty
                          ? null
                          : () => _retry(category),
                    ),
                    const SizedBox(height: 12),
                    BoltButton(
                      label: 'Kembali ke beranda',
                      icon: Icons.home_outlined,
                      secondary: true,
                      onPressed: _retrying
                          ? null
                          : () => Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home',
                              (route) => false,
                            ),
                    ),
                    SizedBox(height: space),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _elapsed(int seconds) {
  final duration = Duration(seconds: seconds);
  if (duration.inHours > 0) {
    return '${duration.inHours}j ${duration.inMinutes % 60}m '
        '${duration.inSeconds % 60}d';
  }
  return '${duration.inMinutes}m ${duration.inSeconds % 60}d';
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.accuracy});

  final double accuracy;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final diameter = math.min(220.0, constraints.maxWidth);
      return Center(
        child: Semantics(
          label: 'Akurasi ${(accuracy * 100).round()} persen',
          child: ExcludeSemantics(
            child: SizedBox.square(
              dimension: diameter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      value: accuracy,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      color: AppColors.yellow,
                      backgroundColor: context.colors.surfaceContainerHighest,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(accuracy * 100).round()}%',
                            style: context.text.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Akurasi', style: context.text.bodyMedium),
                        ],
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
  );
}

class _ReviewQuestion extends StatelessWidget {
  const _ReviewQuestion({
    super.key,
    required this.number,
    required this.question,
    required this.answer,
  });

  final int number;
  final QuizQuestion question;
  final int? answer;

  @override
  Widget build(BuildContext context) {
    final correct = answer == question.correctIndex;
    final statusColor = correct ? AppColors.green : AppColors.red;
    return BoltCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(context.space),
        childrenPadding: EdgeInsets.fromLTRB(
          context.space,
          0,
          context.space,
          context.space,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text('Soal $number', style: context.text.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(question.prompt, style: context.text.bodyMedium),
        ),
        // A compact trailing control leaves room for long prompts and scaling.
        leading: Icon(
          correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: statusColor,
          semanticLabel: correct ? 'Benar' : 'Salah',
        ),
        children: [
          Text(
            correct ? 'Jawabanmu benar' : 'Mari pelajari lagi',
            style: context.text.labelLarge?.copyWith(color: statusColor),
          ),
          if (question.code != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText(
                  question.code!,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    height: 1.7,
                    color: context.colors.onSurface,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (answer == null ||
              answer! < 0 ||
              answer! >= question.options.length)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Jawabanmu: Tidak dijawab atau tidak tersedia'),
            ),
          for (var i = 0; i < question.options.length; i++) ...[
            _ReviewOption(
              label: '${String.fromCharCode(65 + i)}. ${question.options[i]}',
              selected: answer == i,
              correct: question.correctIndex == i,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text('Penjelasan', style: context.text.titleSmall),
          const SizedBox(height: 6),
          Text(question.explanation, style: context.text.bodyMedium),
        ],
      ),
    );
  }
}

class _ReviewOption extends StatelessWidget {
  const _ReviewOption({
    required this.label,
    required this.selected,
    required this.correct,
  });

  final String label;
  final bool selected;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final color = correct
        ? AppColors.green
        : selected
        ? AppColors.red
        : context.colors.outlineVariant;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: correct || selected ? color.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.text.bodyMedium),
          if (selected || correct) ...[
            const SizedBox(height: 6),
            Text(
              correct
                  ? selected
                        ? 'Jawabanmu • Jawaban benar'
                        : 'Jawaban benar'
                  : 'Jawabanmu',
              style: context.text.labelMedium?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
