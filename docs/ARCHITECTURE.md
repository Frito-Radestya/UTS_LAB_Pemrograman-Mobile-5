# ARCHITECTURE.md

## Struktur Folder
```
kuis_app/
├── AGENTS.md
├── PRD.md
├── DESIGN.md
├── TASKS.md
├── pubspec.yaml
├── assets/
│   ├── fonts/            # Onest-Light.ttf, Onest-Regular.ttf
│   ├── images/           # bg_temple.jpg, logo.png, trophy.png
│   └── references/       # screenshot Kage (tidak ikut build)
├── docs/
│   ├── ARCHITECTURE.md
│   ├── QUESTIONS.md
│   └── CREDITS.md
└── lib/
    ├── main.dart
    ├── models/
    │   └── question.dart
    ├── data/
    │   └── questions_data.dart
    ├── providers/
    │   └── quiz_provider.dart
    ├── pages/
    │   ├── welcome_page.dart
    │   ├── quiz_page.dart
    │   └── result_page.dart
    ├── widgets/
    │   ├── app_background.dart
    │   ├── primary_button.dart
    │   ├── option_button.dart
    │   ├── question_card.dart
    │   └── quiz_progress_bar.dart
    ├── theme/
    │   └── app_theme.dart
    ├── utils/
    │   ├── app_route.dart      # transisi fade
    │   └── responsive.dart
```

## State Management: Provider
Dipilih karena sederhana dan cukup untuk tugas ini. `QuizProvider` (`ChangeNotifier`) dipasang di root (`main.dart`), di atas `MaterialApp`, sehingga state tidak ikut hilang saat rotasi layar atau pindah halaman.

### State di `QuizProvider`
| Field | Tipe | Keterangan |
|---|---|---|
| `playerName` | `String` | Nama pengguna |
| `questions` | `List<Question>` | Daftar soal (dari data dummy) |
| `currentIndex` | `int` | Indeks soal aktif |
| `answers` | `List<int?>` | Jawaban terpilih per soal (`null` = belum dijawab) |

### Method dan getter
| Nama | Fungsi |
|---|---|
| `setName(String)` | Simpan nama |
| `selectAnswer(int)` | Simpan jawaban untuk soal aktif |
| `next()` | Pindah ke soal berikutnya |
| `isLastQuestion` | Apakah soal terakhir |
| `score` | Jumlah jawaban benar |
| `percentage` | Persentase skor |
| `reset()` | Kosongkan semua state |

Setiap perubahan memanggil `notifyListeners()`.

## Model
```dart
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
}
```

## Pembagian Stateless dan Stateful
| Widget | Jenis | Alasan |
|---|---|---|
| `PrimaryButton`, `OptionButton`, `QuestionCard`, `QuizProgressBar`, `AppBackground` | Stateless | Tampilan murni, data dari parameter |
| `ResultPage`, `QuizPage` | Stateless | Membaca data dari Provider |
| `WelcomePage` | Stateful | Memiliki `TextEditingController` dan form key |
| `MyApp` | Stateless | Root aplikasi |

## Navigasi
`Navigator.push` / `pushReplacement` dengan `PageRouteBuilder` + `FadeTransition`:
- `WelcomePage` → `QuizPage` (setelah nama valid)
- `QuizPage` → `ResultPage` (setelah soal terakhir)
- `ResultPage` → `WelcomePage` (Main Lagi, setelah `reset()`)

## Responsif
Semua ukuran melalui helper `lib/utils/responsive.dart` (berbasis `MediaQuery`), contoh:
```dart
class Responsive {
  final BuildContext context;
  Responsive(this.context);
  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;
  double get headingSize => w * 0.115;
  double get bodySize => w * 0.0425;
  double get pagePadding => w * 0.06;
}
```
Beri `clamp` pada ukuran font agar wajar di tablet dan landscape.
