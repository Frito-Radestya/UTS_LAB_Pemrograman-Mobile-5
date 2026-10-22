# DESIGN.md — Panduan Visual

Referensi gaya: Kage Landing Page (ThreeUI). Yang diadopsi hanya **bahasa visualnya** (warna, font, suasana), bukan salinan layout atau aset.

> **Catatan**: Warna aksen, font, berat font, ukuran, dan letter spacing berasal dari data teknis komponen. Nilai yang bertanda *(asumsi)* belum diverifikasi dan harus disesuaikan setelah screenshot referensi tersedia di `assets/references/`.

## 1. Suasana
Gelap, tenang, dramatis, nuansa kuil Jepang, dengan satu aksen merah vermilion. Minimalis, banyak ruang kosong, tipografi bersih.

## 2. Palet Warna
| Peran | Hex | Status |
|---|---|---|
| Aksen utama (tombol, progress, highlight) | `#E0231C` | Dari referensi |
| Latar utama | `#0D0D0D` | *(asumsi)* |
| Permukaan kartu | `#1A1A1A` | *(asumsi)* |
| Border tipis | `#2E2E2E` | *(asumsi)* |
| Teks utama | `#F5F2EC` | *(asumsi)* |
| Teks sekunder | `#A8A39A` | *(asumsi)* |
| Benar (hasil) | `#4CAF50` | *(asumsi)* |

Aksen merah dipakai hemat: tombol utama, progress bar, opsi terpilih, dan angka skor.

## 3. Tipografi
- **Font**: Onest (file `.ttf` di-bundle di `assets/fonts/`, family `Onest`)
- **Heading**: weight 400
- **Body**: weight 300
- **Rumus ukuran (tanpa hardcode)**, dengan `w = MediaQuery.of(context).size.width`:

| Elemen | Ukuran | Dasar |
|---|---|---|
| Heading | `w * 0.115` | 46 ÷ 400 |
| Body | `w * 0.0425` | 17 ÷ 400 |
| Letter spacing heading | `headingSize * -0.012` | dari referensi |

Disarankan membuat helper (misal `lib/utils/responsive.dart`) agar rumus ini satu tempat. Beri batas (`clamp`) supaya tidak terlalu besar di tablet atau landscape.

## 4. Spacing dan Ukuran Dinamis
- Padding halaman: `w * 0.06`
- Jarak antar-elemen: `h * 0.02`
- Tinggi tombol: `h * 0.07`
- Radius sudut: `w * 0.03`
- Lebar konten di landscape dibatasi (`ConstrainedBox` atau `FractionallySizedBox`) agar tidak melebar berlebihan.
- Halaman yang bisa lebih panjang dari layar dibungkus `SingleChildScrollView` supaya aman saat rotasi.

## 5. Komponen
| Komponen | Gaya |
|---|---|
| Tombol utama | Isi `#E0231C`, teks putih, radius dinamis; nonaktif = abu gelap |
| Tombol opsi jawaban | Latar kartu, border tipis; terpilih = border dan huruf opsi berwarna aksen |
| Kartu pertanyaan | Latar permukaan, border tipis, padding dinamis |
| Progress bar | Track `#2E2E2E`, isi `#E0231C` |
| Input nama | Latar permukaan, border tipis; fokus = border aksen |

## 6. Animasi
- Transisi antar-halaman: fade (`PageRouteBuilder` + `FadeTransition`)
- Pergantian soal: `AnimatedSwitcher` (fade, ±300 ms)
- Progress bar: `AnimatedContainer` atau `TweenAnimationBuilder`
- Angka skor di Halaman Hasil: animasi hitung naik (opsional)
- Tidak ada animasi berlebihan; semua halus dan singkat.

## 7. Aset (akan disiapkan manual)
| File | Fungsi |
|---|---|
| `assets/images/bg_temple.jpg` | Latar gelap bertema kuil/torii (diberi overlay gelap agar teks terbaca) |
| `assets/images/logo.png` | Logo/ikon aplikasi di Halaman Nama |
| `assets/images/trophy.png` | Ikon di Halaman Hasil |
| `assets/fonts/Onest-Light.ttf` | Font body (300) |
| `assets/fonts/Onest-Regular.ttf` | Font heading (400) |

Semua aset harus berlisensi bebas pakai. Catat sumbernya di `docs/CREDITS.md`.
