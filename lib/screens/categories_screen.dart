import 'package:flutter/material.dart';

import '../data/quiz_data.dart';
import '../models/quiz_models.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/bolt_widgets.dart';
import 'quiz_screen.dart';

// Both entry points use the same replacement confirmation and persistence flow.
Future<void> openCategoryQuiz(
  BuildContext context,
  QuizCategory category,
) async {
  final state = AppScope.of(context);
  final active = state.activeCategory;
  if (active != null && active.id != category.id) {
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti kuis yang sedang berjalan?'),
        content: Text(
          'Progres ${active.title} akan diganti dengan kuis ${category.title}. '
          'Hasil kuis yang sudah selesai tetap tersimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ganti kuis'),
          ),
        ],
      ),
    );
    if (replace != true || !context.mounted) return;
  }
  try {
    await state.startQuiz(category);
    if (!context.mounted) return;
    await Navigator.of(context)
        .push<void>(MaterialPageRoute(builder: (_) => const QuizScreen()));
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kuis belum dapat dibuka. Silakan coba lagi.'),
      ),
    );
  }
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _search = TextEditingController();
  String _difficulty = 'Semua';
  bool _opening = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _open(QuizCategory category) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      await openCategoryQuiz(context, category);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final space = context.space;
    final query = _search.text.trim().toLowerCase();
    final categories = quizCategories.where((category) {
      return (_difficulty == 'Semua' || category.difficulty == _difficulty) &&
          ('${category.title} ${category.subtitle}'.toLowerCase().contains(
            query,
          ));
    }).toList();

    return SingleChildScrollView(
      key: const PageStorageKey('categories-scroll'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.all(space),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'Kategori Kuis'),
              SizedBox(height: space),
              const StatusPill(
                label: 'JELAJAHI PENGETAHUAN',
                icon: Icons.explore,
              ),
              SizedBox(height: space),
              Text('Pilih tantanganmu.', style: context.text.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Dari hal yang kamu suka, jadi hal yang kamu kuasai.',
                style: context.text.bodyLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: space * 1.5),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Cari kategori atau topik...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: () => setState(_search.clear),
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: context.colors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: context.colors.outlineVariant,
                    ),
                  ),
                ),
              ),
              SizedBox(height: space),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final difficulty in [
                    'Semua',
                    'Mudah',
                    'Sedang',
                    'Sulit',
                  ])
                    ChoiceChip(
                      label: Text(difficulty),
                      selected: _difficulty == difficulty,
                      selectedColor: AppColors.yellow,
                      labelStyle: TextStyle(
                        color: _difficulty == difficulty
                            ? Colors.black
                            : context.colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      checkmarkColor: Colors.black,
                      onSelected: (_) =>
                          setState(() => _difficulty = difficulty),
                    ),
                ],
              ),
              SizedBox(height: space * 1.5),
              SectionHeading(title: '${categories.length} kategori tersedia'),
              SizedBox(height: space),
              if (categories.isEmpty)
                BoltCard(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 44),
                      SizedBox(height: space),
                      Text(
                        'Belum ada yang cocok',
                        style: context.text.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Coba kata kunci lain atau pilih tingkat kesulitan Semua.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: space),
                      BoltButton(
                        label: 'Reset filter',
                        secondary: true,
                        onPressed: () => setState(() {
                          _search.clear();
                          _difficulty = 'Semua';
                        }),
                      ),
                    ],
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth < 640 ? 1 : 2;
                    final width =
                        (constraints.maxWidth - space * (columns - 1)) /
                        columns;
                    return Wrap(
                      spacing: space,
                      runSpacing: space,
                      children: [
                        for (final category in categories)
                          SizedBox(
                            width: width,
                            child: _CategoryCard(
                              category: category,
                              active: state.activeCategory?.id == category.id,
                              progress: state.activeCategory?.id == category.id
                                  ? state.progress
                                  : null,
                              answered: state.answeredCount,
                              completed: state.completedResults
                                  .where(
                                    (result) =>
                                        result.categoryId == category.id,
                                  )
                                  .length,
                              onStart: _opening ? null : () => _open(category),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              SizedBox(height: space * 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.active,
    required this.progress,
    required this.answered,
    required this.completed,
    required this.onStart,
  });

  final QuizCategory category;
  final bool active;
  final double? progress;
  final int answered;
  final int completed;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final difficultyColor = switch (category.difficulty) {
      'Mudah' => AppColors.green,
      'Sulit' => AppColors.red,
      _ =>
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.yellow
            : const Color(0xFF806000),
    };
    return BoltCard(
      padding: EdgeInsets.all(context.space),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(category.icon, size: 30),
          ),
          const SizedBox(height: 16),
          StatusPill(
            label: category.difficulty.toUpperCase(),
            color: difficultyColor,
          ),
          const SizedBox(height: 12),
          Text(category.title, style: context.text.titleLarge),
          const SizedBox(height: 8),
          Text(
            category.subtitle,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Text('${category.questions.length} soal'),
              Text('± ${category.estimatedMinutes} menit'),
            ],
          ),
          const SizedBox(height: 16),
          if (active) ...[
            Text('$answered/${category.questions.length} soal dijawab'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: AppColors.yellow,
              backgroundColor: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              minHeight: 6,
              semanticsLabel: 'Progres ${category.title}',
            ),
          ] else
            Text(
              completed == 0
                  ? 'Belum dikerjakan'
                  : '$completed kali diselesaikan',
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: BoltButton(
              label: active ? 'Lanjutkan' : 'Mulai kuis',
              icon: Icons.arrow_forward_rounded,
              secondary: !active,
              onPressed: category.questions.isEmpty ? null : onStart,
            ),
          ),
        ],
      ),
    );
  }
}
