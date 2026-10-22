# AGENTS.md — Aturan Kerja untuk Agent AI

Baca file ini terlebih dahulu pada setiap sesi, lalu baca `PRD.md`, `DESIGN.md`, `docs/ARCHITECTURE.md`, dan `TASKS.md`.

## Konteks
Project UTS Lab Pemrograman Mobile: aplikasi kuis pilihan ganda dengan Flutter. Pemilik project adalah mahasiswa yang harus memahami dan menjelaskan seluruh kode, jadi kode harus sederhana dan mudah dibaca.

## Aturan Teknis (wajib)
1. **Flutter native saja.** Dilarang memakai WebView, Three.js, atau library 3D.
2. **Tanpa ukuran hardcode.** Semua ukuran (font, padding, tinggi, lebar, radius) memakai `MediaQuery`, `LayoutBuilder`, `Expanded`, `Flexible`, atau `FractionallySizedBox`. Pengecualian hanya untuk nilai 0 dan rasio (misal `0.06`).
3. **Reusable widget** yang dipakai berulang wajib berada di `lib/widgets/`, **satu widget per file**.
4. **Stateless vs Stateful**: gunakan `StatelessWidget` untuk tampilan statis dan `StatefulWidget` hanya bila memang butuh state lokal (misal TextEditingController, animasi).
5. **State management: Provider.** State kuis (nama, indeks soal, jawaban, skor) disimpan di provider pada level root aplikasi supaya tidak hilang saat rotasi atau pindah halaman.
6. **Font kustom Onest** lewat `pubspec.yaml`. Dilarang memakai paket `google_fonts`.
7. **Tanpa database, API, atau penyimpanan permanen.** Data soal dummy di `lib/data/`.
8. **Navigasi** dengan `Navigator` dan transisi fade sesuai `DESIGN.md`.
9. Tambahkan dependency baru hanya bila benar-benar perlu (hanya `provider` yang disetujui).

## Aturan Kerja
1. Kerjakan **satu task per sesi** sesuai urutan di `TASKS.md`. Jangan mengerjakan task lain.
2. Setelah selesai: jalankan `flutter analyze` dan pastikan tidak ada error.
3. Tandai task selesai di `TASKS.md` (`[x]`), lalu **berhenti** dan tampilkan pesan commit yang disarankan. **Jangan menjalankan `git commit` atau `git push` sendiri** kecuali diminta.
4. Beri komentar singkat berbahasa Indonesia pada logika penting (state, perhitungan skor, navigasi).
5. Gunakan nama file `snake_case.dart`, nama class `PascalCase`, nama variabel `camelCase`.
6. Jangan mengubah file di luar cakupan task. Jangan menghapus `PRD.md`, `DESIGN.md`, atau `AGENTS.md`.
7. Bila ada nilai pada `DESIGN.md` bertanda *(asumsi)*, pakai nilai tersebut dan beri tahu pemilik bahwa nilainya perlu diverifikasi.
8. Bila ada keputusan yang tidak tercakup dokumen, pilih opsi paling sederhana dan jelaskan singkat. Jangan menambah fitur di luar `PRD.md`.

## Definisi Selesai (setiap task)
- [ ] `flutter analyze` bersih
- [ ] Aplikasi berjalan tanpa error
- [ ] Tidak ada ukuran hardcode baru
- [ ] Widget reusable berada di file terpisah
- [ ] Checklist `TASKS.md` diperbarui
- [ ] Pesan commit disarankan
