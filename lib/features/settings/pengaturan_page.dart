import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:kage/features/auth/auth_controller.dart';
import 'package:kage/theme/app_colors.dart';
import 'package:kage/theme/app_theme.dart';
import 'package:kage/widgets/kage_widgets.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const TopWash(
            height: 220,
            colors: [Color(0xFF1D1535), AppColors.background],
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-12, 0),
                          child: const BackIconButton(
                            label: 'Kembali ke profil',
                          ),
                        ),
                        Text('Pengaturan', style: AppTextStyles.titleLarge),
                      ],
                    ),
                  ),
                ),
                // Scrollable settings body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    center: Alignment(-0.4, -0.5),
                                    colors: [
                                      Color(0xFF3B2A4E),
                                      AppColors.surface,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.gold,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  auth.initial,
                                  style: AppTextStyles.headlineTightGold,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      auth.fullName,
                                      style: AppTextStyles.titleMedium,
                                    ),
                                    Text(
                                      auth.email,
                                      style: AppTextStyles.bodySmallMuted,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _sectionLabel('AKUN'),
                        _group([
                          _tile(
                            Icons.person_outline,
                            'Edit Profil',
                            () => _editProfile(context, auth),
                          ),
                          _tile(
                            Icons.lock_outline,
                            'Ubah Password',
                            () => _comingSoon(context, 'Ubah Password'),
                          ),
                          _tile(
                            Icons.notifications_none,
                            'Notifikasi',
                            () => _comingSoon(context, 'Notifikasi'),
                          ),
                        ]),
                        _sectionLabel('APLIKASI'),
                        _group([
                          _themeRow(),
                          _tile(
                            Icons.help_outline,
                            'Bantuan',
                            () => _comingSoon(context, 'Bantuan'),
                          ),
                          _tile(Icons.info_outline, 'Tentang Aplikasi', () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'KAGE',
                              applicationVersion: 'v1.0.0',
                              applicationLegalese: 'The Quiz Sanctuary',
                            );
                          }),
                        ]),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'Logout',
                          onTap: () => _confirmLogout(context, auth),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            'KAGE · The Quiz Sanctuary · v1.0.0',
                            style: AppTextStyles.captionMutedSpaced,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 0, 8),
      child: Text(text, style: AppTextStyles.captionMutedWide),
    );
  }

  Widget _group(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.gold),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: AppTextStyles.bodyLarge)),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan hadir di pembaruan berikutnya.'),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, AuthController auth) async {
    final nameController = TextEditingController(text: auth.fullName);
    final emailController = TextEditingController(text: auth.email);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderStrong),
        ),
        title: Text('Edit Profil', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameController,
                hint: 'Nama Lengkap',
                icon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: emailController,
                hint: 'Email',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Batal', style: AppTextStyles.labelMuted),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Simpan', style: AppTextStyles.labelPrimary),
          ),
        ],
      ),
    );

    if (saved == true && context.mounted) {
      final name = nameController.text.trim();
      final mail = emailController.text.trim();
      final emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(mail);
      if (name.isEmpty || !emailValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama dan email yang valid wajib diisi.'),
            backgroundColor: AppColors.surface,
          ),
        );
      } else {
        auth.updateProfile(name: name, mail: mail);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui.'),
            backgroundColor: AppColors.surface,
          ),
        );
      }
    }

    nameController.dispose();
    emailController.dispose();
  }

  Future<void> _confirmLogout(BuildContext context, AuthController auth) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderStrong),
        ),
        title: Text('Keluar dari akun?', style: AppTextStyles.titleLarge),
        content: Text(
          'Kamu dapat masuk kembali kapan saja untuk melanjutkan latihan.',
          style: AppTextStyles.bodyRelaxedSoft,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Batal', style: AppTextStyles.labelMuted),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Logout', style: AppTextStyles.labelPrimary),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      auth.logout();
      context.go('/login');
    }
  }

  Widget _themeRow() {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.dark_mode_outlined,
              size: 20,
              color: AppColors.gold,
            ),
            const SizedBox(width: 14),
            Expanded(child: Text('Tema Gelap', style: AppTextStyles.bodyLarge)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Aktif', style: AppTextStyles.captionSuccess),
            ),
          ],
        ),
      ),
    );
  }
}
