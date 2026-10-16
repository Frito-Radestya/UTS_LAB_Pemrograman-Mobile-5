import 'package:flutter/material.dart';

import '../data/quiz_data.dart';
import '../models/quiz_models.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/bolt_widgets.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onViewCategories,
    this.onViewProfile,
  });

  final VoidCallback onViewCategories;
  final VoidCallback? onViewProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _opening = false;

  Future<void> _open(QuizCategory category) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      await openCategoryQuiz(context, category);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  void _showInformation() {
    final reminders = AppScope.of(context).remindersEnabled;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ruang pengingatmu'),
        content: Text(
          reminders
              ? 'Pengingat dalam aplikasi aktif. Luangkan waktu untuk belajar '
                    'saat membuka BoltQuiz. Tidak ada notifikasi terjadwal '
                    'atau pengingat sistem yang dikirim.'
              : 'Pengingat dalam aplikasi sedang nonaktif. Kamu dapat '
                    'mengaktifkannya di Profil. BoltQuiz tidak menjadwalkan '
                    'notifikasi sistem.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final space = context.space;
    final available = quizCategories
        .where((c) => c.questions.isNotEmpty)
        .toList();
    final featured =
        state.activeCategory ?? (available.isEmpty ? null : available.first);
    final now = DateTime.now();
    final day = DateTime.utc(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime.utc(2024)).inDays;
    final daily = available.isEmpty ? null : available[day % available.length];
    final bestAccuracy = state.completedResults.fold<double>(
      0,
      (best, result) => result.accuracy > best ? result.accuracy : best,
    );

    return SingleChildScrollView(
      key: const PageStorageKey('home-scroll'),
      padding: EdgeInsets.all(space),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    Expanded(
                      child: BoltLogo(compact: constraints.maxWidth < 360),
                    ),
                    IconButton(
                      tooltip: 'Informasi pengingat',
                      onPressed: _showInformation,
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Buka profil',
                      onPressed: widget.onViewProfile,
                      padding: EdgeInsets.zero,
                      icon: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.png',
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const CircleAvatar(
                            backgroundColor: AppColors.yellow,
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: space * 2),
              Text(
                'Halo, ${state.playerName.isEmpty ? 'Penjelajah' : state.playerName}! 👋',
                style: context.text.titleMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Siap mengasah pikiran?',
                style: context.text.headlineMedium,
              ),
              SizedBox(height: space * 1.5),
              if (featured != null)
                _HeroCard(
                  category: featured,
                  continuing: state.activeCategory != null,
                  answered: state.answeredCount,
                  progress: state.progress,
                  onStart: _opening ? null : () => _open(featured),
                ),
              SizedBox(height: space * 1.5),
              LayoutBuilder(
                builder: (context, constraints) {
                  final largeText =
                      MediaQuery.textScalerOf(context).scale(14) > 21;
                  final columns = constraints.maxWidth < 270 || largeText
                      ? 1
                      : 3;
                  final width =
                      (constraints.maxWidth - space * (columns - 1)) / columns;
                  return Wrap(
                    spacing: space,
                    runSpacing: space,
                    children: [
                      SizedBox(
                        width: width,
                        child: StatTile(
                          icon: Icons.bolt_rounded,
                          value: '${state.scoreTotal}',
                          label: 'Total XP',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: StatTile(
                          icon: Icons.task_alt_rounded,
                          value: '${state.completedCount}',
                          label: 'Kuis selesai',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: StatTile(
                          icon: Icons.workspace_premium_outlined,
                          value: state.completedCount == 0
                              ? '—'
                              : '${(bestAccuracy * 100).round()}%',
                          label: 'Akurasi terbaik',
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: space * 2),
              SectionHeading(
                title: 'Kategori Populer',
                action: 'Lihat semua',
                onAction: widget.onViewCategories,
              ),
              SizedBox(height: space),
              LayoutBuilder(
                builder: (context, constraints) {
                  final largeText =
                      MediaQuery.textScalerOf(context).scale(14) > 21;
                  final columns = constraints.maxWidth < 280 || largeText
                      ? 1
                      : 2;
                  final width =
                      (constraints.maxWidth - space * (columns - 1)) / columns;
                  return Wrap(
                    spacing: space,
                    runSpacing: space,
                    children: [
                      for (final category in quizCategories.take(6))
                        SizedBox(
                          width: width,
                          child: BoltCard(
                            padding: EdgeInsets.all(space),
                            onTap: _opening || category.questions.isEmpty
                                ? null
                                : () => _open(category),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        context.colors.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(category.icon, size: 28),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  category.title,
                                  style: context.text.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${category.questions.length} soal · ${category.estimatedMinutes} menit',
                                  style: context.text.bodySmall?.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.activeCategory?.id == category.id
                                      ? 'Lanjutkan →'
                                      : '${category.difficulty} · Mulai →',
                                  style: context.text.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              if (daily != null) ...[
                SizedBox(height: space * 2),
                BoltCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StatusPill(
                        label: 'TANTANGAN HARI INI',
                        icon: Icons.today_rounded,
                      ),
                      SizedBox(height: space),
                      Text(
                        'Sedikit belajar, setiap hari.',
                        style: context.text.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilihan hari ini: ${daily.title}. '
                        '${daily.questions.length} soal untuk melatih pemahamanmu.',
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: space),
                      BoltButton(
                        label: state.activeCategory?.id == daily.id
                            ? 'Lanjutkan tantangan'
                            : 'Coba tantangan',
                        icon: Icons.bolt_rounded,
                        onPressed: _opening ? null : () => _open(daily),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: space * 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.category,
    required this.continuing,
    required this.answered,
    required this.progress,
    required this.onStart,
  });

  final QuizCategory category;
  final bool continuing;
  final int answered;
  final double progress;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF202014);
    return BoltCard(
      color: AppColors.yellow,
      padding: EdgeInsets.all(context.space * 1.5),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: ink),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  continuing ? Icons.play_circle_outline : Icons.auto_awesome,
                  color: ink,
                ),
                Text(
                  continuing ? 'LANJUTKAN PERJALANANMU' : 'PILIHAN UNTUKMU',
                  style: context.text.labelSmall?.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              category.title,
              style: context.text.headlineMedium?.copyWith(
                color: ink,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              continuing
                  ? 'Progresmu tersimpan. Yuk, tuntaskan tantangan ini!'
                  : category.subtitle,
            ),
            const SizedBox(height: 20),
            Text(
              continuing
                  ? '$answered dari ${category.questions.length} soal dijawab'
                  : '${category.questions.length} soal  ·  ± ${category.estimatedMinutes} menit  ·  ${category.difficulty}',
            ),
            if (continuing) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                color: ink,
                backgroundColor: Colors.black12,
                minHeight: 6,
                borderRadius: BorderRadius.circular(8),
                semanticsLabel: 'Progres kuis aktif',
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: ink,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.black12,
                disabledForegroundColor: ink,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onStart,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(continuing ? 'Lanjutkan kuis' : 'Mulai sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
