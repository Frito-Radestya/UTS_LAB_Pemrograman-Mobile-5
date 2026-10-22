import 'package:flutter/foundation.dart';

import '../data/questions_data.dart';
import '../models/question.dart';

/// Menyimpan seluruh state kuis di level root aplikasi.
/// Dengan Provider, state tetap aman saat rotasi atau pindah halaman.
class QuizProvider extends ChangeNotifier {
  QuizProvider({List<Question>? questions})
    : _questions = List<Question>.unmodifiable(questions ?? questionsData) {
    assert(_questions.isNotEmpty, 'Daftar soal tidak boleh kosong');
    _answers = List<int?>.filled(_questions.length, null);
  }

  final List<Question> _questions;
  String _playerName = '';
  int _currentIndex = 0;
  late List<int?> _answers;

  List<Question> get questions => _questions;
  String get playerName => _playerName;
  int get currentIndex => _currentIndex;
  List<int?> get answers => List<int?>.unmodifiable(_answers);

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

  void setName(String name) {
    _playerName = name.trim();
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

  /// Reset seluruh progres sebelum pengguna bermain lagi.
  void reset() {
    _playerName = '';
    _currentIndex = 0;
    _answers = List<int?>.filled(_questions.length, null);
    notifyListeners();
  }
}
