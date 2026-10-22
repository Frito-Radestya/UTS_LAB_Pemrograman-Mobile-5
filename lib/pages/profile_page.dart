import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Tab Profil: data akun, informasi aplikasi, dan tombol logout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final user = context.watch<AuthProvider>().currentUser;

    final name = user?.name ?? 'Pengguna';
    final email = user?.email ?? '-';
    final nim = user?.nim ?? '-';
    final prodi = user?.prodi ?? '-';
    final initial = user?.initial ?? '?';

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: responsive.contentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil',
                style: TextStyle(
                  fontSize: responsive.headingSize * 0.72,
                  height: 1.12,
                  letterSpacing: responsive.letterSpacing,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: responsive.smallGap * 0.6),
              Text(
                'Informasi akun dan aplikasi yang sedang kamu gunakan.',
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.92,
                  height: 1.45,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: responsive.gap * 1.3),
              _ProfileCard(name: name, email: email, initial: initial),
              SizedBox(height: responsive.gap * 1.3),
              const _SectionLabel(title: 'Data Mahasiswa'),
              SizedBox(height: responsive.smallGap * 0.7),
              _DataCard(
                children: [
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'NIM',
                    value: nim,
                  ),
                  _InfoRow(
                    icon: Icons.school_outlined,
                    label: 'Program Studi',
                    value: prodi,
                  ),
                ],
              ),
              SizedBox(height: responsive.gap * 1.3),
              const _SectionLabel(title: 'Tentang Aplikasi'),
              SizedBox(height: responsive.smallGap * 0.7),
              const _AppInfoCard(),
              SizedBox(height: responsive.gap * 1.5),
              _LogoutButton(onPressed: onLogout),
              SizedBox(height: responsive.smallGap * 0.8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Kamu akan kembali ke halaman login setelah keluar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.76,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: responsive.gap),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.email,
    required this.initial,
  });

  final String name;
  final String email;
  final String initial;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final avatarSize = responsive.bodySize * 4;

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.55),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.45),
                width: responsive.shortestSide * 0.004,
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: responsive.bodySize * 1.6,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.pagePadding * 0.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.bodySize * 1.25,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.3),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.8,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: responsive.bodySize * 1.05,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: responsive.gap * 1.2,
                thickness: responsive.shortestSide * 0.002,
                color: AppColors.border,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: responsive.iconSize, color: AppColors.accent),
        SizedBox(width: responsive.pagePadding * 0.4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.68,
                  fontWeight: FontWeight.w400,
                  letterSpacing: responsive.bodySize * 0.1,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: responsive.smallGap * 0.25),
              Text(
                value,
                style: TextStyle(
                  fontSize: responsive.bodySize * 0.95,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: responsive.iconSize,
            color: AppColors.accent,
          ),
          SizedBox(width: responsive.pagePadding * 0.4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kuis Pemrograman Mobile',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.95,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.25),
                Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.76,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.5),
                Text(
                  'Aplikasi kuis pilihan ganda Flutter & Dart. Data akun dan '
                  'skor disimpan di memori selama aplikasi berjalan.',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.76,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SizedBox(
      width: double.infinity,
      height: responsive.buttonHeight,
      child: OutlinedButton.icon(
        key: const Key('logout-button'),
        onPressed: onPressed,
        icon: Icon(Icons.logout_rounded, size: responsive.bodySize * 1.15),
        label: const Text('Keluar dari Akun'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.65),
            width: responsive.shortestSide * 0.004,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radius),
          ),
          textStyle: TextStyle(
            fontFamily: 'Onest',
            fontSize: responsive.bodySize * 1.02,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
