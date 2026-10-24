import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_route.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/app_text_field.dart';
import '../widgets/kage_brand.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
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
        imageAsset: AppAssets.auth,
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
                          const Center(
                            child: KageBrand(
                              logoScale: 0.62,
                              wordmarkScale: 0.88,
                            ),
                          ),
                          SizedBox(height: responsive.gap),
                          Text(
                            'Selamat datang kembali.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.headingSize * 0.72,
                              height: 1.1,
                              letterSpacing: responsive.letterSpacing,
                              fontWeight: AppTypography.heading,
                              color: AppColors.ivory,
                            ),
                          ),
                          SizedBox(height: responsive.smallGap),
                          Text(
                            'Masuk untuk melanjutkan perjalanan pengetahuanmu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.bodySize,
                              height: 1.5,
                              fontWeight: AppTypography.body,
                              color: AppColors.muted,
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
                                color: AppColors.muted,
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
                                color: AppColors.error,
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
                          SizedBox(height: responsive.gap * 0.55),
                          SecondaryButton(
                            label: 'Daftar',
                            icon: Icons.person_add_alt_1_rounded,
                            onPressed: _openRegister,
                          ),
                          SizedBox(height: responsive.gap * 0.8),
                          Text(
                            'Akun hanya tersimpan selama aplikasi berjalan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.bodySize * 0.72,
                              height: 1.4,
                              fontWeight: AppTypography.body,
                              color: AppColors.muted,
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
