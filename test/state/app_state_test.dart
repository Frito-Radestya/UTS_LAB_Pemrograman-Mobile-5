import 'package:flutter_test/flutter_test.dart';
import 'package:kage/models/models.dart';
import 'package:kage/state/app_state.dart';

void main() {
  group('K-01 kunci jawaban', () {
    test('selectAnswer menolak perubahan setelah soal dikirim', () {
      final app = AppState()..startQuiz(CategoryId.sains);

      app.selectAnswer(0);
      expect(app.answers[app.questionIndex], 0);
      expect(app.currentQuestionLocked, isFalse);

      app.submitCurrent();

      expect(app.currentQuestionLocked, isTrue);
      app.selectAnswer(2);
      expect(app.answers[app.questionIndex], 0);
    });

    test('status terkunci ikut tersimpan saat progres disimpan', () {
      final app = AppState()..startQuiz(CategoryId.sains);

      app.selectAnswer(1);
      app.submitCurrent();
      app.saveProgress();

      expect(app.resume, isNotNull);
      expect(app.resume!.submitted[0], isTrue);
    });

    test('soal yang terkunci tetap terkunci setelah dilanjutkan', () {
      final app = AppState()..startQuiz(CategoryId.sains);

      app.selectAnswer(1);
      app.submitCurrent();
      app.saveProgress();
      app.startQuiz(CategoryId.sains);
      app.continueAdventure();

      expect(app.isQuestionLocked(0), isTrue);
      expect(app.answers[0], 1);
      app.selectAnswer(3);
      expect(app.answers[0], 1);
    });
  });
}
