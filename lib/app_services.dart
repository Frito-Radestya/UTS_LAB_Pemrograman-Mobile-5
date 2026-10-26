import 'package:flutter/foundation.dart';

import 'package:kage/data/repositories/history_repository.dart';
import 'package:kage/data/repositories/question_repository.dart';
import 'package:kage/models/models.dart';
import 'package:kage/features/auth/auth_controller.dart';
import 'package:kage/features/history/history_controller.dart';
import 'package:kage/features/profile/progress_controller.dart';
import 'package:kage/features/quiz/quiz_controller.dart';
import 'package:kage/features/settings/settings_controller.dart';

/// Titik komposisi seluruh state aplikasi.
///
/// Controller tetap terpisah dan hanya dihubungkan di sini, sehingga tidak ada
/// satu kelas besar yang mengetahui autentikasi, kuis, riwayat, dan pengaturan
/// sekaligus.
class AppServices {
  AppServices({
    HistoryRepository? historyRepository,
    QuestionRepository? questionRepository,
  }) {
    this.historyRepository = historyRepository ?? InMemoryHistoryRepository();
    this.questionRepository =
        questionRepository ?? const LocalQuestionRepository();
    auth = AuthController();
    settings = SettingsController();
    history = HistoryController(repository: this.historyRepository);
    progress = ProgressController();
    quiz = QuizController(
      onCompleted: _recordQuizResult,
      questions: this.questionRepository,
    );
    routerListenable = Listenable.merge([auth, quiz]);
  }

  late final AuthController auth;
  late final SettingsController settings;
  late final HistoryController history;
  late final ProgressController progress;
  late final QuizController quiz;
  late final HistoryRepository historyRepository;
  late final QuestionRepository questionRepository;

  /// Perubahan yang memengaruhi keputusan redirect router.
  late final Listenable routerListenable;

  void _recordQuizResult(QuizResult result) {
    history.addResult(result);
    progress.addXp((result.score * result.difficulty.xpMultiplier).round());
  }

  void dispose() {
    quiz.dispose();
    progress.dispose();
    history.dispose();
    settings.dispose();
    auth.dispose();
  }
}
