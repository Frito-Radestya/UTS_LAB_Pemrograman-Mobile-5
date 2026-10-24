# KAGE — The Quiz Sanctuary

Aplikasi kuis pilihan ganda berbasis Flutter untuk UTS Lab Pemrograman Mobile.
Pengguna membuat akun atau login, memilih kategori, menjawab soal, lalu
melihat skor dan riwayat percobaan. Tampilan memakai tema gelap sinematik
KAGE dengan aksen vermilion, emas terbatas, dan font Onest.

## Fitur

- Login dengan email dan password, lengkap dengan validasi, pesan error, dan
  tombol tampilkan/sembunyikan password.
- Registrasi akun dengan nama, NIM, email, program studi, password, dan
  konfirmasi password.
- Akun dummy dan akun hasil registrasi disimpan di memori selama aplikasi
  berjalan, tanpa database atau API.
- `MainShell` dengan 4 tab yang state-nya tetap hidup melalui `IndexedStack`:
  Beranda, Kuis, Skor, dan Profil.
- Tujuh kategori kuis (termasuk Flutter Dasar dan Dart), masing-masing berisi
  10 soal pilihan ganda (A–D). Beranda menampilkan kategori dalam daftar
  horizontal yang bisa digeser.
- Beranda menampilkan sapaan, progres kategori, kartu petualangan berikutnya,
  kategori, dan ringkasan statistik dari data sesi aktual.
- Halaman hasil menampilkan emblem, skor, jumlah benar/salah, dan akurasi.
- Profil menampilkan data akun, ringkasan statistik, koleksi badge
  presentasional, pengaturan, info aplikasi, dan tombol logout.
- Halaman Pengaturan berisi ringkasan akun, info versi, dan logout.
- Kuis dibuka sebagai layar penuh tanpa bottom navigation. Jawaban terpilih
  ditandai dan tombol **Lanjut** aktif setelah memilih.
- Indikator "Soal x dari 10", progress bar, dan animasi pergantian soal.
- Halaman hasil berisi jumlah benar, persentase, dan pesan sesuai skor.
- Riwayat skor tersimpan di `QuizProvider` selama aplikasi berjalan.
- State sesi dan kuis berada di Provider pada root aplikasi, sehingga aman saat
  rotasi atau pindah halaman.
- Layout responsif untuk portrait, landscape, layar kecil, dan tablet.
- Transisi fade antar-halaman.
- Dukungan Flutter Web dengan judul, manifest, favicon, dan ikon KAGE.

## Alur Aplikasi

```text
Splash
  └── Login <──> Register
        └── MainShell (Beranda | Kuis | Skor | Profil)
              └── QuizPage (layar penuh)
                    └── ResultPage
                          └── Coba Lagi -> QuizPage
```

- Login atau registrasi berhasil membuka `MainShell` dan membersihkan halaman
  auth dari tumpukan navigasi.
- Tombol back dari hasil tidak membuka kembali kuis yang sudah selesai.
- Logout menghapus sesi dan kembali ke Login dengan tumpukan navigasi yang
  bersih.

## Akun Demo

| Email | Password | Nama |
|---|---|---|
| `demo@mail.com` | `123456` | Demo Mahasiswa |
| `budi@mail.com` | `123456` | Budi Santoso |

Akun hasil registrasi juga dapat dipakai sampai aplikasi ditutup.

## Teknologi

- Flutter 3.47 / Dart 3.13
- [`provider`](https://pub.dev/packages/provider) untuk state management
- Font Onest lokal 400/500/600/700 (tanpa `google_fonts`)

## UI/UX KAGE

Bahasa visual KAGE terinspirasi kuil Jepang malam hari: latar Midnight,
permukaan Charcoal dan Surface, aksen vermilion untuk aksi utama, serta emas
untuk ornamen dan badge. Seluruh antarmuka memakai Onest dengan hierarki yang
konsisten:

| Peran | Weight |
|---|---|
| Judul hero | Bold 700 |
| Judul halaman dan kartu | SemiBold 600 |
| Teks soal dan isi | Regular 400 |
| Label dan metadata | Medium 500 |
| Tombol | SemiBold 600 |

Warna, tipografi, dan aset didefinisikan terpusat di
`lib/theme/app_theme.dart`. Komponen visual seperti brand, kartu kategori,
kartu statistik, dan badge berada di `lib/widgets/` agar konsisten dan dapat
dipakai ulang. Panduan lengkap ada di [`docs/DESIGN.md`](docs/DESIGN.md).

## Struktur Singkat

```text
lib/
├── main.dart                 # root aplikasi + MultiProvider
├── data/
│   ├── dummy_users.dart      # akun demo
│   └── questions_data.dart   # kategori × 10 soal
├── models/                   # User, Category, Question, ScoreRecord
├── pages/                    # Splash, Login, Register, MainShell, Beranda,
│                             # Kuis, Quiz, Result, Skor, Profil, Pengaturan
├── providers/                # AuthProvider dan QuizProvider
├── theme/app_theme.dart      # token warna, aset, dan tema KAGE
├── utils/                    # responsive helper + route fade
└── widgets/                  # widget reusable, termasuk komponen brand KAGE

web/                          # entry point Flutter Web (Chrome)
```

## Menjalankan

Pastikan Flutter sudah terpasang, lalu:

```bash
flutter pub get
flutter run
```

Untuk menjalankan di Chrome:

```bash
flutter run -d chrome
```

Untuk memilih perangkat tertentu:

```bash
flutter devices
flutter run -d <device-id>
```

## Pengujian

```bash
flutter analyze
flutter test
```

Pengujian mencakup validasi auth, alur login/register, navigasi, penyimpanan
skor, logout, serta layout pada ukuran layar kecil, portrait, landscape, dan
tablet.

## Screenshot

Tangkapan layar berikut menggunakan tema KAGE dan tipografi Onest terbaru.

| Login | Beranda | Kuis |
|---|---|---|
| ![Halaman login](docs/screenshots/login.png) | ![Halaman beranda](docs/screenshots/home.png) | ![Halaman kuis](docs/screenshots/quiz.png) |

| Hasil | Skor | Profil |
|---|---|---|
| ![Halaman hasil](docs/screenshots/result.png) | ![Halaman skor](docs/screenshots/score.png) | ![Halaman profil](docs/screenshots/profile.png) |

## Catatan

- Data soal ada di `lib/data/questions_data.dart` sesuai `docs/QUESTIONS.md`.
- Semua data akun dan skor hanya tersimpan selama aplikasi berjalan. Tidak ada
  database, API, atau penyimpanan permanen.
- Panduan visual ada di `DESIGN.md` dan `docs/DESIGN.md`.
- Katalog aset: `docs/ASSET_CATALOG.md`.
- Kredit font dan aset ada di [docs/CREDITS.md](docs/CREDITS.md).
- Ringkasan implementasi dan verifikasi ada di
  [docs/IMPLEMENTATION_REPORT.md](docs/IMPLEMENTATION_REPORT.md).
