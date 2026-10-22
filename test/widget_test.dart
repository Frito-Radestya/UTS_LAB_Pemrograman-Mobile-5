import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/main.dart';
import 'package:kuis_app/pages/login_page.dart';
import 'package:kuis_app/pages/register_page.dart';
import 'package:kuis_app/pages/splash_page.dart';

Future<void> _openLogin(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 2));
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Login berhasil.'), findsOneWidget);
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

  testWidgets('register valid menampilkan pesan berhasil', (tester) async {
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Pendaftaran berhasil.'), findsOneWidget);
  });
}
