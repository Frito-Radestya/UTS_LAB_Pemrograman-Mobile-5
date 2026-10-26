import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/quiz_data.dart';
import '../models/models.dart';
import 'progress.dart';
import 'streak.dart';

class AppState extends ChangeNotifier {
  bool loggedIn = false;
  bool notifications = true;

  String fullName = '';
  String email = '';
  int xp = 0;

  int get level => levelFromXp(xp);

  int get streak => calculateStreak(history, DateTime.now());

  Difficulty selectedDifficulty = Difficulty.pemula;
  CategoryId? activeCategory;
  int questionIndex = 0;
  List<int?> answers = <int?>[];

  /// Soal yang sudah dikirim ke halaman penjelasan dan dikunci untuk diubah.
  List<bool> _submitted = <bool>[];

  /// Urutan soal dan opsi yang diacak untuk sesi kuis berjalan.
  List<Question> _activeQuestions = <Question>[];
  List<int> _questionOrder = <int>[];
  List<List<int>> _optionOrders = <List<int>>[];

  DateTime? quizStartedAt;
  Duration _elapsedBeforeResume = Duration.zero;
  QuizResult? lastResult;
  bool showingCorrect = true;

  Duration get currentElapsed {
    final startedAt = quizStartedAt;
    if (startedAt == null) return _elapsedBeforeResume;
    return _elapsedBeforeResume + DateTime.now().difference(startedAt);
  }

  List<Question> get activeQuestions =>
      List<Question>.unmodifiable(_activeQuestions);

  List<int> get questionOrder => List<int>.unmodifiable(_questionOrder);

  List<List<int>> get optionOrders =>
      List<List<int>>.unmodifiable(_optionOrders.map(List<int>.unmodifiable));

  InProgressQuiz? resume;

  bool isQuestionLocked(int index) =>
      index >= 0 && index < _submitted.length && _submitted[index];

  bool get currentQuestionLocked => isQuestionLocked(questionIndex);

  final List<QuizResult> history = <QuizResult>[];

  String get firstName {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? 'Pengguna' : parts.first;
  }

  String get initial {
    final name = fullName.trim();
    return name.isEmpty ? 'K' : name[0].toUpperCase();
  }

  int get totalQuizzes => history.length;
  int get bestScore => history.isEmpty
      ? 0
      : history.map((e) => e.score).reduce((a, b) => a > b ? a : b);
  int get averageScore => history.isEmpty
      ? 0
      : (history.map((e) => e.score).reduce((a, b) => a + b) / history.length)
            .round();
  int get accuracyPercent {
    if (history.isEmpty) return 0;
    final correct = history.fold<int>(0, (p, e) => p + e.correct);
    final total = history.fold<int>(0, (p, e) => p + e.total);
    return ((correct / total) * 100).round();
  }

  int get completedCategories {
    final ids = history.map((e) => e.categoryId).toSet();
    return ids.length;
  }

  int get learningPathDone => completedCategories;

  List<BadgeItem> get badges {
    final hasQuiz = history.isNotEmpty;
    final perfect = history.any((e) => e.score == 100);
    final explorer = completedCategories >= categories.length;
    final master = categories.every((c) {
      return history.any((h) => h.categoryId == c.id && h.score == 100);
    });
    return [
      BadgeItem(
        id: 'first',
        title: 'First Quiz',
        subtitle: 'Selesaikan kuis pertama',
        asset: 'assets/svg/badge_first_quiz.svg',
        earned: hasQuiz,
      ),
      BadgeItem(
        id: 'perfect',
        title: 'Perfect 10',
        subtitle: 'Dapatkan 100% benar',
        asset: 'assets/svg/badge_perfect_10.svg',
        earned: perfect,
      ),
      BadgeItem(
        id: 'streak',
        title: 'Streak 7',
        subtitle: 'Main 7 hari berturut-turut',
        asset: 'assets/svg/badge_streak_7.svg',
        earned: streak >= 7,
      ),
      BadgeItem(
        id: 'explorer',
        title: 'Explorer',
        subtitle: 'Selesaikan semua kategori',
        asset: 'assets/svg/badge_explorer.svg',
        earned: explorer,
      ),
      BadgeItem(
        id: 'master',
        title: 'Master',
        subtitle: 'Raih skor sempurna di semua kategori',
        asset: 'assets/svg/badge_master_locked.svg',
        earned: master,
      ),
    ];
  }

  void login({String? name, String? mail}) {
    if (name != null && name.trim().isNotEmpty) fullName = name.trim();
    if (mail != null && mail.trim().isNotEmpty) email = mail.trim();
    loggedIn = true;
    notifyListeners();
  }

  void updateProfile({String? name, String? mail}) {
    if (name != null && name.trim().isNotEmpty) fullName = name.trim();
    if (mail != null && mail.trim().isNotEmpty) email = mail.trim();
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void setDifficulty(Difficulty value) {
    selectedDifficulty = value;
    notifyListeners();
  }

  void startQuiz(
    CategoryId id, {
    Difficulty? difficulty,
    int startIndex = 0,
    List<int?>? existing,
    List<bool>? submitted,
    Random? random,
    List<int>? questionOrder,
    List<List<int>>? optionOrders,
    Duration elapsed = Duration.zero,
  }) {
    final requested = difficulty ?? selectedDifficulty;
    selectedDifficulty = hasQuestionsFor(id, requested)
        ? requested
        : Difficulty.values.firstWhere(
            (value) => hasQuestionsFor(id, value),
            orElse: () => requested,
          );
    activeCategory = id;
    questionIndex = startIndex;
    _buildActiveQuestions(
      id,
      difficulty: selectedDifficulty,
      random: random ?? Random(),
      savedQuestionOrder: questionOrder,
      savedOptionOrders: optionOrders,
    );
    final total = _activeQuestions.length;
    answers = List<int?>.filled(total, null);
    _submitted = List<bool>.filled(total, false);
    if (existing != null) {
      for (var i = 0; i < existing.length && i < total; i++) {
        answers[i] = existing[i];
      }
    }
    if (submitted != null) {
      for (var i = 0; i < submitted.length && i < total; i++) {
        _submitted[i] = submitted[i];
      }
    }
    _elapsedBeforeResume = elapsed;
    quizStartedAt = DateTime.now();
    notifyListeners();
  }

  /// Mengacak urutan soal dan opsi, lalu memetakan ulang indeks jawaban benar.
  ///
  /// [savedQuestionOrder] dan [savedOptionOrders] dipakai saat melanjutkan sesi
  /// agar urutan yang dilihat pengguna tetap sama seperti sebelumnya.
  void _buildActiveQuestions(
    CategoryId id, {
    required Difficulty difficulty,
    required Random random,
    List<int>? savedQuestionOrder,
    List<List<int>>? savedOptionOrders,
  }) {
    final source = questionsFor(id, difficulty);
    final order = <int>[];
    if (savedQuestionOrder != null &&
        _isPermutation(savedQuestionOrder, source.length)) {
      order.addAll(savedQuestionOrder);
    } else {
      order.addAll(List<int>.generate(source.length, (i) => i));
      order.shuffle(random);
    }

    _questionOrder = order;
    _optionOrders = <List<int>>[];
    _activeQuestions = <Question>[];
    for (var position = 0; position < order.length; position++) {
      final original = source[order[position]];
      final optionsCount = original.options.length;
      final saved =
          savedOptionOrders != null &&
              position < savedOptionOrders.length &&
              _isPermutation(savedOptionOrders[position], optionsCount)
          ? savedOptionOrders[position]
          : null;
      final optionOrder = <int>[];
      if (saved != null) {
        optionOrder.addAll(saved);
      } else {
        optionOrder.addAll(List<int>.generate(optionsCount, (i) => i));
        optionOrder.shuffle(random);
      }
      _optionOrders.add(optionOrder);
      _activeQuestions.add(
        Question(
          prompt: original.prompt,
          options: [for (final index in optionOrder) original.options[index]],
          correctIndex: optionOrder.indexOf(original.correctIndex),
          explanation: original.explanation,
          funFact: original.funFact,
          difficulty: original.difficulty,
        ),
      );
    }
  }

  bool _isPermutation(List<int> values, int length) {
    if (values.length != length) return false;
    final seen = List<bool>.filled(length, false);
    for (final value in values) {
      if (value < 0 || value >= length || seen[value]) return false;
      seen[value] = true;
    }
    return true;
  }

  /// Menyimpan jawaban saat ini agar bisa dilanjutkan dari Beranda.
  void saveProgress() {
    final id = activeCategory;
    if (id == null) return;
    resume = InProgressQuiz(
      categoryId: id,
      difficulty: selectedDifficulty,
      index: questionIndex,
      answers: List<int?>.from(answers),
      submitted: List<bool>.from(_submitted),
      questionOrder: List<int>.from(_questionOrder),
      optionOrders: [for (final order in _optionOrders) List<int>.from(order)],
      elapsed: currentElapsed,
    );
    notifyListeners();
  }

  void discardProgress() {
    resume = null;
    notifyListeners();
  }

  void continueAdventure() {
    final r = resume;
    if (r == null) return;
    setDifficulty(r.difficulty);
    startQuiz(
      r.categoryId,
      difficulty: r.difficulty,
      startIndex: r.index,
      existing: List<int?>.from(r.answers),
      submitted: List<bool>.from(r.submitted),
      questionOrder: List<int>.from(r.questionOrder),
      optionOrders: [for (final order in r.optionOrders) List<int>.from(order)],
      elapsed: r.elapsed,
    );
  }

  void selectAnswer(int option) {
    if (currentQuestionLocked) return;
    answers[questionIndex] = option;
    notifyListeners();
  }

  bool get hasSelected =>
      questionIndex < answers.length && answers[questionIndex] != null;

  Question? get currentQuestion {
    if (questionIndex >= _activeQuestions.length) return null;
    return _activeQuestions[questionIndex];
  }

  int get totalQuestions => _activeQuestions.length;

  void submitCurrent() {
    final q = currentQuestion;
    if (q == null) return;
    if (questionIndex < _submitted.length) {
      _submitted[questionIndex] = true;
    }
    showingCorrect = answers[questionIndex] == q.correctIndex;
    notifyListeners();
  }

  bool get isLastQuestion {
    if (activeCategory == null) return true;
    return questionIndex >= _activeQuestions.length - 1;
  }

  void nextQuestion() {
    if (isLastQuestion) {
      finishQuiz();
    } else {
      questionIndex += 1;
      notifyListeners();
    }
  }

  void finishQuiz() {
    final id = activeCategory!;
    final list = _activeQuestions;
    if (list.isEmpty) return;
    var correct = 0;
    for (var i = 0; i < list.length; i++) {
      if (answers[i] == list[i].correctIndex) correct++;
    }
    final duration = currentElapsed;
    final result = QuizResult(
      categoryId: id,
      score: ((correct / list.length) * 100).round(),
      correct: correct,
      total: list.length,
      duration: duration,
      playedAt: DateTime.now(),
      difficulty: selectedDifficulty,
    );
    lastResult = result;
    history.insert(0, result);
    xp += (result.score * result.difficulty.xpMultiplier).round();
    resume = null;
    notifyListeners();
  }

  int bestFor(CategoryId id) {
    final items = history.where((e) => e.categoryId == id);
    if (items.isEmpty) return 0;
    return items.map((e) => e.score).reduce((a, b) => a > b ? a : b);
  }
}
