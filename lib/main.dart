import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/splash_page.dart';
import 'providers/auth_provider.dart';
import 'providers/quiz_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

/// Root aplikasi. AuthProvider dan QuizProvider dipasang di atas MaterialApp
/// supaya sesi login dan state kuis tidak hilang saat rotasi atau pindah
/// halaman.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: 'KAGE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const _EntryGate(),
      ),
    );
  }
}

/// Menunggu ukuran layar tersedia sebelum membangun halaman.
/// Pada frame pertama MediaQuery bisa berukuran 0, dan ukuran font 0
/// tidak valid untuk TextField.
class _EntryGate extends StatelessWidget {
  const _EntryGate();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width <= 0 || size.height <= 0) {
      return const ColoredBox(
        color: AppColors.background,
        child: SizedBox.expand(),
      );
    }
    return const SplashPage();
  }
}
