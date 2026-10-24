# DESIGN.md — Panduan Visual

Identitas: **KAGE — The Quiz Sanctuary**. Suasana kuil Jepang malam hari, torii vermilion, bulan, kabut, dan sakura. Yang diadopsi adalah bahasa visual, bukan salinan layout atau aset pihak ketiga.

Font: Onest (Regular 400, Medium 500, SemiBold 600, Bold 700) di `assets/fonts/`. Light 300 lama tidak dipakai dan tidak dibundel. Tidak memakai `google_fonts`.

## 1. Palet Warna

| Peran | Hex | Status |
|---|---|---|
| Midnight (latar) | `#0B0D12` | Token KAGE |
| Charcoal | `#171A22` | Token KAGE |
| Surface (kartu) | `#20242D` | Token KAGE |
| Elevated | `#272C36` | Token KAGE |
| Vermilion (tombol, progres) | `#B9232C` | Token KAGE |
| Vermilion Light | `#E1484D` | Token KAGE |
| Antique Gold | `#C9A56A` | Token KAGE |
| Ivory (teks utama) | `#E8E4DD` | Token KAGE |
| Muted (teks sekunder) | `#9297A2` | Token KAGE |
| Success | `#53B889` | Token KAGE |
| Error | `#E15A62` | Token KAGE |
| Border | `#343944` | Token KAGE |

Vermilion dipakai hemat: tombol utama, progress, opsi terpilih. Emas hanya untuk badge dan aksen kecil.

## 2. Tipografi

- Hero/wordmark: Onest 700, `headingSize` dari `responsive.dart`
- Judul halaman/section: Onest 600, `headingSize`
- Judul card: Onest 600, `bodySize`
- Teks soal/isi: Onest 400, `bodySize`
- Label/metadata: Onest 500, `bodySize`
- Tombol: Onest 600, `buttonHeight`
- Letter spacing heading: `headingSize * -0.012`
- Bobot terpusat di `AppTypography` dan `ThemeData` (`lib/theme/app_theme.dart`).

## 3. Spacing

- Padding halaman: `w * 0.06`
- Jarak: `h * 0.02`
- Tinggi tombol: `buttonHeight` (dinamis)
- Radius: `radius` (dinamis)
- Konten landscape dibatasi `contentWidth`
- Halaman panjang dibungkus `SingleChildScrollView`

## 4. Komponen

Lihat `lib/widgets/`. Latar memakai overlay gelap di atas ilustrasi lokal.

## 5. Animasi

- Transisi halaman: fade 300 ms
- Ganti soal: `AnimatedSwitcher` 300 ms
- Progress bar: 300 ms
- Angka skor: hitung naik

## 6. Aset

Katalog lengkap: `docs/ASSET_CATALOG.md`.
