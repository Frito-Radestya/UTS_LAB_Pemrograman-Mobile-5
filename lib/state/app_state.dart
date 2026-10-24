import 'package:flutter/foundation.dart';

import '../data/quiz_data.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  bool loggedIn = false;
  bool notifications = true;

  String fullName = 'Frito Radestya S.';
  String email = 'frito@example.com';
  int xp = 1250;
  int level = 3;
  int streak = 3;

  Difficulty selectedDifficulty = Difficulty.pemula;
  CategoryId? activeCategory;
  int questionIndex = 0;
  List<int?> answers = List<int?>.filled(10, null);
  DateTime? quizStartedAt;
  QuizResult? lastResult;
  bool showingCorrect = true;

  InProgressQuiz? resume = const InProgressQuiz(
    categoryId: CategoryId.teknologi,
    difficulty: Difficulty.pemula,
    index: 2,
    answers: [0, 2, null, null, null, null, null, null, null, null],
  );

  final List<QuizResult> history = [
    QuizResult(
      categoryId: CategoryId.teknologi,
      score: 80,
      correct: 8,
      total: 10,
      duration: const Duration(minutes: 2, seconds: 45),
      playedAt: DateTime(2025, 10, 8, 20, 12),
      difficulty: Difficulty.pemula,
    ),
    QuizResult(
      categoryId: CategoryId.sains,
      score: 100,
      correct: 10,
      total: 10,
      duration: const Duration(minutes: 2, seconds: 12),
      playedAt: DateTime(2025, 10, 6, 19, 40),
      difficulty: Difficulty.pemula,
    ),
    QuizResult(
      categoryId: CategoryId.sejarah,
      score: 70,
      correct: 7,
      total: 10,
      duration: const Duration(minutes: 3, seconds: 1),
      playedAt: DateTime(2025, 10, 4, 18, 5),
      difficulty: Difficulty.pemula,
    ),
    QuizResult(
      categoryId: CategoryId.logika,
      score: 90,
      correct: 9,
      total: 10,
      duration: const Duration(minutes: 2, seconds: 57),
      playedAt: DateTime(2025, 10, 3, 21, 11),
      difficulty: Difficulty.pemula,
    ),
    QuizResult(
      categoryId: CategoryId.umum,
      score: 80,
      correct: 8,
      total: 10,
      duration: const Duration(minutes: 3, seconds: 20),
      playedAt: DateTime(2025, 10, 1, 16, 48),
      difficulty: Difficulty.pemula,
    ),
  ];

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? 'Frito' : parts.first;
  }

  String get initial => firstName.isEmpty ? 'F' : firstName[0].toUpperCase();

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

  /// Angka di kartu Beranda mengikuti mock (3/5), terpisah dari jumlah riwayat.
  int get learningPathDone => 3;

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
        earned: true,
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

  void startQuiz(CategoryId id, {int startIndex = 0, List<int?>? existing}) {
    activeCategory = id;
    questionIndex = startIndex;
    final total = questionsByCategory[id]!.length;
    answers = List<int?>.filled(total, null);
    if (existing != null) {
      for (var i = 0; i < existing.length && i < total; i++) {
        answers[i] = existing[i];
      }
    }
    quizStartedAt = DateTime.now();
    notifyListeners();
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
    );
    notifyListeners();
  }

  void discardProgress() {
    resume = null;
    notifyListeners();
  }

  void continueAdventure() {
    final r = resume;
    if (r == null) {
      startQuiz(CategoryId.teknologi);
      return;
    }
    startQuiz(
      r.categoryId,
      startIndex: r.index,
      existing: List<int?>.from(r.answers),
    );
  }

  void selectAnswer(int option) {
    answers[questionIndex] = option;
    notifyListeners();
  }

  bool get hasSelected =>
      questionIndex < answers.length && answers[questionIndex] != null;

  Question? get currentQuestion {
    final id = activeCategory;
    if (id == null) return null;
    final list = questionsByCategory[id]!;
    if (questionIndex >= list.length) return null;
    return list[questionIndex];
  }

  int get totalQuestions {
    final id = activeCategory;
    if (id == null) return 0;
    return questionsByCategory[id]!.length;
  }

  void submitCurrent() {
    final q = currentQuestion;
    if (q == null) return;
    showingCorrect = answers[questionIndex] == q.correctIndex;
    notifyListeners();
  }

  bool get isLastQuestion {
    final id = activeCategory;
    if (id == null) return true;
    return questionIndex >= questionsByCategory[id]!.length - 1;
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
    final list = questionsByCategory[id]!;
    var correct = 0;
    for (var i = 0; i < list.length; i++) {
      if (answers[i] == list[i].correctIndex) correct++;
    }
    final duration = DateTime.now().difference(quizStartedAt ?? DateTime.now());
    final result = QuizResult(
      categoryId: id,
      score: correct * 10,
      correct: correct,
      total: list.length,
      duration: duration,
      playedAt: DateTime.now(),
      difficulty: selectedDifficulty,
    );
    lastResult = result;
    history.insert(0, result);
    xp += result.score;
    if (xp >= 1500 && level < 4) level = 4;
    resume = null;
    notifyListeners();
  }

  int bestFor(CategoryId id) {
    final items = history.where((e) => e.categoryId == id);
    if (items.isEmpty) return categoryById(id).bestScore;
    return items.map((e) => e.score).reduce((a, b) => a > b ? a : b);
  }
}
