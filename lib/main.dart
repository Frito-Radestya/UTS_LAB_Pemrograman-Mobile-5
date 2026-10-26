import 'package:flutter/material.dart';

import 'features/splash/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Data lokal (sesi login, riwayat, progres) dimuat setelah frame pertama
  // supaya pengguna melihat indikator memuat alih-alih layar diam (U-07).
  runApp(const KageBootstrap());
}
