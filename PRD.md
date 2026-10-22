# PRD — Aplikasi Kuis Pilihan Ganda (UTS Lab Pemrograman Mobile)

## 1. Ringkasan
- **Tipe tugas**: Take-home, individu
- **Tema**: Aplikasi Kuis Pilihan Ganda
- **Framework**: Flutter (Dart)
- **Deskripsi**: Pengguna memasukkan nama, menjawab serangkaian pertanyaan pilihan ganda, lalu melihat skor akhir atas nama tersebut.

## 2. Soal Asli (salinan)
> Buat aplikasi kuis pilihan ganda di mana pengguna dapat memasukkan nama, menjawab serangkaian pertanyaan dan melihat skor akhir dari nama pengguna tersebut.

### Kriteria wajib
1. Aplikasi harus menggunakan StatelessWidget dan StatefulWidget sesuai kebutuhan.
2. Aplikasi memiliki minimal 2 (dua) halaman dan menerapkan navigasi antar-halaman.
3. Komponen UI yang digunakan berulang harus dibuat sebagai widget terpisah dalam file berbeda (reusable widget).
4. Gunakan aset seperti gambar atau ikon untuk memperindah tampilan aplikasi.
5. Gunakan font kustom (bukan font bawaan Flutter) agar tampilan lebih menarik dan konsisten dengan desain.
6. Pastikan ukuran elemen UI bersifat dinamis, menyesuaikan ukuran layar perangkat mobile (tidak menggunakan nilai yang di-hardcode).
7. Terapkan state management sehingga progres jawaban pengguna tidak hilang ketika layar perangkat dirotasi atau berpindah antar-halaman.
8. Tidak perlu menggunakan database (data cukup bersifat lokal atau dummy).
9. Gunakan GitHub sebagai alat pelacak kemajuan proyek. Lakukan commit setiap kali menyelesaikan fitur tertentu, bukan hanya mengunggah proyek di akhir.

## 3. Alur Halaman
```
[Halaman Nama] --> [Halaman Kuis] --> [Halaman Hasil]
      ^                                     |
      |_____________ Main Lagi _____________|
```

### 3.1 Halaman Nama (WelcomePage)
- Logo/ikon dan judul aplikasi
- Input nama (TextField) dengan validasi: tidak boleh kosong
- Tombol "Mulai Kuis" menuju Halaman Kuis

### 3.2 Halaman Kuis (QuizPage)
- Menampilkan nama pengguna
- Indikator progres ("Soal 3 dari 10") dan progress bar
- Kartu pertanyaan
- 4 opsi jawaban (A–D); opsi terpilih diberi highlight
- Tombol "Lanjut" (nonaktif sebelum memilih), berubah jadi "Selesai" di soal terakhir
- Jawaban yang sudah dipilih tetap tersimpan saat layar dirotasi

### 3.3 Halaman Hasil (ResultPage)
- Menampilkan nama dan skor akhir (benar dari total, plus persentase)
- Pesan sesuai skor (misal: ≥80 "Luar biasa", 50–79 "Bagus", <50 "Ayo coba lagi")
- Tombol "Main Lagi" (reset progres dan kembali ke Halaman Nama)

## 4. Fitur
| ID | Fitur | Prioritas |
|---|---|---|
| F1 | Input nama dengan validasi | Wajib |
| F2 | Daftar 10 soal dummy lokal | Wajib |
| F3 | Pilih jawaban + simpan di state | Wajib |
| F4 | Progres soal dan progress bar | Wajib |
| F5 | Hitung skor akhir | Wajib |
| F6 | Navigasi antar-halaman dengan transisi fade | Wajib |
| F7 | Progres tetap aman saat rotasi | Wajib |
| F8 | Reset dan main lagi | Wajib |
| F9 | Layout landscape yang rapi | Wajib |

## 5. Persyaratan Non-Fungsional
- Semua ukuran (font, padding, tinggi/lebar) dihitung dari `MediaQuery`/`LayoutBuilder`, tanpa angka tetap.
- Tampilan dan gaya mengikuti `DESIGN.md`.
- Struktur kode mengikuti `docs/ARCHITECTURE.md`.
- Data soal mengikuti `docs/QUESTIONS.md`.

## 6. Di Luar Cakupan
- Database, backend, login, atau API
- WebView atau Three.js
- Penyimpanan permanen setelah aplikasi ditutup
