import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/main.dart';
import 'package:kuis_app/pages/login_page.dart';
import 'package:kuis_app/pages/main_shell.dart';
import 'package:kuis_app/pages/profile_page.dart';
import 'package:kuis_app/pages/quiz_list_page.dart';
import 'package:kuis_app/pages/quiz_page.dart';
import 'package:kuis_app/pages/register_page.dart';
import 'package:kuis_app/pages/result_page.dart';
import 'package:kuis_app/pages/score_page.dart';
import 'package:kuis_app/pages/splash_page.dart';
import 'package:kuis_app/providers/auth_provider.dart';
import 'package:kuis_app/providers/quiz_provider.dart';
import 'package:kuis_app/widgets/app_bottom_nav.dart';
import 'package:kuis_app/widgets/option_button.dart';
import 'package:kuis_app/widgets/score_tile.dart';
import 'package:provider/provider.dart';

Future<void> _openLogin(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> _loginDemo(WidgetTester tester) async {
  await _openLogin(tester);
  await tester.enterText(find.byType(TextFormField).at(0), 'demo@mail.com');
  await tester.enterText(find.byType(TextFormField).at(1), '123456');

  final submit = find.byKey(const Key('login-submit'));
  await tester.ensureVisible(submit);
  await tester.tap(submit);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('splash tampil lalu berpindah ke halaman login', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('Flutter & Dart'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Masuk ke akunmu'), findsOneWidget);
  });

  testWidgets('login menolak email dan password kosong', (tester) async {
    await _openLogin(tester);

    final submit = find.byKey(const Key('login-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
  });

  testWidgets('login memvalidasi format email dan akun demo', (tester) async {
    await _openLogin(tester);

    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final submit = find.byKey(const Key('login-submit'));

    await tester.enterText(emailField, 'bukan-email');
    await tester.enterText(passwordField, '123456');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('Format email tidak valid.'), findsOneWidget);

    // Tombol mata mengubah tampilan password.
    final eye = find.byIcon(Icons.visibility_outlined);
    expect(eye, findsOneWidget);
    await tester.tap(eye);
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.enterText(emailField, 'demo@mail.com');
    await tester.enterText(passwordField, '123456');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text('Halo, Demo Mahasiswa'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(MainShell))).canPop(),
      isFalse,
    );
  });

  testWidgets('login menolak password yang salah', (tester) async {
    await _openLogin(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'demo@mail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'salah');

    final submit = find.byKey(const Key('login-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text('Email atau password salah.'), findsOneWidget);
  });

  testWidgets('register valid langsung masuk ke MainShell', (tester) async {
    await _openLogin(tester);

    final registerLink = find.text('Daftar');
    await tester.ensureVisible(registerLink);
    await tester.tap(registerLink);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(6));

    await tester.enterText(fields.at(0), 'Siti Aminah');
    await tester.enterText(fields.at(1), '22010103');
    await tester.enterText(fields.at(2), 'siti@mail.com');
    await tester.enterText(fields.at(3), 'Teknik Komputer');
    await tester.enterText(fields.at(4), 'abcdef');
    await tester.enterText(fields.at(5), 'abcdef');

    final submit = find.byKey(const Key('register-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text('Halo, Siti Aminah'), findsOneWidget);
  });

  testWidgets('bottom nav berpindah tab dan kembali ke Beranda', (
    tester,
  ) async {
    await _loginDemo(tester);

    expect(find.text('Halo, Demo Mahasiswa'), findsOneWidget);
    expect(find.text('Kategori Kuis'), findsOneWidget);
    expect(find.text('Flutter Dasar'), findsOneWidget);
    expect(find.text('Dart & Pemrograman'), findsOneWidget);
    expect(find.text('Belum ada skor'), findsOneWidget);

    await tester.tap(find.text('Kuis'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizListPage), findsOneWidget);
    expect(find.text('Pilih Kategori'), findsOneWidget);

    await tester.tap(find.text('Skor'));
    await tester.pumpAndSettle();
    expect(find.byType(ScorePage), findsOneWidget);
    expect(find.text('Skor Terakhir'), findsOneWidget);
    expect(find.text('Belum ada skor'), findsOneWidget);
    expect(find.byType(ScoreTile), findsNothing);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Demo Mahasiswa'), findsOneWidget);
    expect(find.text('demo@mail.com'), findsOneWidget);
    expect(find.text('Kuis Pemrograman Mobile'), findsOneWidget);
    expect(find.text('Versi 1.0.0'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Demo Mahasiswa'), findsOneWidget);
    expect(find.text('Kategori Kuis'), findsOneWidget);
  });

  testWidgets('kategori di Beranda membuka kuis layar penuh', (tester) async {
    await _loginDemo(tester);

    final category = find.text('Flutter Dasar');
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();

    expect(find.byType(QuizPage), findsOneWidget);
    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    expect(find.text('Demo Mahasiswa'), findsOneWidget);
    expect(find.text('Flutter Dasar'), findsWidgets);
    expect(find.byType(AppBottomNav), findsNothing);
    expect(
      find.text('Bahasa pemrograman yang digunakan Flutter adalah...'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('quiz-back')));
    await tester.pumpAndSettle();

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text('Halo, Demo Mahasiswa'), findsOneWidget);
  });

  testWidgets('tab Kuis memulai kategori dan kembali ke daftar', (
    tester,
  ) async {
    await _loginDemo(tester);

    await tester.tap(find.text('Kuis'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizListPage), findsOneWidget);

    final category = find.text('Dart & Pemrograman');
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();

    expect(find.byType(QuizPage), findsOneWidget);
    expect(find.text('Dart & Pemrograman'), findsWidgets);
    expect(find.text('Demo Mahasiswa'), findsOneWidget);
    expect(find.text('Soal 1 dari 10'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(QuizListPage), findsOneWidget);
    expect(find.text('Pilih Kategori'), findsOneWidget);
  });

  testWidgets('menyelesaikan kuis membuka hasil tanpa kembali ke kuis', (
    tester,
  ) async {
    await _loginDemo(tester);

    final category = find.text('Flutter Dasar');
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    expect(find.byType(QuizPage), findsOneWidget);

    for (var i = 0; i < 10; i++) {
      final option = find.byType(OptionButton).first;
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();

      final action = find.text(i == 9 ? 'Selesai' : 'Lanjut');
      await tester.ensureVisible(action);
      await tester.tap(action);
      await tester.pumpAndSettle();
    }

    expect(find.byType(ResultPage), findsOneWidget);
    expect(find.text('HASIL AKHIR'), findsOneWidget);
    expect(find.byType(QuizPage), findsNothing);

    // Hasil disimpan sekali setelah halaman hasil tampil.
    final quiz = Provider.of<QuizProvider>(
      tester.element(find.byType(ResultPage)),
      listen: false,
    );
    expect(quiz.history, hasLength(1));
    expect(quiz.lastScore?.categoryTitle, 'Flutter Dasar');
    expect(quiz.lastScore?.playerName, 'Demo Mahasiswa');
    expect(quiz.lastScore?.total, 10);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(QuizPage), findsNothing);
    expect(find.byType(ResultPage), findsNothing);
    expect(find.text('Belum ada skor'), findsNothing);
    expect(find.byType(ScoreTile), findsOneWidget);

    await tester.tap(find.text('Skor'));
    await tester.pumpAndSettle();

    expect(find.byType(ScorePage), findsOneWidget);
    expect(find.text('Skor Terakhir'), findsOneWidget);
    expect(find.byType(ScoreTile), findsOneWidget);
    expect(find.textContaining('/10 benar'), findsOneWidget);
  });

  testWidgets('logout dari Profil menghapus sesi dan kembali ke Login', (
    tester,
  ) async {
    await _loginDemo(tester);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('12345678'), findsOneWidget);
    expect(find.text('Teknik Informatika'), findsOneWidget);

    final logout = find.byKey(const Key('logout-button'));
    await tester.ensureVisible(logout);
    await tester.tap(logout);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);

    final auth = Provider.of<AuthProvider>(
      tester.element(find.byType(LoginPage)),
      listen: false,
    );
    expect(auth.currentUser, isNull);
    expect(auth.isLoggedIn, isFalse);
    expect(
      Navigator.of(tester.element(find.byType(LoginPage))).canPop(),
      isFalse,
    );
  });

  testWidgets('sesi login dan tab aktif tetap setelah rotasi', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openLogin(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'demo@mail.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');

    // Rotasi form login: teks yang sudah diketik tetap tersimpan.
    tester.view.physicalSize = const Size(800, 360);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    final loginFields = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .toList(growable: false);
    expect(loginFields, hasLength(2));
    expect(loginFields[0].controller.text, 'demo@mail.com');
    expect(loginFields[1].controller.text, '123456');

    final submit = find.byKey(const Key('login-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);

    await tester.tap(find.text('Kuis'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizListPage), findsOneWidget);

    // Kembali ke portrait: tab Kuis dan sesi login tetap aktif.
    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(find.text('Pilih Kategori'), findsOneWidget);
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).currentIndex,
      1,
    );

    await tester.tap(find.text('Skor'));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(800, 360);
    await tester.pumpAndSettle();
    expect(find.byType(ScorePage), findsOneWidget);
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).currentIndex,
      2,
    );

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Demo Mahasiswa'), findsOneWidget);
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).currentIndex,
      3,
    );
  });

  testWidgets('soal aktif dan jawaban tetap setelah rotasi', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _loginDemo(tester);

    final category = find.text('Flutter Dasar');
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    expect(find.byType(QuizPage), findsOneWidget);

    // Jawab soal pertama lalu pindah ke soal kedua.
    final firstOption = find.byType(OptionButton).first;
    await tester.ensureVisible(firstOption);
    await tester.tap(firstOption);
    await tester.pump();

    final next = find.text('Lanjut');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('Soal 2 dari 10'), findsOneWidget);

    // Pilih jawaban C pada soal kedua.
    final thirdOption = find.byType(OptionButton).at(2);
    await tester.ensureVisible(thirdOption);
    await tester.tap(thirdOption);
    await tester.pump();

    final quiz = Provider.of<QuizProvider>(
      tester.element(find.byType(QuizPage)),
      listen: false,
    );
    expect(quiz.currentIndex, 1);
    expect(quiz.selectedAnswer, 2);

    // Rotasi di tengah kuis tidak boleh menghapus soal aktif atau jawaban.
    tester.view.physicalSize = const Size(800, 360);
    await tester.pumpAndSettle();

    expect(find.byType(QuizPage), findsOneWidget);
    expect(find.text('Soal 2 dari 10'), findsOneWidget);
    expect(quiz.currentIndex, 1);
    expect(quiz.selectedAnswer, 2);

    final selectedOptions = tester
        .widgetList<OptionButton>(find.byType(OptionButton))
        .where((option) => option.selected)
        .toList(growable: false);
    expect(selectedOptions, hasLength(1));
    expect(selectedOptions.single.optionLabel, 'C');

    // Rotasi kembali ke portrait tetap mempertahankan state yang sama.
    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(find.text('Soal 2 dari 10'), findsOneWidget);
    expect(quiz.currentIndex, 1);
    expect(quiz.selectedAnswer, 2);
  });
}
