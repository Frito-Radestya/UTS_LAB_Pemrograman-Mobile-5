<div align="center">

<img src="assets/svg/logo_emblem.svg" width="96" alt="Logo KAGE">

# KAGE

### The Quiz Sanctuary

Aplikasi kuis pilihan ganda bertema kuil Jepang malam hari, dibangun dengan Flutter
untuk UTS Lab Pemrograman Mobile.

[![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4A4F5E)](#menjalankan-aplikasi)

</div>

---

## Tentang Proyek

**KAGE — The Quiz Sanctuary** adalah aplikasi kuis yang mengajak pengguna belajar
melalui perjalanan visual bernuansa kuil Jepang: gerbang torii, lentera, bulan,
kelopak sakura, dan langit malam. Aplikasi memiliki alur lengkap mulai dari
splash screen, login/registrasi, pemilihan kategori, pengerjaan kuis, pembahasan
jawaban, hingga hasil dan riwayat skor.

Seluruh data masih bersifat **lokal/dummy di dalam memori** — tidak ada backend,
database, atau penyimpanan permanen. Cocok digunakan sebagai proyek pembelajaran
Flutter dan demonstrasi UI/UX.

## Fitur Utama

- **Splash screen sinematik** dengan animasi lentera, kelopak sakura, dan progress bar.
- **Login & registrasi** dengan validasi form, pesan error, dan toggle password.
- **Beranda personal** berisi sapaan, progres belajar, kartu lanjutkan petualangan,
  statistik, kategori, dan kutipan.
- **5 kategori kuis**: Sains, Teknologi, Sejarah, Logika, dan Pengetahuan Umum.
- **50 soal pilihan ganda** (10 soal per kategori) dengan pembahasan dan fakta menarik.
- **Pemilihan tingkat kesulitan**: Pemula, Menengah, dan Ahli.
- **Penyimpanan progres kuis** ke Beranda, termasuk konfirmasi saat keluar di tengah kuis.
- **Halaman hasil** dengan animasi skor, jumlah benar, akurasi, dan durasi.
- **Riwayat skor** dengan filter kategori dan ringkasan statistik.
- **Badge & pencapaian** yang dihitung dari riwayat kuis.
- **Profil pengguna** dengan level, XP, edit nama/email, dan pengaturan.
- **Bottom navigation** untuk Beranda, Kuis, Skor, dan Profil.
- **Transisi halaman halus** (fade + slide) di seluruh aplikasi.
- **Responsif** untuk ponsel, tablet, dan web; konten dibatasi 520 px di layar lebar.
- **Dukungan Flutter Web** dengan metadata, manifest, dan ikon KAGE.

## Tampilan Aplikasi

<div align="center">

<img src="docs/screenshots/login.png" width="200" alt="Halaman login KAGE">
<img src="docs/screenshots/beranda.png" width="200" alt="Halaman beranda KAGE">
<img src="docs/screenshots/kategori.png" width="200" alt="Halaman kategori KAGE">

<img src="docs/screenshots/kuis.png" width="200" alt="Halaman kuis KAGE">
<img src="docs/screenshots/hasil.png" width="200" alt="Halaman hasil kuis KAGE">
<img src="docs/screenshots/profil.png" width="200" alt="Halaman profil KAGE">

</div>

Tangkapan layar diambil dari build web pada viewport ponsel 390 × 844.

## Alur Aplikasi

```text
Splash
  └── Login ──> Register
        └── Beranda ──> Kategori ──> Detail Kategori
              │                          └── Kuis ──> Penjelasan
              │                                        └── Hasil
              ├── Riwayat (filter & statistik)
              ├── Profil ──> Badge
              │          └── Pengaturan
              └── Lanjutkan Petualangan ──> Kuis
```

## Teknologi

| Kebutuhan | Implementasi |
|---|---|
| Framework | Flutter 3.47 / Dart 3.13 |
| Navigasi | [`go_router`](https://pub.dev/packages/go_router) 18.x |
| State management | [`provider`](https://pub.dev/packages/provider) 6.x (`ChangeNotifier`) |
| Aset vektor | [`flutter_svg`](https://pub.dev/packages/flutter_svg) 2.x |
| Tipografi | Font lokal **Onest** & **Cinzel** (`assets/fonts/`) |
| Ikon | Material Icons + aset SVG khusus KAGE |

### Palet Warna

| Token | Warna | Penggunaan |
|---|---|---|
| Primary / Vermilion | `#B9232C` | Tombol utama, jawaban terpilih, progress bar |
| Background / Midnight | `#0B0D12` | Latar utama |
| Surface / Charcoal | `#171A22` | Kartu, input, panel |
| Gold / Antique Gold | `#C9A56A` | Aksen, badge, ornamen, level |
| Text / Ivory | `#E8E4DD` | Teks utama |
| Muted | `#8B909C` | Teks sekunder dan metadata |

Warna aksen kategori: Sains `#F0A25A`, Teknologi `#6EB6FF`, Sejarah `#E0B86A`,
Logika `#B79CFF`, dan Umum `#6FD0A0`.

## Struktur Proyek

```text
lib/
├── main.dart                  # Entry point + konfigurasi font
├── app.dart                   # MaterialApp.router, GoRouter, tema, responsive frame
├── data/
│   └── quiz_data.dart         # 5 kategori × 10 soal, pembahasan, fakta menarik
├── models/
│   └── models.dart            # CategoryId, Difficulty, Question, QuizResult, BadgeItem
├── state/
│   └── app_state.dart         # State global: auth, profil, progres kuis, riwayat, badge
├── pages/
│   ├── splash_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── beranda_page.dart
│   ├── kategori_page.dart
│   ├── detail_kategori_page.dart
│   ├── kuis_page.dart
│   ├── penjelasan_page.dart
│   ├── hasil_page.dart
│   ├── riwayat_page.dart
│   ├── profil_page.dart
│   ├── badge_page.dart
│   └── pengaturan_page.dart
├── theme/
│   ├── app_colors.dart        # Token warna
│   └── app_theme.dart         # Onest, Cinzel, ThemeData
└── widgets/
    └── kage_widgets.dart      # Widget reusable: wordmark, tombol, progress bar,
                               # bottom nav, score row, ilustrasi, dll.
```

Aset visual berada di `assets/svg/` dan font di `assets/fonts/`. Paket desain asli
(spesifikasi dan sumber HTML) disimpan di `kage_package/` sebagai referensi.
Tangkapan layar untuk dokumentasi berada di `docs/screenshots/`.

## Rute Aplikasi

| Rute | Halaman |
|---|---|
| `/` | Splash |
| `/login` | Login |
| `/register` | Registrasi |
| `/beranda` | Beranda |
| `/kategori` | Daftar kategori |
| `/kategori/:id` | Detail kategori |
| `/kuis` | Pengerjaan kuis |
| `/penjelasan` | Pembahasan jawaban |
| `/hasil` | Hasil kuis |
| `/riwayat` | Riwayat skor |
| `/profil` | Profil & statistik |
| `/badge` | Badge & pencapaian |
| `/pengaturan` | Pengaturan |

## Menjalankan Aplikasi

Pastikan Flutter sudah terpasang dan berada di channel stable.

```bash
flutter pub get
flutter run
```

Menjalankan di browser:

```bash
flutter run -d chrome
```

Melihat perangkat yang tersedia:

```bash
flutter devices
flutter run -d <device-id>
```

> Font Onest dan Cinzel dibundel langsung sebagai aset aplikasi, sehingga tampilan
> tetap konsisten dan tidak memerlukan koneksi internet saat dijalankan.

## Pengujian & Analisis

```bash
flutter analyze
flutter test
```

Build web untuk produksi:

```bash
flutter build web --release
```

## Akun & Data

Aplikasi menggunakan autentikasi simulasi: pengguna dapat masuk dengan email/
username dan password apa pun yang tidak kosong, atau membuat akun baru melalui
halaman registrasi. Nama dan email akan ditampilkan di Beranda dan Profil.

Seluruh data berikut hanya tersimpan selama sesi aplikasi berjalan:

- akun dan profil pengguna,
- progres kuis yang disimpan,
- riwayat skor,
- XP, level, dan badge.

Menutup atau me-restart aplikasi akan mengembalikan data ke kondisi awal.

## Status Pengembangan

- [x] Splash, login, dan registrasi
- [x] Beranda dan navigasi utama
- [x] Kategori, detail kategori, dan pemilihan kesulitan
- [x] Kuis 50 soal, pembahasan, dan hasil
- [x] Riwayat skor dan statistik
- [x] Profil, badge, dan pengaturan
- [x] Responsif untuk web/tablet
- [x] Branding ikon, splash native, dan metadata web
- [ ] Penyimpanan permanen (database/local storage)
- [ ] Integrasi backend dan akun nyata

## Kontribusi

Proyek ini dibuat untuk keperluan UTS Lab Pemrograman Mobile. Saran dan perbaikan
dapat disampaikan melalui issue atau pull request di repositori ini.

---

<div align="center">

**KAGE — The Quiz Sanctuary**

*"Pengetahuan adalah cahaya yang tak pernah padam."*

</div>
