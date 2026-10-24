# DESIGN.md — KAGE: The Quiz Sanctuary

Art direction untuk aplikasi kuis Flutter. Bahasa visual: kuil Jepang malam hari, torii vermilion, bulan, kabut, dan sakura. Bukan salinan layout atau aset pihak ketiga.

Tipografi memakai Onest lokal dengan empat bobot: Regular 400, Medium 500, SemiBold 600, dan Bold 700. Bobot Light 300 lama tidak dipakai dan tidak dibundel. Semua bobot didefinisikan terpusat lewat `AppTypography` dan `ThemeData`, bukan diatur per halaman.

## Palet

| Token | Hex | Pemakaian |
|---|---|---|
| Midnight | `#0B0D12` | Latar utama |
| Charcoal | `#171A22` | Panel sekunder |
| Surface | `#20242D` | Kartu |
| Elevated | `#272C36` | Permukaan terangkat |
| Vermilion | `#B9232C` | Tombol utama, progres |
| Vermilion Light | `#E1484D` | Highlight teks aksen |
| Antique Gold | `#C9A56A` | Ornamen dan badge |
| Ivory | `#E8E4DD` | Teks utama |
| Muted | `#9297A2` | Teks sekunder |
| Success | `#53B889` | Umpan balik positif |
| Error | `#E15A62` | Validasi dan error |
| Border | `#343944` | Garis tepi tipis |

## Tipografi dan spacing

Semua ukuran dihitung dari `MediaQuery` lewat `lib/utils/responsive.dart`. Tidak ada ukuran hardcode selain 0 dan rasio. Ukuran px di bawah adalah acuan desain, bukan nilai yang ditulis di kode.

| Bagian | Weight | Acuan ukuran |
|---|---|---|
| Judul hero | Bold 700 | 28–36 px |
| Judul halaman | SemiBold 600 | 22–28 px |
| Judul card | SemiBold 600 | 16–18 px |
| Teks soal | Regular 400 | 16–18 px |
| Isi dan deskripsi | Regular 400 | 14–16 px |
| Label dan metadata | Medium 500 | 12–14 px |
| Tombol | SemiBold 600 | 14–16 px |

- Display/heading: `headingSize`
- Body: `bodySize`
- Padding halaman: `w * 0.06`
- Tinggi tombol: `buttonHeight`
- Radius: `radius`

## Komponen

Widget reusable di `lib/widgets/`, satu file per widget. Token warna di `AppColors`. Transisi halaman fade 300 ms.

## Aksesibilitas

Kontras teks ivory di atas midnight. Overlay gelap pada ilustrasi. Tombol punya area sentuh dari tinggi dinamis. `errorBuilder` pada gambar.

## Animasi

Fade halaman 300 ms, fade logo splash, progress bar 300 ms, hitung skor 800 ms. Tidak ada animasi berulang yang berat.
