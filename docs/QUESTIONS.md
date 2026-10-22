# QUESTIONS.md — Data Soal Dummy

Tema soal: dasar Flutter, Dart, dan pemrograman. Indeks opsi dimulai dari 0
(A=0, B=1, C=2, D=3). Semua soal berada di `lib/data/questions_data.dart`.

## Kategori 1 — Flutter Dasar

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

## Kategori 2 — Dart & Pemrograman

| No | Pertanyaan | A | B | C | D | Kunci |
|---|---|---|---|---|---|---|
| 1 | Tipe data untuk bilangan bulat di Dart adalah... | double | String | int | bool | C (2) |
| 2 | Kata kunci untuk variabel yang hanya boleh diberi nilai satu kali adalah... | var | final | dynamic | late | B (1) |
| 3 | Simbol untuk komentar satu baris di Dart adalah... | // | /* */ | # | -- | A (0) |
| 4 | Bagian class yang dipanggil saat objek dibuat adalah... | destructor | main | initState | constructor | D (3) |
| 5 | Operator untuk memeriksa apakah dua nilai sama adalah... | = | == | != | => | B (1) |
| 6 | Tipe data Dart yang menyimpan pasangan key-value adalah... | List | Set | Map | Queue | C (2) |
| 7 | Perulangan yang minimal dijalankan satu kali adalah... | for | while | for-in | do-while | D (3) |
| 8 | Tipe data untuk nilai benar atau salah adalah... | bool | int | String | double | A (0) |
| 9 | Method List untuk menambah elemen di akhir adalah... | push() | append() | add() | insertLast() | C (2) |
| 10 | Kata kunci untuk membuat class turunan adalah... | implements | extends | with | override | B (1) |

## Struktur Data

```dart
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
```

Kategori aktif dipilih dari halaman daftar kuis. Setiap kategori berisi
tepat 10 soal dan setiap soal memiliki 4 opsi.
