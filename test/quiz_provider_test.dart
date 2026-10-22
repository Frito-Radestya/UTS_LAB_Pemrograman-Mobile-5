import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/providers/quiz_provider.dart';

void main() {
  test('provider menyimpan nama, jawaban, dan menghitung skor', () {
    final provider = QuizProvider();
    provider.setName('  Frito  ');
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

  test('reset mengosongkan seluruh progres', () {
    final provider = QuizProvider();
    provider.setName('Frito');
    provider.selectAnswer(1);
    provider.next();
    provider.reset();

    expect(provider.playerName, isEmpty);
    expect(provider.currentIndex, 0);
    expect(provider.answers.every((answer) => answer == null), isTrue);
    expect(provider.score, 0);
  });
}
