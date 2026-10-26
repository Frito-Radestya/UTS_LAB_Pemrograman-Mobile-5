import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kage/data/quiz_data.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

void main() {
  group('K-02 pengacakan soal dan opsi', () {
    test('correctIndex dipetakan ke opsi hasil acak', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.startQuiz(CategoryId.sains, random: Random(42));

      final source = questionsByCategory[CategoryId.sains]!;
      expect(app.activeQuestions, hasLength(source.length));
      for (final question in app.activeQuestions) {
        final original = source.firstWhere((q) => q.prompt == question.prompt);
        expect(
          question.options[question.correctIndex],
          original.options[original.correctIndex],
        );
      }
    });

    test('seed yang sama menghasilkan urutan yang sama', () {
      final first = AppState()..startQuiz(CategoryId.sains, random: Random(7));
      final second = AppState()..startQuiz(CategoryId.sains, random: Random(7));
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      expect(
        first.activeQuestions.map((q) => q.prompt).toList(),
        second.activeQuestions.map((q) => q.prompt).toList(),
      );
      expect(
        first.activeQuestions.map((q) => q.options).toList(),
        second.activeQuestions.map((q) => q.options).toList(),
      );
    });

    test('seed berbeda menghasilkan urutan berbeda', () {
      final first = AppState()..startQuiz(CategoryId.sains, random: Random(1));
      final second = AppState()..startQuiz(CategoryId.sains, random: Random(2));
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      expect(
        first.activeQuestions.map((q) => q.prompt).toList(),
        isNot(equals(second.activeQuestions.map((q) => q.prompt).toList())),
      );
    });

    test('menjawab semua opsi benar tetap bernilai 100', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.startQuiz(CategoryId.sains, random: Random(99));

      while (!app.isLastQuestion) {
        app.selectAnswer(app.currentQuestion!.correctIndex);
        app.submitCurrent();
        app.nextQuestion();
      }
      app.selectAnswer(app.currentQuestion!.correctIndex);
      app.submitCurrent();
      app.finishQuiz();

      expect(app.lastResult, isNotNull);
      expect(app.lastResult!.correct, app.lastResult!.total);
      expect(app.lastResult!.score, 100);
    });

    test('urutan acak dipertahankan saat melanjutkan kuis', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.startQuiz(CategoryId.sains, random: Random(11));
      final prompts = app.activeQuestions.map((q) => q.prompt).toList();
      final options = app.activeQuestions.map((q) => q.options).toList();
      app.saveProgress();

      app.startQuiz(CategoryId.sains, random: Random(22));
      app.continueAdventure();

      expect(app.activeQuestions.map((q) => q.prompt).toList(), prompts);
      expect(app.activeQuestions.map((q) => q.options).toList(), options);
    });
  });
}
