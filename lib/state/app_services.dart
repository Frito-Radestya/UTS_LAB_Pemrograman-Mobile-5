import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'auth_controller.dart';
import 'history_controller.dart';
import 'progress_controller.dart';
import 'quiz_controller.dart';
import 'settings_controller.dart';

/// Titik komposisi seluruh state aplikasi.
///
/// Controller tetap terpisah dan hanya dihubungkan di sini, sehingga tidak ada
/// satu kelas besar yang mengetahui autentikasi, kuis, riwayat, dan pengaturan
/// sekaligus.
class AppServices {
  AppServices() {
    auth = AuthController();
    settings = SettingsController();
    history = HistoryController();
    progress = ProgressController();
    quiz = QuizController(onCompleted: _recordQuizResult);
    routerListenable = Listenable.merge([auth, quiz]);
  }

  late final AuthController auth;
  late final SettingsController settings;
  late final HistoryController history;
  late final ProgressController progress;
  late final QuizController quiz;

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
