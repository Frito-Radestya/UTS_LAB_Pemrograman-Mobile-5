import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/data/questions_data.dart';
import 'package:kuis_app/pages/quiz_page.dart';
import 'package:kuis_app/pages/result_page.dart';
import 'package:kuis_app/providers/quiz_provider.dart';
import 'package:kuis_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

Widget _wrap(QuizProvider provider) {
  return ChangeNotifierProvider<QuizProvider>.value(
    value: provider,
    child: MaterialApp(theme: AppTheme.dark, home: const ResultPage()),
  );
}

void main() {
  testWidgets('ResultPage menyimpan skor sekali dan bisa main lagi', (
    tester,
  ) async {
    final provider = QuizProvider();
    provider.startCategory(quizCategories.first, playerName: 'Demo');
    provider.selectAnswer(provider.currentQuestion.correctIndex);

    await tester.pumpWidget(_wrap(provider));
    await tester.pumpAndSettle();

    expect(find.text('HASIL AKHIR'), findsOneWidget);
    expect(find.text('Flutter Dasar'), findsOneWidget);
    expect(provider.history, hasLength(1));
    expect(provider.lastScore?.score, 1);

    // Rebuild tambahan tidak boleh menggandakan riwayat.
    await tester.pump();
    expect(provider.history, hasLength(1));

    final playAgain = find.text('Coba Lagi');
    expect(find.text('Kembali'), findsOneWidget);
    await tester.ensureVisible(playAgain);
    await tester.tap(playAgain);
    await tester.pumpAndSettle();

    expect(find.byType(QuizPage), findsOneWidget);
    expect(provider.history, hasLength(1));
    expect(provider.currentIndex, 0);
    expect(provider.selectedAnswer, isNull);
  });

  testWidgets('riwayat tidak bertambah saat halaman hasil dirotasi', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = QuizProvider();
    provider.startCategory(quizCategories.first, playerName: 'Demo');
    provider.selectAnswer(provider.currentQuestion.correctIndex);

    await tester.pumpWidget(_wrap(provider));
    await tester.pumpAndSettle();
    expect(provider.history, hasLength(1));

    // Rotasi ke landscape tidak boleh menjalankan initState ulang atau
    // menggandakan riwayat.
    tester.view.physicalSize = const Size(800, 360);
    await tester.pumpAndSettle();
    expect(find.byType(ResultPage), findsOneWidget);
    expect(find.text('HASIL AKHIR'), findsOneWidget);
    expect(provider.history, hasLength(1));

    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(find.byType(ResultPage), findsOneWidget);
    expect(provider.history, hasLength(1));
  });
}
