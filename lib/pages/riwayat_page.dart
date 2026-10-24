import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  CategoryId? filter;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = filter == null
        ? app.history
        : app.history.where((e) => e.categoryId == filter).toList();

    return ScreenScaffold(
      navIndex: 2,
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
                    'Riwayat Skor',
                    style: AppTheme.onest(
                      size: 22,
                      heightPx: 32,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip(null, 'Semua'),
                  _chip(CategoryId.sains, 'Sains'),
                  _chip(CategoryId.teknologi, 'Teknologi'),
                  _chip(CategoryId.sejarah, 'Sejarah'),
                  _chip(CategoryId.logika, 'Logika'),
                  _chip(CategoryId.umum, 'Umum'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _mini('${app.totalQuizzes}', 'Total Kuis'),
                  _div(),
                  _mini('${app.averageScore}', 'Rata-rata Skor'),
                  _div(),
                  _mini('${app.bestScore}', 'Skor Terbaik'),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                                Icons.history_rounded,
                                color: AppColors.textMuted,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Belum ada riwayat di kategori ini',
                              textAlign: TextAlign.center,
                              style: AppTheme.onest(
                                size: 15,
                                heightPx: 22,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Selesaikan satu kuis untuk melihat skormu di sini.',
                              textAlign: TextAlign.center,
                              style: AppTheme.onest(
                                size: 13,
                                heightPx: 19,
                                color: AppColors.textMuted,
                              ),
                            ),
                            if (filter != null) ...[
                              const SizedBox(height: 12),
                              OutlineButton(
                                label: 'Tampilkan semua',
                                width: 180,
                                height: 44,
                                onTap: () => setState(() => filter = null),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => ScoreRow(result: items[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(CategoryId? id, String label) {
    final on = filter == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => filter = id),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: on ? null : Border.all(color: AppColors.borderStrong),
          ),
          child: Text(
            label,
            style: AppTheme.onest(
              size: 14,
              heightPx: 20,
              weight: on ? FontWeight.w600 : FontWeight.w400,
              color: on ? AppColors.text : AppColors.textSoft,
            ),
          ),
        ),
      ),
    );
  }

  Widget _mini(String v, String l) {
    return Expanded(
      child: Column(
        children: [
          Text(
            v,
            style: AppTheme.onest(
              size: 20,
              heightPx: 26,
              weight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
          Text(
            l,
            style: AppTheme.onest(
              size: 12,
              heightPx: 16,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _div() =>
      Container(width: 1, height: 36, color: AppColors.borderStrong);
}
