import 'package:flutter_test/flutter_test.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

void main() {
  group('K-06 penilaian dinamis', () {
    test('jumlah jawaban mengikuti total soal aktif', () {
      final app = AppState()..startQuiz(CategoryId.sains);
      addTearDown(app.dispose);

      expect(app.answers, hasLength(app.totalQuestions));
      expect(app.totalQuestions, greaterThan(0));
    });

    test('skor kuis kosong berada di rentang 0-100', () {
      final app = AppState()..startQuiz(CategoryId.sains);
      addTearDown(app.dispose);

      app.finishQuiz();

      expect(app.lastResult!.score, 0);
      expect(app.lastResult!.score, inInclusiveRange(0, 100));
    });

    test('skor sempurna selalu 100 berapa pun jumlah soalnya', () {
      final app = AppState()..startQuiz(CategoryId.sains);
      addTearDown(app.dispose);

      for (var i = 0; i < app.totalQuestions; i++) {
        app.selectAnswer(app.currentQuestion!.correctIndex);
        app.submitCurrent();
        if (!app.isLastQuestion) app.nextQuestion();
      }
      app.finishQuiz();

      expect(app.lastResult!.score, 100);
      expect(app.lastResult!.correct, app.totalQuestions);
    });
  });
}
