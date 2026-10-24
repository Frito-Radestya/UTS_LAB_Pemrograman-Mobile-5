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
│   ├── fonts/            # Onest Regular 400, Medium 500, SemiBold 600, Bold 700
│   ├── images/           # background, kategori, badge, dekorasi, ikon KAGE
│   └── references/       # screenshot referensi (tidak ikut build)
├── docs/
│   ├── ARCHITECTURE.md
│   ├── QUESTIONS.md
│   ├── CREDITS.md
│   ├── DESIGN.md
│   ├── ASSET_CATALOG.md
│   └── IMPLEMENTATION_REPORT.md
├── web/                  # entry point Flutter Web (index.html, manifest, ikon)
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
    │   ├── splash_page.dart
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   ├── main_shell.dart       # 4 tab dengan IndexedStack
    │   ├── home_page.dart        # Beranda
    │   ├── quiz_list_page.dart   # daftar kategori di tab Kuis
    │   ├── score_page.dart       # tab Skor
    │   ├── profile_page.dart     # tab Profil dan logout
    │   ├── settings_page.dart
    │   ├── quiz_page.dart
    │   └── result_page.dart
    ├── widgets/
    │   ├── app_background.dart
    │   ├── app_bottom_nav.dart
    │   ├── app_text_field.dart
    │   ├── category_card.dart
    │   ├── empty_score_card.dart
    │   ├── kage_achievement_badge.dart
    │   ├── kage_badge_tile.dart
    │   ├── kage_brand.dart
    │   ├── kage_category_tile.dart
    │   ├── kage_logo.dart
    │   ├── kage_section_header.dart
    │   ├── kage_stat_card.dart
    │   ├── option_button.dart
    │   ├── primary_button.dart
    │   ├── question_card.dart
    │   ├── quiz_progress_bar.dart
    │   ├── score_tile.dart
    │   └── secondary_button.dart
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
| `startCategory(Category, {required playerName})` | Ganti kategori, kosongkan progres, dan simpan nama pemain |
| `selectAnswer(int)` | Simpan jawaban untuk soal aktif |
| `next()` | Pindah ke soal berikutnya |
| `isLastQuestion` | Apakah soal terakhir |
| `score` | Jumlah jawaban benar |
| `percentage` | Persentase skor |
| `saveResult()` | Simpan hasil ke `history` dan `lastScore` |
| `resetQuiz()` | Ulangi kategori tanpa menghapus nama atau riwayat |

Setiap perubahan memanggil `notifyListeners()`.

## Model

| Model | Field utama | Keterangan |
|---|---|---|
| `User` | `name`, `nim`, `email`, `prodi`, `password` | Akun dummy di memori |
| `Question` | `text`, `options`, `correctIndex` | Tepat 4 opsi (A–D) |
| `Category` | `id`, `title`, `description`, `icon`, `imageAsset`, `questions` | Satu kategori berisi 10 soal dan ilustrasi lokal |
| `ScoreRecord` | `playerName`, `categoryTitle`, `score`, `total`, `dateTime` | Riwayat satu percobaan kuis |

`QuizProvider` memilih kategori lewat `startCategory()`. Data kategori dan
akun dummy berada di `lib/data/`.

## Pembagian Stateless dan Stateful
| Widget | Jenis | Alasan |
|---|---|---|
| `PrimaryButton`, `OptionButton`, `QuestionCard`, `QuizProgressBar`, `AppBackground` | Stateless | Tampilan murni, data dari parameter |
| `AppTextField`, `CategoryCard`, `ScoreTile`, `AppBottomNav` | Stateless | Widget reusable; state form dan tab tetap di halaman/provider |
| `SplashPage` | Stateful | Memiliki timer untuk pindah ke Login |
| `LoginPage`, `RegisterPage` | Stateful | Memiliki `TextEditingController`, form key, dan toggle password |
| `MainShell` | Stateful | Menyimpan indeks tab aktif; `IndexedStack` menjaga state tiap tab |
| `HomePage` | Stateless | Membaca `AuthProvider` dan `QuizProvider`, lalu menampilkan Beranda |
| `QuizListPage` | Stateless | Menampilkan daftar kategori; aksi mulai kuis diteruskan lewat callback |
| `ScorePage` | Stateful | Menyimpan filter kategori di tab Skor; data berasal dari `QuizProvider` |
| `ProfilePage` | Stateless | Membaca akun aktif dan riwayat untuk ringkasan/badge; logout diteruskan lewat callback |
| `ResultPage` | Stateful | Menyimpan hasil sekali lewat post-frame callback di `initState` |
| `QuizPage` | Stateless | Membaca data dari Provider |
| `MyApp` | Stateless | Root aplikasi |

## Navigasi
`Navigator.push` / `pushReplacement` dengan `PageRouteBuilder` + `FadeTransition`:
- `SplashPage` → `LoginPage` (setelah 2 detik)
- `LoginPage` ↔ `RegisterPage` (tautan daftar/masuk)
- Login atau register berhasil → `MainShell` dengan `pushAndRemoveUntil`, sehingga
  tombol back tidak kembali ke Login/Splash.
- Di `MainShell`, 4 tab (Beranda, Kuis, Skor, Profil) ditampilkan lewat
  `IndexedStack` dan dipilih dari `AppBottomNav`.
- Tab Kuis menampilkan `QuizListPage`. Kartu kategori di Beranda maupun tab Kuis
  memanggil `QuizProvider.startCategory()` dengan nama pengguna aktif, lalu
  membuka `QuizPage` lewat `Navigator.push` sebagai layar penuh tanpa bottom
  navigation. Tombol back kembali ke tab asal.
- `QuizPage` → `ResultPage` dengan `pushReplacement`, sehingga back dari hasil
  tidak membuka kuis yang sudah selesai.
- `ResultPage` menyimpan hasil sekali ke `QuizProvider` setelah frame pertama.
  Tombol Coba Lagi memanggil `resetQuiz()` lalu mengganti halaman dengan
  `QuizPage` kategori yang sama; riwayat tetap tersimpan.
- Tab Skor menampilkan `lastScore` dan sisa `history` (terbaru di atas), dengan
  filter kategori.
- Tab Profil menampilkan nama, email, NIM, program studi, ringkasan statistik,
  badge presentasional, dan info aplikasi. Halaman Pengaturan dibuka lewat
  `Navigator.push`. Tombol Keluar memanggil `AuthProvider.logout()`, lalu
  membuka `LoginPage` dengan `pushAndRemoveUntil` agar `MainShell` tidak
  tersisa di tumpukan navigasi dan tombol back tidak membuka sesi lama.

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
  double get iconSize => w * 0.06;
}
```
Beri `clamp` pada ukuran font agar wajar di tablet dan landscape.

Pengujian layout mencakup ukuran 320×568, 360×800, 800×360, 768×1024,
dan 1024×768. `test/widget_test.dart` juga merotasi layar saat form Login sedang
diisi, saat berpindah tab di `MainShell`, dan di tengah kuis. Pengujian ini
memastikan `AuthProvider`, `QuizProvider`, indeks tab, soal aktif, serta
jawaban tetap tersimpan. `test/result_page_test.dart` memastikan rotasi di
halaman hasil tidak menggandakan riwayat.
