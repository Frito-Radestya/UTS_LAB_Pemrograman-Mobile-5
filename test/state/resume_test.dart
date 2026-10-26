import 'package:flutter_test/flutter_test.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

void main() {
  group('K-04 resume kesulitan dan waktu', () {
    test('resume mempertahankan tingkat dan total waktu pengerjaan', () {
      final app = AppState()
        ..startQuiz(CategoryId.sains, difficulty: Difficulty.ahli);
      addTearDown(app.dispose);
      app.selectAnswer(app.currentQuestion!.correctIndex);
      app.quizStartedAt = DateTime.now().subtract(const Duration(minutes: 3));
      app.saveProgress();

      expect(app.resume!.difficulty, Difficulty.ahli);
      expect(
        app.resume!.elapsed,
        greaterThanOrEqualTo(const Duration(minutes: 3)),
      );

      app.startQuiz(CategoryId.teknologi, difficulty: Difficulty.pemula);
      app.continueAdventure();

      expect(app.activeCategory, CategoryId.sains);
      expect(app.selectedDifficulty, Difficulty.ahli);
      expect(
        app.activeQuestions.every((q) => q.difficulty == Difficulty.ahli),
        isTrue,
      );

      app.finishQuiz();

      expect(app.lastResult!.difficulty, Difficulty.ahli);
      expect(
        app.lastResult!.duration,
        greaterThanOrEqualTo(const Duration(minutes: 3)),
      );
    });

    test('waktu setelah resume ditambahkan ke waktu tersimpan', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.resume = const InProgressQuiz(
        categoryId: CategoryId.sains,
        difficulty: Difficulty.menengah,
        index: 0,
        answers: [],
        elapsed: Duration(minutes: 5),
      );

      app.continueAdventure();
      app.quizStartedAt = DateTime.now().subtract(const Duration(minutes: 1));

      expect(
        app.currentElapsed,
        greaterThanOrEqualTo(const Duration(minutes: 6)),
      );
      app.saveProgress();
      expect(
        app.resume!.elapsed,
        greaterThanOrEqualTo(const Duration(minutes: 6)),
      );
    });

    test('continueAdventure tanpa resume tidak memulai kuis palsu', () {
      final app = AppState();
      addTearDown(app.dispose);

      app.continueAdventure();

      expect(app.activeCategory, isNull);
      expect(app.currentQuestion, isNull);
      expect(app.totalQuestions, 0);
    });
  });
}
