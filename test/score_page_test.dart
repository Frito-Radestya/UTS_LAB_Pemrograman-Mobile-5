import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/data/questions_data.dart';
import 'package:kuis_app/pages/score_page.dart';
import 'package:kuis_app/providers/quiz_provider.dart';
import 'package:kuis_app/theme/app_theme.dart';
import 'package:kuis_app/widgets/score_tile.dart';
import 'package:provider/provider.dart';

Widget _wrap(QuizProvider provider) {
  return ChangeNotifierProvider<QuizProvider>.value(
    value: provider,
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const Scaffold(body: ScorePage()),
    ),
  );
}

void main() {
  testWidgets('ScorePage menampilkan empty state saat belum ada skor', (
    tester,
  ) async {
    final provider = QuizProvider();

    await tester.pumpWidget(_wrap(provider));
    await tester.pumpAndSettle();

    expect(find.text('Skor Terakhir'), findsOneWidget);
    expect(find.text('Belum ada skor'), findsOneWidget);
    expect(find.byType(ScoreTile), findsNothing);
    expect(find.text('Riwayat Sebelumnya'), findsNothing);
  });

  testWidgets('ScorePage menampilkan skor terakhir dan riwayat sebelumnya', (
    tester,
  ) async {
    final provider = QuizProvider();
    provider.startCategory(quizCategories[0], playerName: 'Demo');
    provider.selectAnswer(provider.currentQuestion.correctIndex);
    provider.saveResult();

    provider.startCategory(quizCategories[1], playerName: 'Demo');
    provider.saveResult();

    await tester.pumpWidget(_wrap(provider));
    await tester.pumpAndSettle();

    expect(find.text('Skor Terakhir'), findsOneWidget);
    expect(find.text('Riwayat Sebelumnya'), findsOneWidget);
    expect(find.byType(ScoreTile), findsNWidgets(2));
    expect(find.textContaining('/10 benar'), findsNWidgets(2));

    final tiles = tester.widgetList<ScoreTile>(find.byType(ScoreTile)).toList();
    expect(tiles.first.record.categoryTitle, 'Dart & Pemrograman');
    expect(tiles.last.record.categoryTitle, 'Flutter Dasar');
    expect(tiles.last.record.score, 1);
  });
}
