# TASKS.md — Checklist Fitur dan Commit

Kerjakan **berurutan**, satu task per sesi. Setelah selesai: centang `[x]`, jalankan `flutter analyze`, lalu commit dengan pesan yang disarankan.

## Persiapan (dikerjakan manual oleh pemilik)
- [ ] `flutter create kuis_app` lalu `git init`
- [ ] Buat repository GitHub dan hubungkan remote
- [ ] Taruh dokumen: `PRD.md`, `DESIGN.md`, `AGENTS.md`, `TASKS.md`, `docs/`
- [ ] Siapkan `assets/fonts/`, `assets/images/`, `assets/references/`
- Commit: `docs: tambah PRD, DESIGN, AGENTS, dan TASKS`

## Task Pengembangan

### Task 1 — Setup project, aset, dan font
- [x] Tambah dependency `provider` di `pubspec.yaml`
- [x] Daftarkan folder aset dan font Onest (Light 300, Regular 400)
- [x] Buat struktur folder `lib/pages`, `lib/widgets`, `lib/providers`, `lib/data`, `lib/models`, `lib/utils`
- [x] Buat `lib/utils/responsive.dart` (helper ukuran dari `MediaQuery`)
- [x] Buat `lib/theme/app_theme.dart` (warna dan font dari `DESIGN.md`)
- Commit: `chore: setup struktur folder, font Onest, aset, dan tema`

### Task 2 — Model dan data soal dummy
- [x] Buat `lib/models/question.dart`
- [x] Buat `lib/data/questions_data.dart` berisi 10 soal dari `docs/QUESTIONS.md`
- Commit: `feat: tambah model dan data soal dummy`

### Task 3 — State management (Provider)
- [x] Buat `lib/providers/quiz_provider.dart`: nama, indeks soal, daftar jawaban, hitung skor, reset
- [x] Pasang `ChangeNotifierProvider` di root `main.dart`
- Commit: `feat: tambah QuizProvider untuk state kuis`

### Task 4 — Reusable widget
- [x] `lib/widgets/primary_button.dart`
- [x] `lib/widgets/option_button.dart`
- [x] `lib/widgets/question_card.dart`
- [x] `lib/widgets/quiz_progress_bar.dart`
- [x] `lib/widgets/app_background.dart` (latar gambar dengan overlay gelap)
- Commit: `feat: tambah reusable widget (tombol, opsi, kartu soal, progress bar)`

### Task 5 — Halaman Nama (WelcomePage)
- [x] Logo, judul, input nama dengan validasi, tombol Mulai
- [x] Simpan nama ke provider
- Commit: `feat: halaman input nama`

### Task 6 — Halaman Kuis (QuizPage)
- [x] Tampilkan soal, opsi, progres, dan nama pengguna
- [x] Pilih jawaban tersimpan di provider; tombol Lanjut/Selesai
- [x] `AnimatedSwitcher` untuk pergantian soal
- Commit: `feat: halaman kuis dengan pilihan jawaban dan progres`

### Task 7 — Halaman Hasil (ResultPage)
- [x] Tampilkan nama, skor, persentase, dan pesan sesuai skor
- [x] Tombol Main Lagi (reset provider dan kembali ke Halaman Nama)
- Commit: `feat: halaman hasil skor akhir dan reset`

### Task 8 — Navigasi dan transisi
- [x] Navigasi Nama → Kuis → Hasil dengan transisi fade
- [x] Cegah tombol back membuka halaman yang tidak semestinya
- Commit: `feat: navigasi antar-halaman dengan transisi fade`

### Task 9 — Responsif dan rotasi
- [x] Uji portrait dan landscape di semua halaman
- [x] Pastikan progres dan jawaban tidak hilang saat rotasi
- [x] Tambahkan scroll bila konten melebihi layar
- [x] Periksa tidak ada ukuran hardcode tersisa
- Commit: `fix: layout responsif dan keamanan state saat rotasi`

### Task 10 — Polesan akhir
- [x] Sesuaikan warna dan spacing dengan screenshot referensi
- [x] Rapikan komentar dan hapus kode tak terpakai
- [x] Buat `README.md` (deskripsi, cara menjalankan, screenshot) dan `docs/CREDITS.md`
- Commit: `docs: tambah README, credits, dan polesan akhir`

## Revisi Aplikasi (Login, 4 Tab, Kategori, dan Riwayat)

- [x] Task 1 — Setup dependency, aset, font, struktur folder, `responsive.dart`, dan tema
- [x] Task 2 — Model `User`, `Category`, `ScoreRecord`, data 2 kategori × 10 soal, dan akun demo
- [x] Task 3 — `AuthProvider`, perluasan `QuizProvider`, dan pemasangan `MultiProvider`
- [x] Task 4 — Widget reusable: `AppTextField`, `CategoryCard`, `ScoreTile`, `AppBottomNav`
- [x] Task 5 — Halaman Splash, Login, dan Register dengan validasi
- [x] Task 6 — `MainShell`, bottom navigation 4 tab, dan halaman Beranda
- [x] Task 7 — Daftar kategori dan `QuizPage` berbasis kategori
- [x] Task 8 — `ResultPage` dan riwayat skor
- [ ] Task 9 — Profil, logout, dan perbaikan alur navigasi
- [ ] Task 10 — Pemeriksaan responsif dan rotasi untuk alur baru
- [ ] Task 11 — Polesan akhir dan pembaruan dokumentasi

## Pengujian Akhir (manual)
- [ ] Nama kosong tidak bisa lanjut
- [ ] Jawab semua soal, skor benar
- [ ] Rotasi di tengah kuis, progres tetap
- [ ] Pindah halaman dan kembali, progres tetap
- [ ] Main Lagi mereset semuanya
- [ ] Tampilan oke di layar kecil dan besar
