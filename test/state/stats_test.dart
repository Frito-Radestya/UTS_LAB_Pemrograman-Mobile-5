import 'package:flutter_test/flutter_test.dart';
import 'package:kage/data/quiz_data.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

QuizResult _result({
  CategoryId categoryId = CategoryId.sains,
  int score = 80,
  int correct = 8,
  int total = 10,
  int day = 20,
}) {
  return QuizResult(
    categoryId: categoryId,
    score: score,
    correct: correct,
    total: total,
    duration: const Duration(minutes: 2),
    playedAt: DateTime(2026, 10, day, 20),
    difficulty: Difficulty.pemula,
  );
}

void main() {
  group('T-01 statistik riwayat', () {
    test('statistik kosong bernilai nol', () {
      final app = AppState();
      addTearDown(app.dispose);

      expect(app.totalQuizzes, 0);
      expect(app.bestScore, 0);
      expect(app.averageScore, 0);
      expect(app.accuracyPercent, 0);
      expect(app.completedCategories, 0);
    });

    test('rata-rata, akurasi, skor terbaik, dan kategori dihitung benar', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.history.addAll([
        _result(score: 80, correct: 8, day: 22),
        _result(
          categoryId: CategoryId.logika,
          score: 100,
          correct: 10,
          day: 21,
        ),
        _result(score: 60, correct: 6, day: 20),
      ]);

      expect(app.totalQuizzes, 3);
      expect(app.bestScore, 100);
      expect(app.averageScore, 80);
      expect(app.accuracyPercent, 80);
      expect(app.completedCategories, 2);
      expect(app.bestFor(CategoryId.sains), 80);
      expect(app.bestFor(CategoryId.logika), 100);
      expect(app.bestFor(CategoryId.sejarah), 0);
    });

    test('akurasi memperhitungkan total soal yang berbeda', () {
      final app = AppState();
      addTearDown(app.dispose);
      app.history.addAll([
        _result(correct: 8, total: 10),
        _result(correct: 9, total: 20),
      ]);

      expect(app.accuracyPercent, 57);
    });
  });

  group('T-01 badge', () {
    test('badge pertama dan sempurna mengikuti riwayat', () {
      final app = AppState();
      addTearDown(app.dispose);

      expect(app.badges.firstWhere((b) => b.id == 'first').earned, isFalse);
      app.history.add(_result(score: 100, correct: 10));
      expect(app.badges.firstWhere((b) => b.id == 'first').earned, isTrue);
      expect(app.badges.firstWhere((b) => b.id == 'perfect').earned, isTrue);
    });

    test('explorer dan master membutuhkan semua kategori', () {
      final app = AppState();
      addTearDown(app.dispose);
      for (final category in categories) {
        app.history.add(_result(categoryId: category.id, score: 100));
      }

      expect(app.badges.firstWhere((b) => b.id == 'explorer').earned, isTrue);
      expect(app.badges.firstWhere((b) => b.id == 'master').earned, isTrue);
    });
  });

  group('T-01 perilaku AppState', () {
    test('login, update profil, dan logout mengubah state auth', () {
      final app = AppState();
      addTearDown(app.dispose);

      app.login(name: 'Budi', mail: 'budi@example.com');
      expect(app.loggedIn, isTrue);
      expect(app.fullName, 'Budi');
      expect(app.email, 'budi@example.com');

      app.updateProfile(name: 'Budi Santoso');
      expect(app.fullName, 'Budi Santoso');
      expect(app.email, 'budi@example.com');

      app.logout();
      expect(app.loggedIn, isFalse);
    });

    test('discardProgress menghapus sesi tersimpan', () {
      final app = AppState()..startQuiz(CategoryId.sains);
      addTearDown(app.dispose);
      app.saveProgress();
      expect(app.resume, isNotNull);

      app.discardProgress();

      expect(app.resume, isNull);
    });

    test(
      'nextQuestion berhenti di soal terakhir dan finish mencatat hasil',
      () {
        final app = AppState()..startQuiz(CategoryId.sains);
        addTearDown(app.dispose);

        while (!app.isLastQuestion) {
          app.nextQuestion();
        }

        expect(app.questionIndex, app.totalQuestions - 1);
        app.finishQuiz();
        expect(app.totalQuizzes, 1);
        expect(app.history.first, app.lastResult);
      },
    );
  });
}
