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
                  Text('Pilih Kategori', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Text(
              'Tantang pengetahuanmu di berbagai bidang.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 16),
            Container(
              // Tinggi 58 = target sentuh 48 dp + padding 4 dp di tiap sisi
              // + tebal garis 1 dp (U-02).
              height: 58,
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
                              style: AppTextStyles.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coba lihat semua kategori yang sedang disiapkan.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmallRelaxedMuted,
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
                        return KageTappable(
                          onTap: () => context.push('/kategori/${c.id.name}'),
                          borderRadius: BorderRadius.circular(16),
                          semanticLabel:
                              'Kategori ${c.name}, '
                              '${bank.questionCountFor(c.id)} soal, tersedia',
                          excludeChildSemantics: true,
                          child: Container(
                            // Tinggi minimum, bukan tetap, supaya kartu tumbuh
                            // pada skala font sistem yang besar (U-02).
                            constraints: const BoxConstraints(minHeight: 92),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
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
                                        style: AppTextStyles.titleMedium,
                                      ),
                                      Text(
                                        '${bank.questionCountFor(c.id)} soal',
                                        style: AppTextStyles.bodySmallMuted,
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
                                          style: AppTextStyles
                                              .captionRelaxedSuccess,
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
      child: KageTappable(
        onTap: () => setState(() => tab = i),
        borderRadius: BorderRadius.circular(9),
        selected: on,
        semanticLabel: 'Tab $label${on ? ', aktif' : ''}',
        excludeChildSemantics: true,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: on ? FontWeight.w600 : FontWeight.w500,
              color: on ? AppColors.text : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
