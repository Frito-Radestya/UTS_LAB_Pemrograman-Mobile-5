import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/kage_brand.dart';
import 'login_page.dart';

/// Halaman pembuka singkat sebelum pengguna masuk ke halaman Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _fadeController;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.page,
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    // Sesi tidak disimpan permanen, jadi selalu menuju Login.
    _timer = Timer(const Duration(seconds: 2), _openLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _openLogin() {
    if (!mounted) {
      return;
    }
    Navigator.pushReplacement(context, AppRoute.fade(const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: AppBackground(
        imageAsset: AppAssets.splash,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(responsive.pagePadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: responsive.contentWidth),
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const KageBrand(logoScale: 1.05, wordmarkScale: 1.15),
                    SizedBox(height: responsive.gap * 1.4),
                    Text(
                      'A journey beyond knowledge.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.bodySize,
                        height: 1.5,
                        fontWeight: AppTypography.body,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: responsive.gap * 1.8),
                    SizedBox(
                      width: responsive.contentWidth * 0.38,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          responsive.bodySize,
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: responsive.bodySize * 0.18,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.antiqueGold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
