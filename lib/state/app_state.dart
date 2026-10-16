import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quiz_data.dart';
import '../models/quiz_models.dart';

class AppState extends ChangeNotifier {
  AppState._(this._preferences);

  static const _storageKey = 'quiz_app_state_v1';
  final SharedPreferences _preferences;
  Future<void> _writeQueue = Future<void>.value();
  Future<QuizResult>? _submission;
  String _playerName = '';
  String _email = '';
  bool _isLoggedIn = false;
  bool _isDarkMode = true;
  bool _soundEnabled = true;
  bool _remindersEnabled = true;
  QuizCategory? _activeCategory;
  int _questionIndex = 0;
  final Map<int, int> _answers = {};
  final Set<int> _flagged = {};
  final List<QuizResult> _completedResults = [];
  DateTime? _startedAt;

  String get playerName => _playerName;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;
  bool get isDarkMode => _isDarkMode;
  bool get soundEnabled => _soundEnabled;
  bool get remindersEnabled => _remindersEnabled;
  QuizCategory? get activeCategory => _activeCategory;
  int get questionIndex => _questionIndex;
  Map<int, int> get answers => Map.unmodifiable(_answers);
  Set<int> get flagged => Set.unmodifiable(_flagged);
  List<QuizResult> get completedResults => List.unmodifiable(_completedResults);
  QuizQuestion? get currentQuestion => _activeCategory == null
      ? null
      : _activeCategory!.questions[_questionIndex];
  int? get currentAnswer => _answers[_questionIndex];
  int get answeredCount => _answers.length;
  int get totalQuestions => _activeCategory?.questions.length ?? 0;
  double get progress =>
      totalQuestions == 0 ? 0 : answeredCount / totalQuestions;
  int get scoreTotal =>
      _completedResults.fold(0, (sum, result) => sum + result.points);
  int get bestScore => _completedResults.fold(
    0,
    (best, result) => result.points > best ? result.points : best,
  );
  int get completedCount => _completedResults.length;
  int get activeElapsedSeconds {
    final start = _startedAt;
    if (start == null) return 0;
    final seconds = DateTime.now().difference(start).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  static Future<AppState> load() async {
    final state = AppState._(await SharedPreferences.getInstance());
    final stored = state._preferences.get(_storageKey);
    if (stored is String) {
      try {
        final decoded = jsonDecode(stored);
        if (decoded is Map<String, dynamic>) state._restore(decoded);
      } on FormatException {
        // A damaged snapshot is treated as a fresh installation.
      }
    }
    return state;
  }

  Future<void> signIn(String name, String email) {
    final cleanName = name.trim();
    final cleanEmail = email.trim();
    if (cleanName.isEmpty || cleanEmail.isEmpty) {
      throw ArgumentError('Nama dan email tidak boleh kosong.');
    }
    if (_email.isNotEmpty && _email.toLowerCase() != cleanEmail.toLowerCase()) {
      _clearQuiz();
      _submission = null;
      _completedResults.clear();
    }
    _playerName = cleanName;
    _email = cleanEmail;
    _isLoggedIn = true;
    return _changed();
  }

  Future<void> signOut() {
    _playerName = '';
    _email = '';
    _isLoggedIn = false;
    _completedResults.clear();
    _submission = null;
    _clearQuiz();
    return _changed();
  }

  Future<void> setDarkMode(bool value) {
    _isDarkMode = value;
    return _changed();
  }

  Future<void> setSoundEnabled(bool value) {
    _soundEnabled = value;
    return _changed();
  }

  Future<void> setRemindersEnabled(bool value) {
    _remindersEnabled = value;
    return _changed();
  }

  Future<void> startQuiz(QuizCategory category, {bool restart = false}) {
    if (!restart && _activeCategory?.id == category.id) {
      return _writeQueue;
    }
    if (category.questions.isEmpty) {
      throw ArgumentError.value(
        category,
        'category',
        'Kuis tidak memiliki soal.',
      );
    }
    _clearQuiz();
    _submission = null;
    _activeCategory = category;
    _startedAt = DateTime.now();
    return _changed();
  }

  Future<void> selectAnswer(int optionIndex) {
    final question = currentQuestion;
    if (question == null) throw StateError('Tidak ada kuis aktif.');
    RangeError.checkValidIndex(optionIndex, question.options, 'optionIndex');
    _answers[_questionIndex] = optionIndex;
    return _changed();
  }

  Future<void> goToQuestion(int index) {
    final category = _activeCategory;
    if (category == null) throw StateError('Tidak ada kuis aktif.');
    RangeError.checkValidIndex(index, category.questions, 'index');
    _questionIndex = index;
    return _changed();
  }

  Future<void> toggleFlag() {
    if (_activeCategory == null) throw StateError('Tidak ada kuis aktif.');
    if (!_flagged.add(_questionIndex)) _flagged.remove(_questionIndex);
    return _changed();
  }

  Future<void> resetQuiz() {
    _clearQuiz();
    _submission = null;
    return _changed();
  }

  Future<QuizResult> finishQuiz() {
    final existing = _submission;
    if (existing != null) return existing;
    final category = _activeCategory;
    if (category == null) {
      return Future.error(StateError('Tidak ada kuis aktif.'));
    }
    if (answeredCount != totalQuestions) {
      return Future.error(
        StateError('Jawab semua soal sebelum menyelesaikan kuis.'),
      );
    }
    final submittedAnswers = List<int?>.generate(
      totalQuestions,
      (index) => _answers[index],
    );
    var correct = 0;
    for (var index = 0; index < totalQuestions; index++) {
      if (submittedAnswers[index] == category.questions[index].correctIndex) {
        correct++;
      }
    }
    final result = QuizResult(
      categoryId: category.id,
      categoryTitle: category.title,
      playerName: _playerName,
      correct: correct,
      total: totalQuestions,
      points: correct * 100,
      elapsedSeconds: activeElapsedSeconds,
      completedAt: DateTime.now(),
      answers: submittedAnswers,
    );
    _completedResults.insert(0, result);
    _clearQuiz();
    // Install the guard before notifying listeners, including reentrant ones.
    final save = _persist();
    final submission = save.then((_) => result);
    _submission = submission;
    notifyListeners();
    return submission;
  }

  void _clearQuiz() {
    _activeCategory = null;
    _questionIndex = 0;
    _answers.clear();
    _flagged.clear();
    _startedAt = null;
  }

  Future<void> _changed() {
    final save = _persist();
    notifyListeners();
    return save;
  }

  Future<void> _persist() {
    // Capture now, not inside the queue: each write represents its own mutation.
    final snapshot = jsonEncode({
      'playerName': _playerName,
      'email': _email,
      'isLoggedIn': _isLoggedIn,
      'isDarkMode': _isDarkMode,
      'soundEnabled': _soundEnabled,
      'remindersEnabled': _remindersEnabled,
      'completedResults': _completedResults
          .map((result) => result.toJson())
          .toList(),
      'activeQuiz': _activeCategory == null
          ? null
          : {
              'categoryId': _activeCategory!.id,
              'questionIndex': _questionIndex,
              'answers': _answers.map((key, value) => MapEntry('$key', value)),
              'flags': _flagged.toList(),
              'startedAt': _startedAt!.toIso8601String(),
            },
    });
    final write = _writeQueue.then((_) async {
      final saved = await _preferences.setString(_storageKey, snapshot);
      if (!saved) throw StateError('Kuis tidak dapat disimpan.');
    });
    // A failed write is reported to its caller but must not poison later saves.
    _writeQueue = write.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return write;
  }

  void _restore(Map<String, dynamic> json) {
    if (json['isDarkMode'] is bool) _isDarkMode = json['isDarkMode'] as bool;
    if (json['soundEnabled'] is bool) {
      _soundEnabled = json['soundEnabled'] as bool;
    }
    if (json['remindersEnabled'] is bool) {
      _remindersEnabled = json['remindersEnabled'] as bool;
    }
    if (json['playerName'] is String && json['email'] is String) {
      _playerName = (json['playerName'] as String).trim();
      _email = (json['email'] as String).trim();
      _isLoggedIn =
          json['isLoggedIn'] == true &&
          _playerName.isNotEmpty &&
          _email.isNotEmpty;
      if (!_isLoggedIn) {
        _playerName = '';
        _email = '';
      }
    }
    final results = json['completedResults'];
    if (results is List) {
      for (final raw in results) {
        if (raw is! Map<String, dynamic>) continue;
        try {
          final result = QuizResult.fromJson(raw);
          final category = _categoryById(result.categoryId);
          if (category == null || result.total != category.questions.length) {
            continue;
          }
          var valid = true;
          for (var i = 0; i < result.answers.length; i++) {
            final answer = result.answers[i];
            if (answer != null &&
                answer >= category.questions[i].options.length) {
              valid = false;
              break;
            }
          }
          if (valid) _completedResults.add(result);
        } on FormatException {
          continue;
        } on TypeError {
          continue;
        }
      }
      _completedResults.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    }
    final active = json['activeQuiz'];
    if (active is! Map<String, dynamic>) return;
    final category = _categoryById(active['categoryId']);
    final rawStart = active['startedAt'];
    final start = rawStart is String ? DateTime.tryParse(rawStart) : null;
    if (category == null || category.questions.isEmpty || start == null) return;
    _activeCategory = category;
    final now = DateTime.now();
    _startedAt = start.isAfter(now) ? now : start;
    final index = active['questionIndex'];
    if (index is int && index >= 0 && index < category.questions.length) {
      _questionIndex = index;
    }
    final answers = active['answers'];
    if (answers is Map<String, dynamic>) {
      for (final entry in answers.entries) {
        final question = int.tryParse(entry.key);
        final option = entry.value;
        if (question != null &&
            question >= 0 &&
            question < category.questions.length &&
            option is int &&
            option >= 0 &&
            option < category.questions[question].options.length) {
          _answers[question] = option;
        }
      }
    }
    final flags = active['flags'];
    if (flags is List) {
      _flagged.addAll(
        flags.whereType<int>().where(
          (index) => index >= 0 && index < category.questions.length,
        ),
      );
    }
  }

  QuizCategory? _categoryById(Object? id) {
    for (final category in quizCategories) {
      if (category.id == id) return category;
    }
    return null;
  }
}
