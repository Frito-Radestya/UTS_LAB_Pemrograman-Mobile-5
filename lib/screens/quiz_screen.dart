import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/quiz_models.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/bolt_widgets.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  final _scrollController = ScrollController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // The clock is owned by AppState; this timer only refreshes its display.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_submitting) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      _message('Perubahan belum tersimpan. Periksa penyimpanan perangkatmu.');
    }
  }

  void _goToQuestion(int index) {
    final state = AppScope.of(context);
    _save(() => state.goToQuestion(index));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final state = AppScope.of(context);
    if (state.answeredCount != state.totalQuestions) return;
    setState(() => _submitting = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kumpulkan jawaban?'),
        content: Text(
          'Semua ${state.totalQuestions} soal sudah dijawab. '
          '${state.flagged.isEmpty ? '' : 'Masih ada ${state.flagged.length} soal ditandai. '}'
          'Setelah dikumpulkan, jawaban tidak bisa diubah.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Periksa lagi'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, kumpulkan'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) {
      setState(() => _submitting = false);
      return;
    }

    QuizResult? completed;
    try {
      final previousCount = state.completedResults.length;
      final submission = state.finishQuiz();
      // finishQuiz clears the active quiz synchronously. Keep its result even
      // if persisting fails, so the player is not stranded on an empty quiz.
      if (state.completedResults.length > previousCount) {
        completed = state.completedResults.first;
      }
      completed = await submission;
    } catch (_) {
      if (!mounted) return;
      _message(
        completed == null
            ? 'Kuis belum dapat dikumpulkan. Silakan coba lagi.'
            : 'Hasil tersedia, tetapi belum tersimpan di perangkat.',
      );
    }
    if (!mounted) return;
    if (completed == null) {
      setState(() => _submitting = false);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => ResultScreen(result: completed!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final category = state.activeCategory;
    final question = category == null || category.questions.isEmpty
        ? null
        : state.currentQuestion;
    final space = context.space;

    return PopScope(
      canPop: !_submitting,
      child: Scaffold(
        backgroundColor: context.colors.surface,
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: _submitting,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(space),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: category == null || question == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const ScreenHeader(title: 'Kuis'),
                            SizedBox(height: space * 2),
                            BoltCard(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.quiz_outlined,
                                    size: 48,
                                    color: context.colors.primary,
                                  ),
                                  SizedBox(height: space),
                                  Text(
                                    _submitting
                                        ? 'Menyiapkan hasilmu…'
                                        : 'Belum ada kuis aktif',
                                    style: context.text.titleLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: space),
                                  if (_submitting)
                                    const CircularProgressIndicator()
                                  else ...[
                                    const Text(
                                      'Pilih kategori di beranda untuk mulai belajar.',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: space),
                                    BoltButton(
                                      label: 'Kembali ke beranda',
                                      icon: Icons.home_outlined,
                                      onPressed: () => Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                            '/home',
                                            (route) => false,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const ScreenHeader(title: 'Sesi kuis', back: true),
                            SizedBox(height: space),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                StatusPill(
                                  label: category.title,
                                  icon: category.icon,
                                  color: AppColors.yellow,
                                ),
                                StatusPill(
                                  label: _duration(state.activeElapsedSeconds),
                                  icon: Icons.timer_outlined,
                                ),
                                StatusPill(label: category.difficulty),
                              ],
                            ),
                            SizedBox(height: space * 1.5),
                            Text(
                              'Soal ${state.questionIndex + 1} dari ${state.totalQuestions}',
                              style: context.text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${state.answeredCount}/${state.totalQuestions} terjawab',
                              style: context.text.bodyMedium?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: state.progress,
                                minHeight: 7,
                                color: AppColors.yellow,
                                backgroundColor:
                                    context.colors.surfaceContainerHighest,
                                semanticsLabel:
                                    '${state.answeredCount} dari ${state.totalQuestions} soal dijawab',
                                semanticsValue:
                                    '${(state.progress * 100).round()}%',
                              ),
                            ),
                            SizedBox(height: space * 1.5),
                            BoltCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PILIH SATU JAWABAN',
                                    style: context.text.labelSmall?.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: space),
                                  Text(
                                    question.prompt,
                                    style: context.text.titleLarge?.copyWith(
                                      height: 1.4,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (question.code != null) ...[
                                    SizedBox(height: space),
                                    _CodeBlock(code: question.code!),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: space),
                            for (var i = 0; i < question.options.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _AnswerOption(
                                  index: i,
                                  label: question.options[i],
                                  selected: state.currentAnswer == i,
                                  onTap: () {
                                    if (state.soundEnabled) {
                                      SystemSound.play(SystemSoundType.click);
                                    }
                                    _save(() => state.selectAnswer(i));
                                  },
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => _save(state.toggleFlag),
                                icon: Icon(
                                  state.flagged.contains(state.questionIndex)
                                      ? Icons.flag_rounded
                                      : Icons.outlined_flag_rounded,
                                ),
                                label: Text(
                                  state.flagged.contains(state.questionIndex)
                                      ? 'Hapus tanda soal'
                                      : 'Tandai untuk diperiksa lagi',
                                ),
                              ),
                            ),
                            SizedBox(height: space),
                            BoltCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SectionHeading(title: 'Navigasi soal'),
                                  SizedBox(height: space),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(
                                      state.totalQuestions,
                                      (index) => _QuestionNumber(
                                        number: index + 1,
                                        current: state.questionIndex == index,
                                        answered: state.answers.containsKey(
                                          index,
                                        ),
                                        flagged: state.flagged.contains(index),
                                        onTap: () => _goToQuestion(index),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: space),
                                  const Wrap(
                                    spacing: 14,
                                    runSpacing: 10,
                                    children: [
                                      _Legend(
                                        icon: Icons.radio_button_checked,
                                        label: 'Saat ini',
                                        color: AppColors.yellow,
                                      ),
                                      _Legend(
                                        icon: Icons.check_circle_outline,
                                        label: 'Terjawab',
                                      ),
                                      _Legend(
                                        icon: Icons.circle_outlined,
                                        label: 'Belum dijawab',
                                      ),
                                      _Legend(
                                        icon: Icons.flag_outlined,
                                        label: 'Ditandai',
                                        color: AppColors.yellow,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: space * 1.5),
                            BoltButton(
                              label: 'Sebelumnya',
                              secondary: true,
                              icon: Icons.arrow_back_rounded,
                              onPressed: state.questionIndex == 0
                                  ? null
                                  : () =>
                                        _goToQuestion(state.questionIndex - 1),
                            ),
                            const SizedBox(height: 12),
                            if (state.questionIndex < state.totalQuestions - 1)
                              BoltButton(
                                label: 'Soal berikutnya',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () =>
                                    _goToQuestion(state.questionIndex + 1),
                              )
                            else ...[
                              if (state.answeredCount <
                                  state.totalQuestions) ...[
                                Text(
                                  'Masih ada ${state.totalQuestions - state.answeredCount} '
                                  'soal belum dijawab. Jawab semua soal sebelum mengumpulkan.',
                                  style: context.text.bodyMedium,
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    final first =
                                        List.generate(
                                          state.totalQuestions,
                                          (index) => index,
                                        ).firstWhere(
                                          (index) =>
                                              !state.answers.containsKey(index),
                                        );
                                    _goToQuestion(first);
                                  },
                                  icon: const Icon(Icons.search_rounded),
                                  label: const Text(
                                    'Ke soal pertama yang belum dijawab',
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              BoltButton(
                                label: _submitting
                                    ? 'Mengumpulkan…'
                                    : 'Kumpulkan jawaban',
                                icon: Icons.check_rounded,
                                onPressed:
                                    state.answeredCount ==
                                            state.totalQuestions &&
                                        !_submitting
                                    ? _submit
                                    : null,
                              ),
                            ],
                            SizedBox(height: space),
                            Text(
                              'Jawaban dan tanda soal disimpan otomatis. '
                              'Kamu bisa kembali dan melanjutkan nanti.',
                              textAlign: TextAlign.center,
                              style: context.text.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _duration(int seconds) {
  final duration = Duration(seconds: seconds);
  final minutes = duration.inMinutes.toString().padLeft(2, '0');
  final remainder = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$remainder';
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.index,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.yellow : context.colors.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: BoltCard(
        color: selected
            ? AppColors.yellow.withValues(alpha: 0.12)
            : context.colors.surfaceContainerLow,
        onTap: onTap,
        padding: EdgeInsets.all(context.space),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.yellow
                    : context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                String.fromCharCode(65 + index),
                style: context.text.labelLarge?.copyWith(
                  color: selected ? Colors.black : context.colors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(label, style: context.text.bodyLarge),
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.radio_button_checked,
                  color: AppColors.yellow,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _QuestionNumber extends StatelessWidget {
  const _QuestionNumber({
    required this.number,
    required this.current,
    required this.answered,
    required this.flagged,
    required this.onTap,
  });

  final int number;
  final bool current;
  final bool answered;
  final bool flagged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = current ? Colors.black : context.colors.onSurface;
    return Semantics(
      button: true,
      selected: current,
      label:
          'Soal $number, ${answered ? 'terjawab' : 'belum dijawab'}'
          '${flagged ? ', ditandai' : ''}',
      child: Material(
        color: current
            ? AppColors.yellow
            : answered
            ? AppColors.yellow.withValues(alpha: 0.12)
            : context.colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: current || answered
                ? AppColors.yellow
                : context.colors.outlineVariant,
            width: current ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 52, minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$number',
                    style: context.text.labelLarge?.copyWith(color: foreground),
                  ),
                  if (flagged || answered)
                    Icon(
                      flagged ? Icons.flag_rounded : Icons.check_rounded,
                      size: 13,
                      color: foreground,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: color ?? context.colors.onSurfaceVariant),
      const SizedBox(width: 5),
      Flexible(child: Text(label, style: context.text.bodySmall)),
    ],
  );
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final tokens = RegExp(
      r'''(//[^\n]*|"[^"\n]*"|'[^'\n]*'|\b(?:final|const|var|void|return|if|else|class|int|String|print|true|false|null|await|async)\b|\b\d+\b)''',
    );
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final match in tokens.allMatches(code)) {
      spans.add(TextSpan(text: code.substring(cursor, match.start)));
      final token = match.group(0)!;
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(
            color: token.startsWith('//')
                ? context.colors.onSurfaceVariant
                : token.startsWith('"') || token.startsWith("'")
                ? AppColors.green
                : AppColors.yellow,
          ),
        ),
      );
      cursor = match.end;
    }
    spans.add(TextSpan(text: code.substring(cursor)));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText.rich(
          TextSpan(children: spans),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            height: 1.7,
            color: context.colors.onSurface,
          ),
        ),
      ),
    );
  }
}
