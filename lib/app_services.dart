import 'package:flutter/foundation.dart';

import 'package:kage/data/repositories/auth_repository.dart';
import 'package:kage/data/repositories/history_repository.dart';
import 'package:kage/data/repositories/quiz_repository.dart';
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
    AuthRepository? authRepository,
    HistoryRepository? historyRepository,
    QuizRepository? quizRepository,
  }) {
    this.authRepository = authRepository ?? InMemoryAuthRepository();
    this.historyRepository = historyRepository ?? InMemoryHistoryRepository();
    this.quizRepository = quizRepository ?? const LocalQuizRepository();
    auth = AuthController(repository: this.authRepository);
    settings = SettingsController();
    history = HistoryController(repository: this.historyRepository);
    progress = ProgressController();
    quiz = QuizController(
      onCompleted: _recordQuizResult,
      questions: this.quizRepository,
    );
    routerListenable = Listenable.merge([auth, quiz]);
  }

  late final AuthController auth;
  late final SettingsController settings;
  late final HistoryController history;
  late final ProgressController progress;
  late final QuizController quiz;
  late final AuthRepository authRepository;
  late final HistoryRepository historyRepository;
  late final QuizRepository quizRepository;

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
