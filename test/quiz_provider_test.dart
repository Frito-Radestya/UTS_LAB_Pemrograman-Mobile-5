import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/data/questions_data.dart';
import 'package:kuis_app/providers/quiz_provider.dart';

void main() {
  test('provider menyimpan nama, jawaban, dan menghitung skor', () {
    final provider = QuizProvider();
    provider.startCategory(quizCategories.first, playerName: '  Frito  ');
    expect(provider.playerName, 'Frito');

    provider.selectAnswer(provider.currentQuestion.correctIndex);
    expect(provider.selectedAnswer, provider.currentQuestion.correctIndex);
    expect(provider.score, 1);
    expect(provider.percentage, 10);

    provider.next();
    expect(provider.currentIndex, 1);
    // Jawaban soal pertama tetap tersimpan setelah pindah soal.
    expect(provider.answers.first, isNotNull);
  });

  test('startCategory mengganti soal dan mereset progres', () {
    final provider = QuizProvider();
    provider.selectAnswer(0);
    provider.next();

    provider.startCategory(quizCategories[1], playerName: '  Frito  ');

    expect(provider.activeCategory.title, 'Dart & Pemrograman');
    expect(provider.totalQuestions, 10);
    expect(provider.currentIndex, 0);
    expect(provider.playerName, 'Frito');
    expect(provider.answers.every((answer) => answer == null), isTrue);
    expect(provider.score, 0);
  });

  test('saveResult menyimpan skor terakhir dan riwayat', () {
    final provider = QuizProvider();
    provider.startCategory(quizCategories.first, playerName: 'Frito');

    for (var i = 0; i < provider.totalQuestions; i++) {
      provider.selectAnswer(provider.currentQuestion.correctIndex);
      if (!provider.isLastQuestion) {
        provider.next();
      }
    }
    provider.saveResult();

    expect(provider.lastScore, isNotNull);
    expect(provider.lastScore?.score, 10);
    expect(provider.lastScore?.total, 10);
    expect(provider.history, hasLength(1));
    expect(provider.history.first.categoryTitle, 'Flutter Dasar');
    expect(provider.history.first.playerName, 'Frito');

    provider.resetQuiz();
    expect(provider.currentIndex, 0);
    expect(provider.playerName, 'Frito');
    expect(provider.history, hasLength(1));
  });
}
