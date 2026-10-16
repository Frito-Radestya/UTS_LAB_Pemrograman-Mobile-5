import 'package:flutter/material.dart';

class QuizQuestion {
  QuizQuestion({
    required this.prompt,
    required List<String> options,
    required this.correctIndex,
    required this.explanation,
    this.code,
  }) : assert(options.length >= 2),
       assert(correctIndex >= 0 && correctIndex < options.length),
       options = List.unmodifiable(options);

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? code;
}

class QuizCategory {
  QuizCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.difficulty,
    required this.estimatedMinutes,
    required List<QuizQuestion> questions,
  }) : assert(['Mudah', 'Sedang', 'Sulit'].contains(difficulty)),
       questions = List.unmodifiable(questions);

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String difficulty;
  final int estimatedMinutes;
  final List<QuizQuestion> questions;
}

class QuizResult {
  QuizResult({
    required this.categoryId,
    required this.categoryTitle,
    required this.playerName,
    required this.correct,
    required this.total,
    required this.points,
    required this.elapsedSeconds,
    required this.completedAt,
    required List<int?> answers,
  }) : answers = List.unmodifiable(answers);

  final String categoryId;
  final String categoryTitle;
  final String playerName;
  final int correct;
  final int total;
  final int points;
  final int elapsedSeconds;
  final DateTime completedAt;
  final List<int?> answers;

  double get accuracy => total <= 0 ? 0 : (correct / total).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryTitle': categoryTitle,
    'playerName': playerName,
    'correct': correct,
    'total': total,
    'points': points,
    'elapsedSeconds': elapsedSeconds,
    'completedAt': completedAt.toIso8601String(),
    'answers': answers,
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final result = QuizResult(
      categoryId: json['categoryId'] as String,
      categoryTitle: json['categoryTitle'] as String,
      playerName: json['playerName'] as String,
      correct: json['correct'] as int,
      total: json['total'] as int,
      points: json['points'] as int,
      elapsedSeconds: json['elapsedSeconds'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      answers: (json['answers'] as List).map((value) => value as int?).toList(),
    );
    if (result.categoryId.isEmpty ||
        result.total <= 0 ||
        result.correct < 0 ||
        result.correct > result.total ||
        result.points != result.correct * 100 ||
        result.elapsedSeconds < 0 ||
        result.answers.length != result.total ||
        result.answers.any((answer) => answer != null && answer < 0)) {
      throw const FormatException('Invalid quiz result');
    }
    return result;
  }
}
