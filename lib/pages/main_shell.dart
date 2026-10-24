import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../widgets/app_background.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'quiz_list_page.dart';
import 'quiz_page.dart';
import 'score_page.dart';

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

  /// Menghapus sesi lalu kembali ke Login tanpa menyisakan MainShell
  /// di tumpukan navigasi.
  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.of(context)
        .pushAndRemoveUntil(AppRoute.fade(const LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        imageAsset: AppAssets.home,
        // IndexedStack menjaga state tiap tab saat pengguna berpindah tab.
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(
              onOpenQuizTab: () => _selectTab(1),
              onCategoryTap: _startQuiz,
            ),
            QuizListPage(onCategoryTap: _startQuiz),
            const ScorePage(),
            ProfilePage(onLogout: _logout),
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
