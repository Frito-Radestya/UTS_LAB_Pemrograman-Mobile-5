import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'utils/responsive.dart';

void main() {
  runApp(const MyApp());
}

/// Root aplikasi. Tema dan font Onest dipasang di sini.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuis Pemrograman Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _SetupPreview(),
    );
  }
}

/// Tampilan sementara setelah setup project.
/// Akan diganti WelcomePage pada Task 5.
class _SetupPreview extends StatelessWidget {
  const _SetupPreview();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: Center(
        child: Text(
          'Kuis Pemrograman Mobile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: responsive.headingSize,
            letterSpacing: responsive.letterSpacing,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
