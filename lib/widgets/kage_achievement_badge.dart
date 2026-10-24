import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Emblem hasil kuis yang bersifat presentasional berdasarkan skor aktual.
class KageAchievementBadge extends StatelessWidget {
  const KageAchievementBadge({
    super.key,
    required this.percentage,
    required this.isFirstAttempt,
  });

  final double percentage;
  final bool isFirstAttempt;

  String get _asset {
    if (percentage >= 100) {
      return AppAssets.badgePerfect;
    }
    if (percentage >= 80) {
      return AppAssets.badgeMaster;
    }
    if (isFirstAttempt) {
      return AppAssets.badgeFirst;
    }
    return AppAssets.ornament;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size =
        responsive.shortestSide * (responsive.isLandscape ? 0.16 : 0.28);

    return Center(
      child: ClipOval(
        child: Image.asset(
          _asset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.emoji_events_outlined,
              size: size * 0.7,
              color: AppColors.antiqueGold,
            );
          },
        ),
      ),
    );
  }
}
