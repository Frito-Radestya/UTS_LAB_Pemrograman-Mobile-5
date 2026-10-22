import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/question.dart';

/// Soal kategori "Flutter Dasar".
const List<Question> flutterQuestions = [
  Question(
    text: 'Bahasa pemrograman yang digunakan Flutter adalah...',
    options: ['Kotlin', 'Dart', 'Swift', 'JavaScript'],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang tampilannya tidak berubah setelah dibuat disebut...',
    options: [
      'StatefulWidget',
      'InheritedWidget',
      'StatelessWidget',
      'StatefulBuilder',
    ],
    correctIndex: 2,
  ),
  Question(
    text: 'Method yang dipanggil untuk memperbarui tampilan pada StatefulWidget adalah...',
    options: ['setState()', 'build()', 'update()', 'refresh()'],
    correctIndex: 0,
  ),
  Question(
    text: 'File yang digunakan untuk mendaftarkan aset dan font di Flutter adalah...',
    options: [
      'main.dart',
      'pubspec.yaml',
      'AndroidManifest.xml',
      'analysis_options.yaml',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang menyusun anak-anaknya secara vertikal adalah...',
    options: ['Row', 'Stack', 'Column', 'ListView.horizontal'],
    correctIndex: 2,
  ),
  Question(
    text: 'Class yang dipakai untuk mendapatkan ukuran layar adalah...',
    options: ['MediaQuery', 'Navigator', 'Theme', 'Scaffold'],
    correctIndex: 0,
  ),
  Question(
    text: 'Perintah untuk menjalankan aplikasi Flutter adalah...',
    options: [
      'flutter build',
      'flutter run',
      'flutter start',
      'flutter launch',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang menumpuk anak-anaknya satu di atas yang lain adalah...',
    options: ['Column', 'Row', 'Stack', 'Wrap'],
    correctIndex: 2,
  ),
  Question(
    text: 'Method untuk berpindah ke halaman baru adalah...',
    options: [
      'Navigator.push()',
      'Navigator.pop()',
      'Navigator.exit()',
      'Navigator.open()',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Paket yang umum dipakai untuk state management sederhana adalah...',
    options: ['http', 'provider', 'path', 'intl'],
    correctIndex: 1,
  ),
];

/// Soal kategori "Dart & Pemrograman".
const List<Question> dartQuestions = [
  Question(
    text: 'Tipe data untuk bilangan bulat di Dart adalah...',
    options: ['double', 'String', 'int', 'bool'],
    correctIndex: 2,
  ),
  Question(
    text: 'Kata kunci untuk variabel yang hanya boleh diberi nilai satu kali adalah...',
    options: ['var', 'final', 'dynamic', 'late'],
    correctIndex: 1,
  ),
  Question(
    text: 'Simbol untuk komentar satu baris di Dart adalah...',
    options: ['//', '/* */', '#', '--'],
    correctIndex: 0,
  ),
  Question(
    text: 'Bagian class yang dipanggil saat objek dibuat adalah...',
    options: ['destructor', 'main', 'initState', 'constructor'],
    correctIndex: 3,
  ),
  Question(
    text: 'Operator untuk memeriksa apakah dua nilai sama adalah...',
    options: ['=', '==', '!=', '=>'],
    correctIndex: 1,
  ),
  Question(
    text: 'Tipe data Dart yang menyimpan pasangan key-value adalah...',
    options: ['List', 'Set', 'Map', 'Queue'],
    correctIndex: 2,
  ),
  Question(
    text: 'Perulangan yang minimal dijalankan satu kali adalah...',
    options: ['for', 'while', 'for-in', 'do-while'],
    correctIndex: 3,
  ),
  Question(
    text: 'Tipe data untuk nilai benar atau salah adalah...',
    options: ['bool', 'int', 'String', 'double'],
    correctIndex: 0,
  ),
  Question(
    text: 'Method List untuk menambah elemen di akhir adalah...',
    options: ['push()', 'append()', 'add()', 'insertLast()'],
    correctIndex: 2,
  ),
  Question(
    text: 'Kata kunci untuk membuat class turunan adalah...',
    options: ['implements', 'extends', 'with', 'override'],
    correctIndex: 1,
  ),
];

/// Dua kategori kuis dummy yang dipakai aplikasi.
const List<Category> quizCategories = [
  Category(
    id: 'flutter-dasar',
    title: 'Flutter Dasar',
    description: 'Widget, layout, dan alur dasar aplikasi Flutter.',
    icon: Icons.phone_android_rounded,
    questions: flutterQuestions,
  ),
  Category(
    id: 'dart-pemrograman',
    title: 'Dart & Pemrograman',
    description: 'Tipe data, fungsi, dan logika dasar bahasa Dart.',
    icon: Icons.code_rounded,
    questions: dartQuestions,
  ),
];
