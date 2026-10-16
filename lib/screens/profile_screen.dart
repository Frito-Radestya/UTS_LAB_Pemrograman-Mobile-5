import 'package:flutter/material.dart';

import '../models/quiz_models.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/bolt_widgets.dart';
import 'result_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _signingOut = false;

  Future<void> _saveSetting(Future<void> Function() update) async {
    try {
      await update();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan belum tersimpan di perangkat. Coba lagi.'),
        ),
      );
    }
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    final state = AppScope.of(context);
    setState(() => _signingOut = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari BoltQuiz?'),
        content: const Text(
          'Sesi, progres kuis aktif, dan riwayat hasil akun di perangkat ini '
          'akan dihapus. Kamu bisa masuk kembali untuk mulai belajar lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) {
      setState(() => _signingOut = false);
      return;
    }
    try {
      await state.signOut();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _signingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sesi belum dapat dihapus dari penyimpanan. Coba lagi.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final space = context.space;
    final bestAccuracy = state.completedResults.fold<double>(
      0,
      (best, result) => result.accuracy > best ? result.accuracy : best,
    );
    return SingleChildScrollView(
      key: const PageStorageKey('profile-scroll'),
      padding: EdgeInsets.all(space),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'Profil Saya'),
              SizedBox(height: space * 1.5),
              BoltCard(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final avatar = Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.yellow, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: AppColors.yellow,
                            child: Icon(
                              Icons.person_rounded,
                              size: 52,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                    final identity = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StatusPill(
                          label: 'PROFIL PELAJAR',
                          icon: Icons.bolt_rounded,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.playerName.isEmpty
                              ? 'Penjelajah'
                              : state.playerName,
                          style: context.text.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.email,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                    if (constraints.maxWidth < 440) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avatar,
                          SizedBox(height: space),
                          identity,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        avatar,
                        SizedBox(width: space * 1.5),
                        Expanded(child: identity),
                      ],
                    );
                  },
                ),
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
              const SectionHeading(title: 'Preferensi'),
              SizedBox(height: space),
              BoltCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _PreferenceTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Mode gelap',
                      subtitle: 'Tampilan yang nyaman untuk sesi belajarmu.',
                      value: state.isDarkMode,
                      onChanged: (value) =>
                          _saveSetting(() => state.setDarkMode(value)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _PreferenceTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Efek suara',
                      subtitle: 'Klik sistem saat memilih jawaban; mengikuti dukungan dan volume perangkat.',
                      value: state.soundEnabled,
                      onChanged: (value) =>
                          _saveSetting(() => state.setSoundEnabled(value)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _PreferenceTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Pengingat belajar',
                      subtitle:
                          'Hanya pengingat di dalam aplikasi. Tidak ada '
                          'notifikasi sistem atau jadwal otomatis.',
                      value: state.remindersEnabled,
                      onChanged: (value) =>
                          _saveSetting(() => state.setRemindersEnabled(value)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: space * 2),
              const SectionHeading(title: 'Riwayat Kuis Terbaru'),
              SizedBox(height: space),
              if (state.completedResults.isEmpty)
                BoltCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.history_rounded, size: 36),
                      SizedBox(height: space),
                      Text(
                        'Perjalananmu baru dimulai',
                        style: context.text.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selesaikan kuis pertamamu. Hasil dan pencapaianmu akan tampil di sini.',
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              else
                for (final result in state.completedResults.take(5)) ...[
                  _HistoryCard(result: result),
                  SizedBox(height: space),
                ],
              SizedBox(height: space * 1.5),
              SizedBox(
                width: double.infinity,
                child: BoltButton(
                  label: _signingOut ? 'Memproses...' : 'Keluar dari akun',
                  icon: Icons.logout_rounded,
                  secondary: true,
                  onPressed: _signingOut ? null : _signOut,
                ),
              ),
              SizedBox(height: space),
              Center(
                child: Text(
                  'BOLTQUIZ · BELAJAR TANPA BATAS',
                  textAlign: TextAlign.center,
                  style: context.text.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: space * 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SwitchListTile.adaptive(
        contentPadding: EdgeInsets.all(context.space),
        secondary: constraints.maxWidth < 360 ? null : Icon(icon),
        title: Text(title, style: context.text.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.result});

  final QuizResult result;

  @override
  Widget build(BuildContext context) {
    final date = result.completedAt.toLocal();
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
    final minutes = result.elapsedSeconds ~/ 60;
    final seconds = (result.elapsedSeconds % 60).toString().padLeft(2, '0');
    return BoltCard(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.categoryTitle, style: context.text.titleMedium),
          const SizedBox(height: 8),
          Text(
            '$dateLabel · $minutes:$seconds · ${result.correct}/${result.total} benar',
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusPill(
                label: '+${result.points} XP',
                icon: Icons.bolt_rounded,
              ),
              Text('${(result.accuracy * 100).round()}% akurasi'),
              Text('Lihat hasil →', style: context.text.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}
