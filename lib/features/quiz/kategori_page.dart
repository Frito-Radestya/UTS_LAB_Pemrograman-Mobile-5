import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:kage/data/repositories/quiz_repository.dart';
import 'package:kage/theme/app_colors.dart';
import 'package:kage/theme/app_theme.dart';
import 'package:kage/widgets/kage_widgets.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final bank = context.read<QuizRepository>();
    final items = bank.categories
        .where((c) => tab == 0 || c.available)
        .toList();

    return ScreenScaffold(
      navIndex: 1,
      stack: const [TopWash(height: 200)],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Transform.translate(
                    offset: const Offset(-12, 0),
                    child: BackIconButton(
                      label: 'Kembali ke beranda',
                      onTap: () => context.go('/beranda'),
                    ),
                  ),
                  Text(
                    'Pilih Kategori',
                    style: AppTheme.onest(
                      size: 22,
                      heightPx: 32,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Tantang pengetahuanmu di berbagai bidang.',
              style: AppTheme.onest(
                size: 14,
                heightPx: 20,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _seg(0, 'Semua'),
                  const SizedBox(width: 4),
                  _seg(1, 'Tersedia'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(
                                Icons.menu_book_outlined,
                                color: AppColors.textMuted,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Belum ada kategori tersedia',
                              textAlign: TextAlign.center,
                              style: AppTheme.onest(
                                size: 15,
                                heightPx: 22,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coba lihat semua kategori yang sedang disiapkan.',
                              textAlign: TextAlign.center,
                              style: AppTheme.onest(
                                size: 13,
                                heightPx: 19,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlineButton(
                              label: 'Tampilkan semua',
                              width: 180,
                              height: 44,
                              onTap: () => setState(() => tab = 0),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final c = items[i];
                        return GestureDetector(
                          onTap: () => context.push('/kategori/${c.id.name}'),
                          child: Container(
                            height: 92,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                CategoryIconBadge(
                                  category: c,
                                  size: 56,
                                  iconSize: 28,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name,
                                        style: AppTheme.onest(
                                          size: 16,
                                          heightPx: 24,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${bank.questionCountFor(c.id)} soal',
                                        style: AppTheme.onest(
                                          size: 13,
                                          heightPx: 18,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(
                                            alpha: 0.14,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Tersedia',
                                          style: AppTheme.onest(
                                            size: 12,
                                            heightPx: 18,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.textMuted,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seg(int i, String label) {
    final on = tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = i),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: AppTheme.onest(
              size: 14,
              heightPx: 20,
              weight: on ? FontWeight.w600 : FontWeight.w500,
              color: on ? AppColors.text : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
