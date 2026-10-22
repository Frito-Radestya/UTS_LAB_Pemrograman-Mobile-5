import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/main.dart';
import 'package:kuis_app/pages/login_page.dart';
import 'package:kuis_app/pages/main_shell.dart';
import 'package:kuis_app/pages/quiz_list_page.dart';
import 'package:kuis_app/pages/quiz_page.dart';
import 'package:kuis_app/pages/register_page.dart';
import 'package:kuis_app/pages/result_page.dart';
import 'package:kuis_app/pages/score_page.dart';
import 'package:kuis_app/pages/splash_page.dart';
import 'package:kuis_app/pages/welcome_page.dart';
import 'package:kuis_app/providers/auth_provider.dart';
import 'package:kuis_app/providers/quiz_provider.dart';
import 'package:kuis_app/theme/app_theme.dart';
import 'package:kuis_app/widgets/option_button.dart';
import 'package:provider/provider.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester,
    QuizProvider provider,
    Widget page,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<QuizProvider>.value(value: provider),
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: page),
      ),
    );
    // Splash memiliki progress indicator berulang, jadi cukup satu frame.
    if (page is SplashPage) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  testWidgets('aplikasi menunggu ukuran layar valid sebelum membangun UI', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size.zero;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(360, 800);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(SplashPage), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('semua halaman aman di portrait dan landscape', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = QuizProvider();
    provider.setName('Frito');
    for (var i = 0; i < provider.totalQuestions; i++) {
      provider.selectAnswer(provider.currentQuestion.correctIndex);
      provider.next();
    }

    final pages = <Widget>[
      const SplashPage(),
      const LoginPage(),
      const RegisterPage(),
      const MainShell(),
      QuizListPage(onCategoryTap: (_) {}),
      const ScorePage(),
      const WelcomePage(),
      const QuizPage(),
      const ResultPage(),
    ];

    for (final size in const [Size(360, 800), Size(800, 360)]) {
      for (final page in pages) {
        await pumpPage(tester, provider, page, size);
        expect(
          tester.takeException(),
          isNull,
          reason: '${page.runtimeType} gagal pada ukuran $size',
        );
      }
    }
  });

  testWidgets('jawaban tetap terpilih setelah rotasi', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = QuizProvider();
    provider.setName('Frito');
    provider.selectAnswer(1);

    await pumpPage(tester, provider, const QuizPage(), const Size(360, 800));
    expect(
      tester
          .widgetList<OptionButton>(find.byType(OptionButton))
          .where((option) => option.selected),
      hasLength(1),
    );

    // Rotasi ke landscape tanpa membuat provider baru.
    tester.view.physicalSize = const Size(800, 360);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    expect(
      tester
          .widgetList<OptionButton>(find.byType(OptionButton))
          .where((option) => option.selected),
      hasLength(1),
    );
  });
}
