import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Emblem KAGE berbentuk lingkaran dengan cadangan ikon bila aset gagal.
class KageLogo extends StatelessWidget {
  const KageLogo({super.key, this.scale = 1});

  /// Rasio terhadap ukuran logo hero. Nilai 1 = ukuran penuh.
  final double scale;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = responsive.heroIconSize * scale;

    return Semantics(
      label: 'Logo KAGE',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Image.asset(
            AppAssets.mark,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return ColoredBox(
                color: AppColors.charcoal,
                child: Icon(
                  Icons.filter_vintage_rounded,
                  size: size * 0.5,
                  color: AppColors.antiqueGold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
