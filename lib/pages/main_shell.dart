import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_page.dart';
import 'quiz_list_page.dart';
import 'quiz_page.dart';

/// Kerangka utama setelah login dengan 4 tab yang state-nya tetap hidup.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    if (index == _currentIndex) {
      return;
    }
    setState(() => _currentIndex = index);
  }

  /// Menyiapkan kategori dan membuka kuis sebagai layar penuh.
  ///
  /// Route baru berada di atas MainShell, jadi bottom navigation tidak
  /// terlihat selama kuis. Tombol back kembali ke tab asal.
  void _startQuiz(Category category) {
    final playerName = context.read<AuthProvider>().currentUser?.name ?? '';
    context.read<QuizProvider>().startCategory(
      category,
      playerName: playerName,
    );
    Navigator.of(context).push(AppRoute.fade(const QuizPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        // IndexedStack menjaga state tiap tab saat pengguna berpindah tab.
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(
              onOpenQuizTab: () => _selectTab(1),
              onCategoryTap: _startQuiz,
            ),
            QuizListPage(onCategoryTap: _startQuiz),
            const _PlaceholderTab(
              icon: Icons.bar_chart_rounded,
              title: 'Riwayat Skor',
              message: 'Skor terakhir dan riwayat akan tampil di sini.',
            ),
            const _PlaceholderTab(
              icon: Icons.person_outline_rounded,
              title: 'Profil',
              message: 'Informasi akun dan tombol keluar akan tampil di sini.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _selectTab,
      ),
    );
  }
}

/// Tampilan sementara untuk tab yang belum dibuat pada task berikutnya.
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.pagePadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: responsive.contentWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: responsive.heroIconSize * 0.5,
                color: AppColors.accent,
              ),
              SizedBox(height: responsive.gap),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.headingSize * 0.6,
                  letterSpacing: responsive.letterSpacing,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: responsive.smallGap),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.bodySize,
                  height: 1.5,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
