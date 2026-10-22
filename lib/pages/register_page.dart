import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

/// Halaman pendaftaran akun dummy.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _prodiController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _registerError;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _prodiController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final required = _required(value, 'Email');
    if (required != null) {
      return required;
    }

    final email = value!.trim();
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(email)) {
      return 'Format email tidak valid.';
    }
    if (context.read<AuthProvider>().isEmailRegistered(email)) {
      return 'Email sudah terdaftar.';
    }
    return null;
  }

  String? _validateNim(String? value) {
    final required = _required(value, 'NIM');
    if (required != null) {
      return required;
    }
    if (context.read<AuthProvider>().isNimRegistered(value!)) {
      return 'NIM sudah terdaftar.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final required = _required(value, 'Password');
    if (required != null) {
      return required;
    }
    if (value!.length < 6) {
      return 'Password minimal 6 karakter.';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    final required = _required(value, 'Konfirmasi password');
    if (required != null) {
      return required;
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak sama.';
    }
    return null;
  }

  void _submit() {
    setState(() => _registerError = null);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    final error = context.read<AuthProvider>().register(
      name: _nameController.text,
      nim: _nimController.text,
      email: _emailController.text,
      prodi: _prodiController.text,
      password: _passwordController.text,
    );

    if (error != null) {
      setState(() => _registerError = error);
      return;
    }

    // AuthProvider langsung membuat sesi setelah register.
    // Navigasi ke MainShell ditambahkan pada Task 6.
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pendaftaran berhasil.')));
  }

  void _backToLogin() {
    Navigator.maybePop(context);
  }

  Widget _passwordSuffix({
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    final responsive = Responsive(context);
    return IconButton(
      tooltip: obscure ? 'Tampilkan password' : 'Sembunyikan password',
      onPressed: onPressed,
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: responsive.bodySize * 1.2,
        color: AppColors.textSecondary,
      ),
    );
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
                              width: responsive.heroIconSize * 0.7,
                              height: responsive.heroIconSize * 0.7,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: responsive.gap),
                          Text(
                            'BUAT AKUN',
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
                            'Mulai perjalananmu',
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
                            'Isi data berikut untuk membuat akun sementara.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.bodySize,
                              height: 1.5,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: responsive.gap * 1.2),
                          AppTextField(
                            controller: _nameController,
                            label: 'Nama lengkap',
                            hint: 'Nama sesuai data mahasiswa',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (value) => _required(value, 'Nama'),
                          ),
                          SizedBox(height: responsive.gap * 0.7),
                          AppTextField(
                            controller: _nimController,
                            label: 'NIM',
                            hint: 'Nomor induk mahasiswa',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.badge_outlined,
                            validator: _validateNim,
                          ),
                          SizedBox(height: responsive.gap * 0.7),
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'nama@mail.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.mail_outline_rounded,
                            validator: _validateEmail,
                          ),
                          SizedBox(height: responsive.gap * 0.7),
                          AppTextField(
                            controller: _prodiController,
                            label: 'Program studi',
                            hint: 'Contoh: Teknik Informatika',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.school_outlined,
                            validator: (value) =>
                                _required(value, 'Program studi'),
                          ),
                          SizedBox(height: responsive.gap * 0.7),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Minimal 6 karakter',
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: _passwordSuffix(
                              obscure: _obscurePassword,
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                            ),
                            validator: _validatePassword,
                          ),
                          SizedBox(height: responsive.gap * 0.7),
                          AppTextField(
                            controller: _confirmController,
                            label: 'Konfirmasi password',
                            hint: 'Ulangi password',
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icons.lock_reset_rounded,
                            suffixIcon: _passwordSuffix(
                              obscure: _obscureConfirm,
                              onPressed: () {
                                setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                );
                              },
                            ),
                            validator: _validateConfirm,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          if (_registerError != null) ...[
                            SizedBox(height: responsive.smallGap),
                            Text(
                              _registerError!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: responsive.bodySize * 0.82,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                          SizedBox(height: responsive.gap * 1.2),
                          PrimaryButton(
                            key: const Key('register-submit'),
                            label: 'Daftar',
                            icon: Icons.person_add_alt_1_rounded,
                            onPressed: _submit,
                          ),
                          SizedBox(height: responsive.gap * 0.4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Sudah punya akun?',
                                  style: TextStyle(
                                    fontSize: responsive.bodySize * 0.85,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _backToLogin,
                                child: Text(
                                  'Masuk',
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
                            'Akun hanya tersimpan selama aplikasi terbuka.',
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
