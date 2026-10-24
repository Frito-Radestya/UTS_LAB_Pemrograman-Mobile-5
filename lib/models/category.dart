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
    this.imageAsset,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Question> questions;

  /// Ilustrasi lokal kategori. Null memakai ikon Material sebagai cadangan.
  final String? imageAsset;
}
