# BoltQuiz ⚡

Aplikasi kuis pilihan ganda Flutter/Dart berbahasa Indonesia dengan desain hitam–kuning mengikuti referensi BoltQuiz. Berjalan di Android, iOS, dan web.

## Menjalankan

Dari terminal pada folder `kuis`:

```sh
flutter pub get
flutter run
```

Untuk browser: `flutter run -d chrome`. Pilih emulator atau perangkat Android untuk menguji rotasi perangkat. Build APK: `flutter build apk --debug`. Build iOS memerlukan macOS dan Xcode.

Dibuat menggunakan Flutter 3.47.2 / Dart 3.13.2. Dependensi dan versinya dikunci di `pubspec.lock`.

## Fitur

- Form masuk dan daftar dengan validasi nama, email, sandi, konfirmasi, dan persetujuan penggunaan; mode tamu cukup memasukkan nama.
- Beranda dengan statistik nyata, kuis lanjutan, kategori populer, dan rekomendasi harian.
- Enam kategori / 48 soal: Flutter & Dart, algoritma, basis data, jaringan, matematika, dan web.
- Pencarian kategori dan filter tingkat kesulitan.
- Sesi kuis dengan pemilihan satu jawaban, nomor soal, penanda tinjauan, waktu berjalan, serta navigasi maju/mundur.
- Pengumpulan hanya setelah seluruh soal terjawab; jawaban benar tidak dibocorkan saat mengerjakan.
- Hasil menampilkan nama peserta, persentase benar, poin, waktu, dan pembahasan setiap soal. Setiap jawaban benar bernilai **100 poin**, tanpa penalti jawaban salah.
- Riwayat hasil, coba lagi, tema gelap/terang, dan opsi klik sistem ketika memilih jawaban (sesuai dukungan dan volume perangkat).
- Progres dan preferensi tersimpan otomatis secara lokal, termasuk saat berpindah halaman, rotasi, atau membuka ulang aplikasi.

## Pemetaan kriteria tugas

| Kriteria | Implementasi |
| --- | --- |
| StatelessWidget & StatefulWidget | `BoltQuizApp`, komponen bersama, formulir, shell tab, dan layar kuis |
| ≥2 halaman & navigasi | Masuk/daftar, beranda, kategori, profil, kuis, dan hasil; `Navigator`, named routes, `MaterialPageRoute` |
| Widget reusable dalam file terpisah | `lib/widgets/bolt_widgets.dart` dan `player_name_dialog.dart` |
| Aset gambar/ikon | Ilustrasi avatar lokal, ikon Material, dan ikon aplikasi BoltQuiz |
| Font kustom | Plus Jakarta Sans dan JetBrains Mono dibundel, tidak memerlukan unduhan saat runtime |
| Layout responsif | `LayoutBuilder`, `MediaQuery`, skala jarak, batas lebar konten, `Wrap`, dan area gulir; tidak mengunci orientasi |
| State management | `ChangeNotifier` + `InheritedNotifier` (`AppScope`), `IndexedStack`, dan `SharedPreferences` |

Ukuran kartu/grid menyesuaikan lebar tersedia dan ukuran teks. Konstanta desain seperti radius, ukuran ikon, dan lebar maksimum digunakan sebagai batas visual, bukan ukuran layar tetap.

## Struktur

```text
lib/
  main.dart                    # Bootstrap, tema, dan routes
  data/quiz_data.dart           # Bank soal lokal
  models/quiz_models.dart       # Model pertanyaan, kategori, hasil
  state/app_state.dart          # State reaktif + persistensi JSON
  state/app_scope.dart          # Dependency injection / InheritedNotifier
  theme/app_theme.dart          # Palet, tipografi, tema, jarak responsif
  widgets/                     # Komponen reusable
  screens/                     # Layar aplikasi
assets/
  fonts/                       # Font lokal + lisensi SIL Open Font License
  images/avatar.png            # Ilustrasi avatar orisinal
```

## Penyimpanan dan batasan

**Akun adalah demo lokal, bukan autentikasi produksi.** Kata sandi hanya divalidasi oleh formulir, tidak disimpan, tidak dicocokkan dengan akun terdaftar, dan tidak dikirim ke server. Jangan gunakan sandi asli. Mode tamu tersedia tanpa email/sandi. Google Sign-In dan pemulihan akun server sengaja tidak disimulasikan.

Nama, email, hasil, jawaban, nomor soal, tanda soal, waktu mulai, dan preferensi disimpan dalam `SharedPreferences`. Ini bukan penyimpanan terenkripsi dan bukan penyimpanan yang sesuai untuk rahasia. Keluar menghapus profil, progres, dan riwayat pada perangkat ini; dialog konfirmasi menjelaskan akibatnya. Mengganti kategori meminta konfirmasi jika ada kuis belum selesai. Hanya satu kuis aktif dalam satu waktu.

Waktu pengerjaan dihitung dari waktu mulai hingga dikumpulkan (termasuk waktu saat kuis ditinggalkan). Aplikasi tidak memberi batas waktu atau penalti waktu. Pengingat hanya berupa informasi dalam aplikasi, bukan notifikasi OS terjadwal. Tidak ada backend, leaderboard online, analitik, atau API key. Instalasi dependensi dan build web pertama dapat memerlukan internet; font, avatar, dan soal berasal dari aset lokal.

## Pengujian

```sh
flutter analyze
flutter test
flutter build web
```

Pengujian state mencakup pemulihan progres, penanda, penghitungan skor/nama, data rusak, restart, pengumpulan idempoten, serta isolasi akun. Widget test mencakup validasi formulir, navigasi, rotasi, layar kecil, tema terang, dan penyelesaian kuis.

Pada Windows dengan proyek dan Pub cache di drive berbeda, kompilasi inkremental Kotlin dinonaktifkan pada `android/gradle.properties` untuk menghindari kegagalan cache lintas drive. Ini hanya memengaruhi waktu build, bukan fungsi aplikasi.

Jika build Android terkendala SDK/lisensi, periksa `flutter doctor -v`, lalu jalankan `flutter doctor --android-licenses` secara interaktif. Aplikasi tidak memerlukan kunci layanan eksternal.
