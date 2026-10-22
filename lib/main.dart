import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/welcome_page.dart';
import 'providers/quiz_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

/// Root aplikasi. QuizProvider dipasang di atas MaterialApp supaya
/// state kuis tidak hilang saat rotasi atau pindah halaman.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: MaterialApp(
        title: 'Kuis Pemrograman Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WelcomePage(),
      ),
    );
  }
}
