# ASSET_CATALOG.md

Semua aset visual bersifat lokal. Tidak ada unduhan gambar saat aplikasi berjalan.

| File | Tujuan | Format | Sumber | Lisensi | Status |
|---|---|---|---|---|---|
| `assets/fonts/Onest-Regular.ttf` | Teks soal, isi, deskripsi (400) | TTF | Onest / Google Fonts | SIL OFL 1.1 | Selesai |
| `assets/fonts/Onest-Medium.ttf` | Label dan metadata (500) | TTF | Onest / Google Fonts | SIL OFL 1.1 | Selesai |
| `assets/fonts/Onest-SemiBold.ttf` | Judul halaman/card dan tombol (600) | TTF | Onest / Google Fonts | SIL OFL 1.1 | Selesai |
| `assets/fonts/Onest-Bold.ttf` | Hero dan wordmark (700) | TTF | Onest / Google Fonts | SIL OFL 1.1 | Selesai |
| `assets/fonts/Onest-Light.ttf` | Weight 300 lama | TTF | Onest / Google Fonts | SIL OFL 1.1 | Arsip, tidak dipakai/tidak dibundel |
| `assets/images/backgrounds/kage_splash.jpg` | Latar splash | JPG | Ilustrasi orisinal sesi redesign | Internal project | Selesai |
| `assets/images/backgrounds/kage_auth.jpg` | Latar login/register | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/backgrounds/kage_home.jpg` | Latar beranda dan hero | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/backgrounds/kage_quiz.jpg` | Latar halaman kuis | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/backgrounds/kage_result.jpg` | Latar hasil | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/categories/*.jpg` | Ilustrasi 7 kategori | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/badges/*.jpg` | Emblem hasil (presentasional) | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/decorations/gold_ornament.jpg` | Ornamen cadangan | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/icons/kage_mark.jpg` | Logo KAGE | JPG | Ilustrasi orisinal | Internal project | Selesai |
| `assets/images/logo.png` | Aset lama | PNG | Aset lama proyek | Internal project | Arsip, tidak dipakai/tidak dibundel |
| `assets/images/trophy.png` | Aset lama | PNG | Aset lama proyek | Internal project | Arsip, tidak dipakai/tidak dibundel |
| `assets/images/bg_temple.jpg` | Aset lama | JPG | Aset lama proyek | Internal project | Arsip, tidak dipakai/tidak dibundel |

Catatan: hanya subfolder `backgrounds`, `categories`, `decorations`, `badges`,
dan `icons` yang didaftarkan di `pubspec.yaml`. Aset lama di akar
`assets/images/` tetap disimpan sebagai arsip tetapi tidak ikut build. File JPG
tidak transparan; badge dan logo memakai `ClipOval`/`ClipRRect`. Onest Medium,
SemiBold, dan Bold dibundel untuk hierarki tipografi KAGE. Onest Light lama
tetap disimpan sebagai arsip dan tidak ikut build.
