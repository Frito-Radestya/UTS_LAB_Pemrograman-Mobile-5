import 'package:flutter_test/flutter_test.dart';
import 'package:kage/app_services.dart';
import 'package:kage/data/quiz_data.dart' as bank;
import 'package:kage/data/repositories/history_repository.dart';
import 'package:kage/data/repositories/question_repository.dart';
import 'package:kage/features/history/history_controller.dart';
import 'package:kage/models/models.dart';

QuizResult _result({
  CategoryId categoryId = CategoryId.sains,
  int score = 80,
  DateTime? playedAt,
}) {
  return QuizResult(
    categoryId: categoryId,
    score: score,
    correct: score ~/ 10,
    total: 10,
    duration: const Duration(minutes: 2),
    playedAt: playedAt ?? DateTime(2026, 10, 20, 20),
    difficulty: Difficulty.pemula,
  );
}

void main() {
  group('LocalQuestionRepository', () {
    const repository = LocalQuestionRepository();

    test('meneruskan katalog dan detail kategori dari bank soal', () {
      expect(repository.categories, bank.categories);
      for (final category in bank.categories) {
        expect(repository.categoryById(category.id).id, category.id);
      }
    });

    test('menghitung soal per kategori dan tingkat', () {
      for (final category in bank.categories) {
        final expectedTotal = Difficulty.values.fold<int>(
          0,
          (total, difficulty) =>
              total + repository.questionsFor(category.id, difficulty).length,
        );
        expect(repository.questionCountFor(category.id), expectedTotal);
      }

      expect(
        repository.questionsFor(CategoryId.sains, Difficulty.menengah),
        isNotEmpty,
      );
      expect(
        repository.questionsFor(CategoryId.logika, Difficulty.menengah),
        isEmpty,
      );
    });

    test('menandai tingkat yang tersedia sesuai isi bank soal', () {
      expect(repository.availableDifficulties(CategoryId.sains), [
        Difficulty.pemula,
        Difficulty.menengah,
        Difficulty.ahli,
      ]);
      expect(repository.availableDifficulties(CategoryId.logika), [
        Difficulty.pemula,
      ]);

      for (final category in bank.categories) {
        for (final difficulty in Difficulty.values) {
          expect(
            repository.hasQuestionsFor(category.id, difficulty),
            repository.questionsFor(category.id, difficulty).isNotEmpty,
          );
        }
      }
    });
  });

  group('InMemoryHistoryRepository', () {
    test('menyimpan salinan hasil dan mengembalikan daftar read-only', () {
      final repository = InMemoryHistoryRepository();
      final result = _result();

      repository.save([result]);

      final loaded = repository.load();
      expect(loaded, [same(result)]);
      expect(() => loaded.add(_result(score: 90)), throwsUnsupportedError);

      repository.clear();
      expect(repository.load(), isEmpty);
    });

    test('controller baru memulihkan riwayat dari repository yang sama', () {
      final repository = InMemoryHistoryRepository();
      final first = HistoryController(repository: repository);
      addTearDown(first.dispose);
      final older = _result(score: 70, playedAt: DateTime(2026, 10, 19));
      final newer = _result(score: 90, playedAt: DateTime(2026, 10, 20));

      first.addResult(older);
      first.addResult(newer);

      final second = HistoryController(repository: repository);
      addTearDown(second.dispose);
      expect(second.history.map((item) => item.score), [90, 70]);
      expect(second.totalQuizzes, 2);
    });

    test('clear pada controller mengosongkan repository bersama', () {
      final repository = InMemoryHistoryRepository();
      final controller = HistoryController(repository: repository);
      addTearDown(controller.dispose);
      controller.addResult(_result());

      controller.clear();

      expect(controller.history, isEmpty);
      expect(repository.load(), isEmpty);

      final restored = HistoryController(repository: repository);
      addTearDown(restored.dispose);
      expect(restored.history, isEmpty);
    });
  });

  group('AppServices', () {
    test('memakai repository yang disuntikkan', () {
      final historyRepository = InMemoryHistoryRepository();
      final app = AppServices(historyRepository: historyRepository);
      addTearDown(app.dispose);

      expect(app.historyRepository, same(historyRepository));
      expect(app.questionRepository, isA<LocalQuestionRepository>());
    });

    test('hasil kuis tersimpan ke repository riwayat bersama', () {
      final historyRepository = InMemoryHistoryRepository();
      final app = AppServices(historyRepository: historyRepository);
      addTearDown(app.dispose);
      app.auth.login(name: 'Budi');
      app.quiz.startQuiz(CategoryId.sains);
      app.quiz.finishQuiz();

      expect(historyRepository.load(), hasLength(1));
      expect(app.history.totalQuizzes, 1);

      final restored = HistoryController(repository: historyRepository);
      addTearDown(restored.dispose);
      expect(restored.totalQuizzes, 1);
    });
  });
}
