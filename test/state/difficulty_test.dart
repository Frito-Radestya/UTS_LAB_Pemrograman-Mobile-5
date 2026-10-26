import 'package:flutter_test/flutter_test.dart';
import 'package:kage/data/quiz_data.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

void main() {
  group('K-03 tingkat kesulitan', () {
    test('questionsFor menyaring soal sesuai tingkat', () {
      expect(questionsFor(CategoryId.sains, Difficulty.pemula), hasLength(10));
      expect(
        questionsFor(CategoryId.sains, Difficulty.menengah),
        hasLength(10),
      );
      expect(questionsFor(CategoryId.sains, Difficulty.ahli), hasLength(10));

      for (final question in questionsFor(CategoryId.sains, Difficulty.ahli)) {
        expect(question.difficulty, Difficulty.ahli);
      }
      expect(questionsFor(CategoryId.teknologi, Difficulty.menengah), isEmpty);
    });

    test('bank soal memiliki opsi dan correctIndex yang valid', () {
      final prompts = <String>{};
      for (final entry in questionsByCategory.entries) {
        for (final question in entry.value) {
          expect(question.options, isNotEmpty);
          expect(
            question.options.any((option) => option.trim().isEmpty),
            isFalse,
          );
          expect(
            question.correctIndex,
            inInclusiveRange(0, question.options.length - 1),
          );
          expect(question.explanation.trim(), isNotEmpty);
          expect(prompts.add('${entry.key.name}:${question.prompt}'), isTrue);
        }
      }
      expect(questionCountFor(CategoryId.sains), 30);
    });

    test('tingkat berbeda menghasilkan XP berbeda', () {
      int xpFor(Difficulty difficulty) {
        final app = AppState()
          ..startQuiz(CategoryId.sains, difficulty: difficulty);
        addTearDown(app.dispose);
        for (var i = 0; i < app.totalQuestions; i++) {
          app.selectAnswer(app.currentQuestion!.correctIndex);
          app.submitCurrent();
          if (!app.isLastQuestion) app.nextQuestion();
        }
        app.finishQuiz();
        return app.xp;
      }

      expect(xpFor(Difficulty.pemula), 100);
      expect(xpFor(Difficulty.menengah), 150);
      expect(xpFor(Difficulty.ahli), 200);
    });

    test('tingkat tanpa soal tidak bisa dipakai untuk memulai sesi', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.setDifficulty(Difficulty.menengah);

      app.startQuiz(CategoryId.teknologi);

      expect(app.selectedDifficulty, Difficulty.pemula);
      expect(app.totalQuestions, greaterThan(0));
      expect(app.currentQuestion, isNotNull);
      expect(app.currentQuestion!.difficulty, Difficulty.pemula);
    });

    test('sesi memakai soal dari tingkat yang dipilih', () {
      final app = AppState()
        ..startQuiz(CategoryId.sains, difficulty: Difficulty.menengah);
      addTearDown(app.dispose);

      expect(app.selectedDifficulty, Difficulty.menengah);
      expect(app.activeQuestions, hasLength(10));
      for (final question in app.activeQuestions) {
        expect(question.difficulty, Difficulty.menengah);
      }
    });
  });
}
