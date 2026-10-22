import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'main_shell.dart';
import 'register_page.dart';

/// Halaman login dengan akun dummy yang tersimpan di AuthProvider.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _loginError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email wajib diisi.';
    }
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(email)) {
      return 'Format email tidak valid.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi.';
    }
    return null;
  }

  void _submit() {
    setState(() => _loginError = null);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    final error = context.read<AuthProvider>().login(
      _emailController.text,
      _passwordController.text,
    );

    if (error != null) {
      setState(() => _loginError = error);
      return;
    }

    // Masuk ke shell dan hapus Login/Splash dari tumpukan navigasi agar
    // tombol back tidak kembali ke halaman login.
    Navigator.of(context)
        .pushAndRemoveUntil(AppRoute.fade(const MainShell()), (route) => false);
  }

  void _openRegister() {
    Navigator.push(context, AppRoute.fade(const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(responsive.pagePadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.contentWidth,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: responsive.heroIconSize * 0.82,
                              height: responsive.heroIconSize * 0.82,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: responsive.gap),
                          Text(
                            'SELAMAT DATANG',
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
                            'Masuk ke akunmu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.headingSize * 0.82,
                              height: 1.1,
                              letterSpacing: responsive.letterSpacing,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: responsive.smallGap),
                          Text(
                            'Lanjutkan latihan Flutter dan Dart dari akunmu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.bodySize,
                              height: 1.5,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: responsive.gap * 1.5),
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'nama@mail.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.mail_outline_rounded,
                            validator: _validateEmail,
                          ),
                          SizedBox(height: responsive.gap * 0.8),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Masukkan password',
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Tampilkan password'
                                  : 'Sembunyikan password',
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: responsive.bodySize * 1.2,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            validator: _validatePassword,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          if (_loginError != null) ...[
                            SizedBox(height: responsive.smallGap),
                            Text(
                              _loginError!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: responsive.bodySize * 0.82,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                          SizedBox(height: responsive.gap * 1.4),
                          PrimaryButton(
                            key: const Key('login-submit'),
                            label: 'Masuk',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _submit,
                          ),
                          SizedBox(height: responsive.gap * 0.4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Belum punya akun?',
                                  style: TextStyle(
                                    fontSize: responsive.bodySize * 0.85,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _openRegister,
                                child: Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: responsive.bodySize * 0.85,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsive.smallGap),
                          Text(
                            'Akun demo: demo@mail.com / 123456',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.bodySize * 0.68,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
