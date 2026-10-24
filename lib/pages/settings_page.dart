import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/secondary_button.dart';

/// Halaman pengaturan ringkas: akun, versi, dan keluar.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      body: AppBackground(
        imageAsset: AppAssets.home,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.pagePadding),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: responsive.contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    tooltip: 'Kembali',
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: responsive.iconSize,
                      color: AppColors.ivory,
                    ),
                  ),
                  Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: responsive.headingSize * 0.7,
                      fontWeight: AppTypography.heading,
                      color: AppColors.ivory,
                    ),
                  ),
                  SizedBox(height: responsive.smallGap),
                  Text(
                    'Tema gelap adalah tampilan utama KAGE. '
                    'Akun dan skor hanya tersimpan selama aplikasi berjalan.',
                    style: TextStyle(
                      fontSize: responsive.bodySize * 0.88,
                      height: 1.45,
                      color: AppColors.muted,
                    ),
                  ),
                  SizedBox(height: responsive.gap * 1.3),
                  _InfoCard(
                    title: 'Akun',
                    lines: [user?.name ?? 'Tidak ada sesi', user?.email ?? '-'],
                  ),
                  SizedBox(height: responsive.gap),
                  const _InfoCard(
                    title: 'Tentang KAGE',
                    lines: [
                      'KAGE — The Quiz Sanctuary',
                      'Versi 1.0.0',
                      'A journey beyond knowledge.',
                    ],
                  ),
                  SizedBox(height: responsive.gap * 1.5),
                  SecondaryButton(
                    label: 'Keluar dari Akun',
                    icon: Icons.logout_rounded,
                    onPressed: onLogout,
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.pagePadding * 0.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.004,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.bodySize * 0.95,
              fontWeight: AppTypography.title,
              color: AppColors.ivory,
            ),
          ),
          SizedBox(height: responsive.smallGap * 0.5),
          for (final line in lines)
            Padding(
              padding: EdgeInsets.only(bottom: responsive.smallGap * 0.25),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.82,
                  color: AppColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
