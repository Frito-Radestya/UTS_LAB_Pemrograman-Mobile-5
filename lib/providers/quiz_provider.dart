import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../data/questions_data.dart';
import '../models/category.dart';
import '../models/question.dart';
import '../models/score_record.dart';

/// Menyimpan seluruh state kuis di level root aplikasi.
/// Dengan Provider, state tetap aman saat rotasi atau pindah halaman.
class QuizProvider extends ChangeNotifier {
  QuizProvider({Category? category, List<Question>? questions})
    : _activeCategory = category ?? quizCategories.first,
      _questions = List<Question>.unmodifiable(
        questions ?? (category ?? quizCategories.first).questions,
      ) {
    assert(_questions.isNotEmpty, 'Daftar soal tidak boleh kosong');
    _answers = List<int?>.filled(_questions.length, null);
  }

  Category _activeCategory;
  List<Question> _questions;
  String _playerName = '';
  int _currentIndex = 0;
  late List<int?> _answers;
  final List<ScoreRecord> _history = [];
  ScoreRecord? _lastScore;

  Category get activeCategory => _activeCategory;
  List<Question> get questions => _questions;
  String get playerName => _playerName;
  int get currentIndex => _currentIndex;
  List<int?> get answers => List<int?>.unmodifiable(_answers);

  /// Riwayat skor selama aplikasi berjalan, terbaru di indeks pertama.
  List<ScoreRecord> get history => List<ScoreRecord>.unmodifiable(_history);
  ScoreRecord? get lastScore => _lastScore;

  Question get currentQuestion => _questions[_currentIndex];
  int? get selectedAnswer => _answers[_currentIndex];
  int get totalQuestions => _questions.length;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;

  /// Jumlah jawaban benar dihitung dengan membandingkan indeks pilihan
  /// yang disimpan terhadap kunci jawaban setiap soal.
  int get score {
    var correct = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) {
        correct++;
      }
    }
    return correct;
  }

  double get percentage =>
      _questions.isEmpty ? 0 : (score / _questions.length) * 100;

  /// Memulai kategori baru dengan progres kosong dan nama pemain aktif.
  void startCategory(Category category, {required String playerName}) {
    _activeCategory = category;
    _questions = List<Question>.unmodifiable(category.questions);
    _currentIndex = 0;
    _answers = List<int?>.filled(_questions.length, null);
    _playerName = playerName.trim();
    notifyListeners();
  }

  void selectAnswer(int optionIndex) {
    // Abaikan indeks di luar rentang agar state tidak rusak.
    if (optionIndex < 0 || optionIndex >= currentQuestion.options.length) {
      return;
    }
    _answers[_currentIndex] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (isLastQuestion) {
      return;
    }
    _currentIndex++;
    notifyListeners();
  }

  /// Menyimpan hasil percobaan ke riwayat dan menjadikannya skor terakhir.
  void saveResult() {
    final record = ScoreRecord(
      playerName: _playerName,
      categoryTitle: _activeCategory.title,
      score: score,
      total: totalQuestions,
      dateTime: DateTime.now(),
    );
    _history.insert(0, record);
    _lastScore = record;
    notifyListeners();
  }

  /// Mengulang kategori yang sama tanpa menghapus nama atau riwayat.
  void resetQuiz() {
    _currentIndex = 0;
    _answers = List<int?>.filled(_questions.length, null);
    notifyListeners();
  }
}
