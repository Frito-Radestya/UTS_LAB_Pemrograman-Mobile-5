import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool hide = true;
  String? nameError;
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _register() {
    FocusScope.of(context).unfocus();
    final fullName = name.text.trim();
    final mail = email.text.trim();
    final pass = password.text;
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    setState(() {
      nameError = fullName.isEmpty ? 'Nama lengkap wajib diisi.' : null;
      emailError = mail.isEmpty
          ? 'Email wajib diisi.'
          : !emailPattern.hasMatch(mail)
          ? 'Format email belum valid.'
          : null;
      passwordError = pass.isEmpty
          ? 'Password wajib diisi.'
          : pass.length < 8
          ? 'Password minimal 8 karakter.'
          : null;
    });
    if (nameError != null || emailError != null || passwordError != null) {
      return;
    }

    context.read<AppState>().login(name: fullName, mail: mail);
    context.go('/beranda');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top gradient
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 260,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF120F2A),
                    Color(0xFF1D1A3F),
                    AppColors.background,
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
          ),
          // Bottom glow
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: h * 0.36,
            child: const Opacity(
              opacity: 0.7,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF2A1230), AppColors.background],
                  ),
                ),
              ),
            ),
          ),
          // Torii watermark at bottom
          Positioned(
            left: w * 0.25,
            bottom: h * 0.04,
            child: ToriiArt(width: w * 0.60, height: w * 0.50, opacity: 0.28),
          ),
          // Animated lantern
          Positioned(
            right: w * 0.055,
            bottom: h * 0.15,
            child: const AnimatedLantern(
              opacity: 0.7,
              duration: Duration(milliseconds: 2100),
              delayFraction: 0.2,
            ),
          ),
          // Animated sakura petals
          AnimatedSakuraPetal(
            left: w * 0.76,
            top: h * 0.04,
            width: 12,
            height: 8,
            angle: 50,
            opacity: 0.8,
            duration: const Duration(seconds: 5),
            delayFraction: 0.0,
          ),
          AnimatedSakuraPetal(
            left: w * 0.86,
            top: h * 0.06,
            width: 9,
            height: 6,
            angle: 10,
            opacity: 0.75,
            color: const Color(0xFFF09AB0),
            duration: const Duration(seconds: 6),
            delayFraction: 0.4,
          ),
          AnimatedSakuraPetal(
            left: w * 0.65,
            top: h * 0.08,
            width: 10,
            height: 7,
            angle: -30,
            opacity: 0.7,
            duration: const Duration(seconds: 4),
            delayFraction: 0.7,
          ),
          AnimatedSakuraPetal(
            left: w * 0.10,
            top: h * 0.05,
            width: 10,
            height: 7,
            angle: -30,
            opacity: 0.6,
            duration: const Duration(seconds: 7),
            delayFraction: 0.55,
          ),
          AnimatedSakuraPetal(
            left: w * 0.30,
            top: h * 0.03,
            width: 9,
            height: 6,
            angle: 25,
            opacity: 0.6,
            color: const Color(0xFFF09AB0),
            duration: const Duration(seconds: 5),
            delayFraction: 0.8,
          ),
          // Form
          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackIconButton(label: 'Kembali ke halaman masuk'),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 12, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KAGE',
                              style: AppTheme.cinzel(
                                size: 18,
                                heightPx: 24,
                                letterSpacing: 6,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Buat Akun',
                              style: AppTheme.onest(
                                size: 28,
                                heightPx: 36,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Mulai perjalanan pengetahuanmu bersama KAGE.',
                              style: AppTheme.onest(
                                size: 14,
                                heightPx: 20,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 28),
                            AppTextField(
                              controller: name,
                              hint: 'Nama Lengkap',
                              icon: Icons.person_outline,
                              errorText: nameError,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              controller: email,
                              hint: 'Email',
                              icon: Icons.mail_outline,
                              errorText: emailError,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              controller: password,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              obscure: hide,
                              errorText: passwordError,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              onSubmitted: (_) => _register(),
                              onToggleObscure: () =>
                                  setState(() => hide = !hide),
                            ),
                            const SizedBox(height: 8),
                            if (passwordError == null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  'Minimal 8 karakter, gunakan kombinasi huruf dan angka.',
                                  style: AppTheme.onest(
                                    size: 12,
                                    heightPx: 16,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),
                            PrimaryButton(label: 'Daftar', onTap: _register),
                            const SizedBox(height: 22),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Sudah punya akun? ',
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
                                        onTap: () => context.go('/login'),
                                        child: Text(
                                          'Masuk',
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
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
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
}
