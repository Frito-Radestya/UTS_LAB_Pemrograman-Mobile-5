import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'kage_logo.dart';

/// Identitas KAGE: emblem, wordmark, dan tagline.
///
/// Dipakai ulang di splash, login, dan register agar tampilan pembuka
/// konsisten tanpa menduplikasi susunan teks.
class KageBrand extends StatelessWidget {
  const KageBrand({
    super.key,
    this.logoScale = 1,
    this.wordmarkScale = 1,
    this.showTagline = true,
  });

  final double logoScale;
  final double wordmarkScale;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final wordmarkSize = responsive.headingSize * 1.05 * wordmarkScale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KageLogo(scale: logoScale),
        SizedBox(height: responsive.smallGap * 0.9),
        Text(
          'KAGE',
          style: TextStyle(
            fontSize: wordmarkSize,
            height: 1,
            fontWeight: AppTypography.hero,
            letterSpacing: wordmarkSize * 0.055,
            color: AppColors.ivory,
          ),
        ),
        if (showTagline) ...[
          SizedBox(height: responsive.smallGap * 0.45),
          Text(
            'THE QUIZ SANCTUARY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.bodySize * 0.52,
              fontWeight: AppTypography.label,
              letterSpacing: responsive.bodySize * 0.24,
              color: AppColors.antiqueGold,
            ),
          ),
          SizedBox(height: responsive.smallGap * 0.7),
          Container(
            width: responsive.shortestSide * 0.18,
            height: responsive.bodySize * 0.07,
            decoration: BoxDecoration(
              color: AppColors.antiqueGold.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(responsive.bodySize),
            ),
          ),
        ],
      ],
    );
  }
}
