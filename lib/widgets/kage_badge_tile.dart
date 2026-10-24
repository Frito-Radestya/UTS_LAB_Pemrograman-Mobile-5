import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu satu pencapaian dengan status terbuka atau terkunci.
class KageBadgeTile extends StatelessWidget {
  const KageBadgeTile({
    super.key,
    required this.title,
    required this.description,
    required this.asset,
    required this.unlocked,
  });

  final String title;
  final String description;
  final String asset;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final badgeSize = responsive.shortestSide * 0.18;

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.35),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: unlocked
              ? AppColors.antiqueGold.withValues(alpha: 0.5)
              : AppColors.border,
          width: responsive.shortestSide * 0.004,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: unlocked ? 1 : 0.32,
                child: ClipOval(
                  child: Image.asset(
                    asset,
                    width: badgeSize,
                    height: badgeSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: badgeSize,
                        height: badgeSize,
                        child: const ColoredBox(
                          color: AppColors.charcoal,
                          child: Icon(
                            Icons.emoji_events_outlined,
                            color: AppColors.antiqueGold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (!unlocked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(responsive.smallGap * 0.2),
                    decoration: const BoxDecoration(
                      color: AppColors.midnight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: responsive.bodySize * 0.75,
                      color: AppColors.muted,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: responsive.smallGap * 0.55),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: responsive.bodySize * 0.78,
              fontWeight: AppTypography.title,
              color: unlocked ? AppColors.ivory : AppColors.muted,
            ),
          ),
          SizedBox(height: responsive.smallGap * 0.2),
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: responsive.bodySize * 0.62,
              height: 1.3,
              fontWeight: AppTypography.body,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
