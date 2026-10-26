import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum CategoryId { sains, teknologi, sejarah, logika, umum }

enum Difficulty { pemula, menengah, ahli }

class QuizCategory {
  const QuizCategory({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.tags,
    required this.color,
    required this.iconAsset,
    required this.gradientInner,
    required this.gradientOuter,
    this.available = true,
  });

  final CategoryId id;
  final String name;
  final String shortName;
  final String description;
  final List<String> tags;
  final Color color;
  final String iconAsset;
  final Color gradientInner;
  final Color gradientOuter;
  final bool available;
}

class Question {
  const Question({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.funFact,
    this.difficulty = Difficulty.pemula,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String funFact;
  final Difficulty difficulty;
}

class QuizResult {
  const QuizResult({
    required this.categoryId,
    required this.score,
    required this.correct,
    required this.total,
    required this.duration,
    required this.playedAt,
    required this.difficulty,
  });

  final CategoryId categoryId;
  final int score;
  final int correct;
  final int total;
  final Duration duration;
  final DateTime playedAt;
  final Difficulty difficulty;

  int get accuracy => total == 0 ? 0 : ((correct / total) * 100).round();
}

class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.earned,
  });

  final String id;
  final String title;
  final String subtitle;
  final String asset;
  final bool earned;
}

class InProgressQuiz {
  const InProgressQuiz({
    required this.categoryId,
    required this.difficulty,
    required this.index,
    required this.answers,
    this.submitted = const [],
    this.questionOrder = const [],
    this.optionOrders = const [],
  });

  final CategoryId categoryId;
  final Difficulty difficulty;
  final int index;
  final List<int?> answers;

  /// Soal yang sudah dikirim dan tidak boleh diubah lagi setelah dilanjutkan.
  final List<bool> submitted;

  /// Urutan indeks soal pada bank soal asli.
  final List<int> questionOrder;

  /// Urutan indeks opsi asli untuk setiap soal pada [questionOrder].
  final List<List<int>> optionOrders;
}

extension CategoryIdX on CategoryId {
  String get route => name;
}

extension DifficultyX on Difficulty {
  String get label => switch (this) {
    Difficulty.pemula => 'Pemula',
    Difficulty.menengah => 'Menengah',
    Difficulty.ahli => 'Ahli',
  };

  /// Pengali XP aturan KAGE: Pemula 1.0, Menengah 1.5, Ahli 2.0.
  double get xpMultiplier => switch (this) {
    Difficulty.pemula => 1.0,
    Difficulty.menengah => 1.5,
    Difficulty.ahli => 2.0,
  };
}

Color scoreTint(int score) {
  if (score >= 90) return AppColors.gold;
  if (score >= 80) return AppColors.success;
  if (score >= 70) return AppColors.sains;
  return AppColors.textSoft;
}
