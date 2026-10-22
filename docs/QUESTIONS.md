# QUESTIONS.md — Data Soal Dummy

Tema soal: dasar Flutter dan Dart. Indeks opsi dimulai dari 0 (A=0, B=1, C=2, D=3).

| No | Pertanyaan | A | B | C | D | Kunci |
|---|---|---|---|---|---|---|
| 1 | Bahasa pemrograman yang digunakan Flutter adalah... | Kotlin | Dart | Swift | JavaScript | B (1) |
| 2 | Widget yang tampilannya tidak berubah setelah dibuat disebut... | StatefulWidget | InheritedWidget | StatelessWidget | StatefulBuilder | C (2) |
| 3 | Method yang dipanggil untuk memperbarui tampilan pada StatefulWidget adalah... | setState() | build() | update() | refresh() | A (0) |
| 4 | File yang digunakan untuk mendaftarkan aset dan font di Flutter adalah... | main.dart | pubspec.yaml | AndroidManifest.xml | analysis_options.yaml | B (1) |
| 5 | Widget yang menyusun anak-anaknya secara vertikal adalah... | Row | Stack | Column | ListView.horizontal | C (2) |
| 6 | Class yang dipakai untuk mendapatkan ukuran layar adalah... | MediaQuery | Navigator | Theme | Scaffold | A (0) |
| 7 | Perintah untuk menjalankan aplikasi Flutter adalah... | flutter build | flutter run | flutter start | flutter launch | B (1) |
| 8 | Widget yang menumpuk anak-anaknya satu di atas yang lain adalah... | Column | Row | Stack | Wrap | C (2) |
| 9 | Method untuk berpindah ke halaman baru adalah... | Navigator.push() | Navigator.pop() | Navigator.exit() | Navigator.open() | A (0) |
| 10 | Paket yang umum dipakai untuk state management sederhana adalah... | http | provider | path | intl | B (1) |

## Contoh Kode Dart
```dart
final List<Question> questions = [
  Question(
    text: 'Bahasa pemrograman yang digunakan Flutter adalah...',
    options: ['Kotlin', 'Dart', 'Swift', 'JavaScript'],
    correctIndex: 1,
  ),
  // ... lanjutkan untuk soal 2–10 sesuai tabel di atas
];
```
