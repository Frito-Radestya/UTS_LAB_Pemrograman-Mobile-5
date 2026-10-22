import 'package:flutter/material.dart';

import 'question.dart';

/// Satu kategori kuis beserta daftar soalnya.
class Category {
  const Category({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.questions,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Question> questions;
}
