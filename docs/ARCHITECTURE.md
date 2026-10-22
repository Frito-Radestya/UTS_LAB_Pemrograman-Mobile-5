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
    │   ├── category.dart
    │   ├── question.dart
    │   ├── score_record.dart
    │   └── user.dart
    ├── data/
    │   ├── dummy_users.dart
    │   └── questions_data.dart
    ├── providers/
    │   ├── auth_provider.dart
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
Dipilih karena sederhana dan cukup untuk tugas ini. `AuthProvider` dan `QuizProvider` (keduanya `ChangeNotifier`) dipasang di root (`main.dart`) memakai `MultiProvider`, di atas `MaterialApp`, sehingga sesi login dan state kuis tidak hilang saat rotasi layar atau pindah halaman.

### State di `AuthProvider`
| Field | Tipe | Keterangan |
|---|---|---|
| `currentUser` | `User?` | Akun yang sedang login (`null` = belum login) |
| `users` | `List<User>` | Akun dummy dan hasil register selama aplikasi berjalan |
| `isLoggedIn` | `bool` | Status sesi aktif |

| Method | Fungsi |
|---|---|
| `login(email, password)` | Cek kredensial, simpan `currentUser`, kembalikan pesan error atau `null` |
| `register(...)` | Validasi data, cegah email/NIM ganda, lalu otomatis login |
| `logout()` | Hapus sesi aktif tanpa menghapus akun di memori |
| `isEmailRegistered` / `isNimRegistered` | Cek duplikat untuk validasi form |

### State di `QuizProvider`
| Field | Tipe | Keterangan |
|---|---|---|
| `activeCategory` | `Category` | Kategori yang sedang dikerjakan |
| `questions` | `List<Question>` | Soal dari kategori aktif |
| `playerName` | `String` | Nama pengguna |
| `currentIndex` | `int` | Indeks soal aktif |
| `answers` | `List<int?>` | Jawaban terpilih per soal (`null` = belum dijawab) |
| `history` | `List<ScoreRecord>` | Riwayat skor selama aplikasi berjalan, terbaru di awal |
| `lastScore` | `ScoreRecord?` | Hasil percobaan terakhir |

| Method dan getter | Fungsi |
|---|---|
| `startCategory(Category, {playerName})` | Ganti kategori dan kosongkan progres |
| `setName(String)` | Simpan nama |
| `selectAnswer(int)` | Simpan jawaban untuk soal aktif |
| `next()` | Pindah ke soal berikutnya |
| `isLastQuestion` | Apakah soal terakhir |
| `score` | Jumlah jawaban benar |
| `percentage` | Persentase skor |
| `saveResult()` | Simpan hasil ke `history` dan `lastScore` |
| `resetQuiz()` | Ulangi kategori tanpa menghapus riwayat |
| `reset()` | Kosongkan seluruh progres kuis |

Setiap perubahan memanggil `notifyListeners()`.

## Model

| Model | Field utama | Keterangan |
|---|---|---|
| `User` | `name`, `nim`, `email`, `prodi`, `password` | Akun dummy di memori |
| `Question` | `text`, `options`, `correctIndex` | Tepat 4 opsi (A–D) |
| `Category` | `id`, `title`, `description`, `icon`, `questions` | Satu kategori berisi 10 soal |
| `ScoreRecord` | `playerName`, `categoryTitle`, `score`, `total`, `dateTime` | Riwayat satu percobaan kuis |

`QuizProvider` memilih kategori lewat `startCategory()`. Data kategori dan
akun dummy berada di `lib/data/`.

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
