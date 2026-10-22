import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Helper ukuran responsif.
///
/// Semua ukuran dihitung dari ukuran layar (bukan angka tetap) supaya
/// tampilan tetap wajar di portrait, landscape, dan tablet.
class Responsive {
  const Responsive(this.context);

  final BuildContext context;

  double get w => MediaQuery.sizeOf(context).width;
  double get h => MediaQuery.sizeOf(context).height;

  /// Sisi terpendek layar, dipakai untuk batas ukuran agar tidak berlebihan.
  double get shortestSide => math.min(w, h);

  bool get isLandscape => w > h;

  /// Heading: 46 / 400 dari lebar layar, dibatasi tinggi layar.
  double get headingSize => (w * 0.115).clamp(h * 0.07, h * 0.12);

  /// Body: 17 / 400 dari lebar layar, dibatasi tinggi layar.
  double get bodySize => (w * 0.0425).clamp(h * 0.026, h * 0.05);

  double get letterSpacing => headingSize * -0.012;

  double get pagePadding => w * 0.06;
  double get gap => h * 0.02;
  double get smallGap => h * 0.01;

  /// Tinggi tombol utama; di landscape tetap cukup besar untuk disentuh.
  double get buttonHeight =>
      (h * 0.07).clamp(shortestSide * 0.115, shortestSide * 0.16);

  /// Radius sudut dari lebar layar, dibatasi agar proporsional.
  double get radius => (w * 0.03).clamp(shortestSide * 0.02, shortestSide * 0.05);

  /// Lebar konten maksimum supaya tidak melebar di landscape/tablet.
  double get contentWidth => isLandscape ? w * 0.68 : w;

  /// Ukuran ikon/logo yang mengikuti sisi terpendek layar.
  double get heroIconSize => shortestSide * 0.32;
}
