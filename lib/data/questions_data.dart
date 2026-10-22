import '../models/question.dart';

/// Data soal dummy sesuai docs/QUESTIONS.md.
/// Tidak ada database/API; seluruh soal disimpan di file ini.
const List<Question> questionsData = [
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
