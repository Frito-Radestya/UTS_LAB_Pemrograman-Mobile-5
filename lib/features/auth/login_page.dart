import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:kage/features/auth/auth_controller.dart';
import 'package:kage/theme/app_colors.dart';
import 'package:kage/theme/app_theme.dart';
import 'package:kage/widgets/kage_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool hide = true;
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _enter() {
    FocusScope.of(context).unfocus();
    final identifier = email.text.trim();
    final pass = password.text;

    setState(() {
      emailError = identifier.isEmpty
          ? 'Email atau username wajib diisi.'
          : null;
      passwordError = pass.isEmpty ? 'Password wajib diisi.' : null;
    });
    if (emailError != null || passwordError != null) return;

    final isEmail = identifier.contains('@');
    context.read<AuthController>().login(
      name: isEmail ? null : identifier,
      mail: isEmail ? identifier : null,
    );
    context.go('/beranda');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 330,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF070B1E),
                    Color(0xFF141A45),
                    Color(0xFF2B1D4A),
                    AppColors.background,
                  ],
                  stops: [0, 0.4, 0.7, 1],
                ),
              ),
            ),
          ),
          // Moon
          Positioned(
            top: 40,
            right: w * 0.09,
            child: const MoonGlow(size: 34, glow: 30),
          ),
          // Torii – responsive horizontal centre
          Positioned(
            left: w * 0.28,
            top: 110,
            child: ToriiArt(width: w * 0.42, height: w * 0.35, opacity: 0.24),
          ),
          // Animated sakura petals
          AnimatedSakuraPetal(
            left: w * 0.085,
            top: 40,
            width: 11,
            height: 8,
            angle: 30,
            opacity: 0.85,
            duration: const Duration(seconds: 5),
            delayFraction: 0.0,
          ),
          AnimatedSakuraPetal(
            left: w * 0.20,
            top: 20,
            width: 9,
            height: 6,
            angle: -20,
            opacity: 0.8,
            color: const Color(0xFFF09AB0),
            duration: const Duration(seconds: 6),
            delayFraction: 0.35,
          ),
          AnimatedSakuraPetal(
            left: w * 0.78,
            top: 30,
            width: 12,
            height: 8,
            angle: 60,
            opacity: 0.85,
            duration: const Duration(seconds: 4),
            delayFraction: 0.6,
          ),
          AnimatedSakuraPetal(
            left: w * 0.86,
            top: 50,
            width: 9,
            height: 6,
            angle: 10,
            opacity: 0.8,
            color: const Color(0xFFF09AB0),
            duration: const Duration(seconds: 7),
            delayFraction: 0.2,
          ),
          AnimatedSakuraPetal(
            left: w * 0.055,
            top: 60,
            width: 10,
            height: 7,
            angle: -50,
            opacity: 0.7,
            duration: const Duration(seconds: 5),
            delayFraction: 0.75,
          ),
          // Scrollable form on top
          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A0E12),
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.55),
                            blurRadius: 26,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const EmblemMark(size: 40),
                    ),
                    const SizedBox(height: 10),
                    const KageWordmark(),
                    Text(
                      'THE QUIZ SANCTUARY',
                      style: AppTheme.onest(
                        size: 11,
                        heightPx: 16,
                        color: AppColors.gold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selamat Datang',
                        style: AppTheme.onest(
                          size: 28,
                          heightPx: 36,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Masuk untuk melanjutkan perjalanan pengetahuanmu.',
                        style: AppTheme.onest(
                          size: 14,
                          heightPx: 20,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppTextField(
                      controller: email,
                      hint: 'Email atau Username',
                      icon: Icons.person_outline,
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email,
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: password,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      obscure: hide,
                      errorText: passwordError,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _enter(),
                      onToggleObscure: () => setState(() => hide = !hide),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur atur ulang password belum tersedia.',
                              ),
                              backgroundColor: AppColors.surface,
                            ),
                          );
                        },
                        child: Text(
                          'Lupa password?',
                          style: AppTheme.onest(
                            size: 13,
                            heightPx: 18,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                    PrimaryButton(label: 'Masuk', onTap: _enter),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.borderStrong),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'atau masuk dengan',
                            style: AppTheme.onest(
                              size: 13,
                              heightPx: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.borderStrong),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _social('G', 'Google')),
                        const SizedBox(width: 12),
                        Expanded(child: _social('A', 'Apple')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        text: 'Belum punya akun? ',
                        style: AppTheme.onest(
                          size: 14,
                          heightPx: 20,
                          color: AppColors.textMuted,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () => context.push('/register'),
                              child: Text(
                                'Daftar',
                                style: AppTheme.onest(
                                  size: 14,
                                  heightPx: 20,
                                  weight: FontWeight.w600,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _social(String mark, String label) {
    return GestureDetector(
      onTap: _enter,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3F4D)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.text,
                shape: BoxShape.circle,
              ),
              child: Text(
                mark,
                style: AppTheme.onest(
                  size: 12,
                  heightPx: 16,
                  weight: FontWeight.w700,
                  color: AppColors.background,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTheme.onest(
                size: 14,
                heightPx: 20,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
