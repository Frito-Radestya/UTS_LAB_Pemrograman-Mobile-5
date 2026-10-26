import 'package:flutter_test/flutter_test.dart';
import 'package:kage/data/quiz_data.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

void main() {
  group('K-07 data akun baru tanpa mock', () {
    test('akun baru dimulai dari keadaan kosong', () {
      final app = AppState();
      addTearDown(app.dispose);

      expect(app.loggedIn, isFalse);
      expect(app.fullName, isEmpty);
      expect(app.email, isEmpty);
      expect(app.xp, 0);
      expect(app.level, 1);
      expect(app.streak, 0);
      expect(app.history, isEmpty);
      expect(app.resume, isNull);
      expect(app.learningPathDone, 0);
      expect(app.bestFor(CategoryId.sains), 0);
      expect(app.badges.firstWhere((b) => b.id == 'streak').earned, isFalse);
    });

    test('nama dan email berasal dari data akun yang masuk', () {
      final app = AppState();
      addTearDown(app.dispose);

      app.login(name: 'Ayu Lestari', mail: 'ayu@example.com');

      expect(app.fullName, 'Ayu Lestari');
      expect(app.email, 'ayu@example.com');
      expect(app.firstName, 'Ayu');
      expect(app.initial, 'A');
    });

    test('progres belajar dihitung dari kategori yang diselesaikan', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.history.addAll([
        QuizResult(
          categoryId: CategoryId.sains,
          score: 80,
          correct: 8,
          total: 10,
          duration: const Duration(minutes: 2),
          playedAt: DateTime(2026, 10, 20),
          difficulty: Difficulty.pemula,
        ),
        QuizResult(
          categoryId: CategoryId.sains,
          score: 90,
          correct: 9,
          total: 10,
          duration: const Duration(minutes: 2),
          playedAt: DateTime(2026, 10, 21),
          difficulty: Difficulty.pemula,
        ),
        QuizResult(
          categoryId: CategoryId.logika,
          score: 100,
          correct: 10,
          total: 10,
          duration: const Duration(minutes: 2),
          playedAt: DateTime(2026, 10, 22),
          difficulty: Difficulty.pemula,
        ),
      ]);

      expect(app.completedCategories, 2);
      expect(app.learningPathDone, 2);
      expect(app.bestFor(CategoryId.sains), 90);
    });

    test('badge Streak 7 mengikuti nilai streak nyata', () {
      final app = AppState();
      addTearDown(app.dispose);
      final now = DateTime.now();
      QuizResult dayResult(int daysAgo) => QuizResult(
        categoryId: CategoryId.sains,
        score: 100,
        correct: 10,
        total: 10,
        duration: const Duration(minutes: 2),
        playedAt: DateTime(now.year, now.month, now.day - daysAgo, 20),
        difficulty: Difficulty.pemula,
      );

      app.history.addAll([for (var i = 0; i < 6; i++) dayResult(i)]);
      expect(app.streak, 6);
      expect(app.badges.firstWhere((b) => b.id == 'streak').earned, isFalse);

      app.history.add(dayResult(6));
      expect(app.streak, 7);
      expect(app.badges.firstWhere((b) => b.id == 'streak').earned, isTrue);
    });

    test('setiap kategori memiliki soal pemula tanpa skor bawaan', () {
      for (final category in categories) {
        expect(questionsFor(category.id, Difficulty.pemula), isNotEmpty);
      }
    });
  });
}
