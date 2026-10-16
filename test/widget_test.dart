import 'package:bolt_quiz/data/quiz_data.dart';
import 'package:bolt_quiz/main.dart';
import 'package:bolt_quiz/screens/quiz_screen.dart';
import 'package:bolt_quiz/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<AppState> mount(WidgetTester tester, {bool signedIn = false}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = await AppState.load();
    if (signedIn) await state.signIn('Rizky Ramadhan', 'rizky@example.com');
    await tester.pumpWidget(BoltQuizApp(state: state));
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets('Form masuk menampilkan validasi nama dan email', (tester) async {
    await mount(tester);
    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Nama wajib diisi untuk hasil kuis.'), findsOneWidget);
    expect(find.text('Masukkan alamat email yang valid.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Masuk menggunakan nama lalu navigasi kategori dan profil', (
    tester,
  ) async {
    final state = await mount(tester);
    await tester.enterText(
      find.byKey(const ValueKey('name-field')),
      'Ayu Putri',
    );
    await tester.enterText(
      find.byKey(const ValueKey('email-field')),
      'ayu@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'demo12345',
    );
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(state.playerName, 'Ayu Putri');
    expect(find.text('Halo, Ayu Putri! 👋'), findsOneWidget);
    await tester.tap(find.text('Kategori').last);
    await tester.pumpAndSettle();
    expect(find.text('Pilih tantanganmu.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'tidak ada kategori ini');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('Ayu Putri'), findsOneWidget);
    expect(find.text('ayu@example.com'), findsOneWidget);
  });

  testWidgets('Pilihan bertahan setelah rotasi dan kembali ke beranda', (
    tester,
  ) async {
    final state = await mount(tester, signedIn: true);
    await state.startQuiz(quizCategories.first);
    final homeContext = tester.element(find.byType(NavigationBar));
    Navigator.of(homeContext)
        .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));
    await tester.pumpAndSettle();
    await state.selectAnswer(2);
    await tester.pump();
    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(state.currentAnswer, 2);
    expect(find.text(state.currentQuestion!.prompt), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byTooltip('Kembali'));
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(state.currentAnswer, 2);
    expect(find.text('Lanjutkan kuis'), findsOneWidget);
  });

  testWidgets('Menyelesaikan kuis menampilkan nama skor dan pembahasan', (
    tester,
  ) async {
    final state = await mount(tester, signedIn: true);
    final category = quizCategories.first;
    await state.startQuiz(category);
    Navigator.of(tester.element(find.byType(NavigationBar)))
        .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));
    await tester.pumpAndSettle();
    for (var i = 0; i < category.questions.length; i++) {
      final question = category.questions[i];
      final answer = find.text(question.options[question.correctIndex]);
      await tester.ensureVisible(answer);
      await tester.tap(answer);
      await tester.pumpAndSettle();
      expect(state.currentAnswer, question.correctIndex);
      if (i < category.questions.length - 1) {
        await tester.ensureVisible(find.text('Soal berikutnya'));
        await tester.tap(find.text('Soal berikutnya'));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(find.text('Kumpulkan jawaban'));
    await tester.tap(find.text('Kumpulkan jawaban'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, kumpulkan'));
    await tester.pumpAndSettle();
    expect(find.text('Rizky Ramadhan'), findsOneWidget);
    expect(find.text('8 dari 8 jawaban benar'), findsOneWidget);
    expect(find.text('+800 poin'), findsOneWidget);
    expect(state.completedCount, 1);
    await tester.ensureVisible(find.text('Pembahasan jawaban'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(320, 568);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Coba lagi'));
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(state.answeredCount, 0);
    expect(state.questionIndex, 0);
    expect(state.completedCount, 1);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Mode tamu menyimpan nama tanpa sandi', (tester) async {
    final state = await mount(tester);
    await tester.ensureVisible(find.text('Coba sebagai tamu'));
    await tester.tap(find.text('Coba sebagai tamu'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('guest-name-field')),
      'Budi Santoso',
    );
    await tester.tap(find.text('Mulai belajar'));
    await tester.pumpAndSettle();
    expect(state.playerName, 'Budi Santoso');
    expect(find.text('Halo, Budi Santoso! 👋'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Halaman mobile kecil dan tema terang tidak overflow', (
    tester,
  ) async {
    final state = await mount(tester, signedIn: true);
    tester.view.physicalSize = const Size(320, 568);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Kategori').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await state.setDarkMode(false);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(NavigationBar))).brightness,
      Brightness.light,
    );
    expect(tester.takeException(), isNull);
  });
}
