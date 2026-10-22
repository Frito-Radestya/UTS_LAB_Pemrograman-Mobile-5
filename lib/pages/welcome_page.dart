import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/primary_button.dart';
import 'quiz_page.dart';

/// Halaman pertama: pengguna memasukkan nama sebelum mulai kuis.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Simpan nama ke provider agar dipakai di halaman kuis dan hasil.
    final provider = context.read<QuizProvider>();
    provider.setName(_nameController.text);

    // Navigasi sederhana; transisi fade ditambahkan pada Task 8.
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const QuizPage()),
    );
  }

  OutlineInputBorder _border(Color color) {
    final responsive = Responsive(context);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(responsive.radius),
      borderSide: BorderSide(
        color: color,
        width: responsive.shortestSide * 0.005,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final logoSize = responsive.heroIconSize;

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
                              width: logoSize,
                              height: logoSize,
                              fit: BoxFit.contain,
                            ),
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
                            'Uji pemahaman\nFlutter & Dart',
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
                            'Sepuluh soal pilihan ganda. Pilih jawaban yang benar, '
                            'lalu lihat skor akhirmu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.bodySize,
                              height: 1.5,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: responsive.gap * 1.6),
                          Text(
                            'NAMA KAMU',
                            style: TextStyle(
                              fontSize: responsive.bodySize * 0.72,
                              fontWeight: FontWeight.w400,
                              letterSpacing: responsive.bodySize * 0.14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: responsive.smallGap),
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _startQuiz(),
                            cursorColor: AppColors.accent,
                            style: TextStyle(
                              fontSize: responsive.bodySize * 1.1,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama lengkap',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                size: responsive.bodySize * 1.35,
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: responsive.pagePadding * 0.5,
                                vertical: responsive.gap * 1.15,
                              ),
                              border: _border(AppColors.border),
                              enabledBorder: _border(AppColors.border),
                              focusedBorder: _border(AppColors.accent),
                              errorBorder: _border(AppColors.accent),
                              focusedErrorBorder: _border(AppColors.accent),
                              errorStyle: TextStyle(
                                fontSize: responsive.bodySize * 0.85,
                                color: AppColors.accent,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: responsive.gap * 1.4),
                          PrimaryButton(
                            label: 'Mulai Kuis',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _startQuiz,
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
