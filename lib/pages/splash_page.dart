import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import 'login_page.dart';

/// Halaman pembuka singkat sebelum pengguna masuk ke halaman Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Beri waktu singkat agar logo dan nama aplikasi sempat terlihat.
    _timer = Timer(const Duration(seconds: 2), _openLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openLogin() {
    if (!mounted) {
      return;
    }
    // pushReplacement mencegah tombol back kembali ke splash.
    Navigator.pushReplacement(context, AppRoute.fade(const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(responsive.pagePadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: responsive.contentWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: responsive.heroIconSize,
                    height: responsive.heroIconSize,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: responsive.gap),
                  Text(
                    'KUIS PEMROGRAMAN MOBILE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.bodySize * 0.72,
                      fontWeight: FontWeight.w400,
                      letterSpacing: responsive.bodySize * 0.18,
                      color: AppColors.accent,
                    ),
                  ),
                  SizedBox(height: responsive.smallGap),
                  Text(
                    'Flutter & Dart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.headingSize,
                      height: 1.08,
                      letterSpacing: responsive.letterSpacing,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: responsive.gap),
                  Text(
                    'Latihan singkat untuk menguji pemahamanmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.bodySize,
                      height: 1.5,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: responsive.gap * 1.8),
                  SizedBox(
                    width: responsive.bodySize * 1.4,
                    height: responsive.bodySize * 1.4,
                    child: CircularProgressIndicator(
                      strokeWidth: responsive.shortestSide * 0.006,
                      color: AppColors.accent,
                    ),
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
