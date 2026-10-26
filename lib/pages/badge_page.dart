import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/history_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/kage_widgets.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = context.watch<HistoryController>().badges;
    final earned = badges.where((b) => b.earned).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 280,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -1),
                  radius: 1.1,
                  colors: [Color(0x38C9A56A), Color(0x000B0D12)],
                  stops: [0, 0.7],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-12, 0),
                          child: const BackIconButton(
                            label: 'Kembali ke profil',
                          ),
                        ),
                        Text(
                          'Badge & Pencapaian',
                          style: AppTheme.onest(
                            size: 18,
                            heightPx: 26,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      children: [
                        // Collection card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderStrong),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Koleksi badge',
                                    style: AppTheme.onest(
                                      size: 14,
                                      heightPx: 20,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$earned dari ${badges.length}',
                                    style: AppTheme.onest(
                                      size: 14,
                                      heightPx: 20,
                                      weight: FontWeight.w600,
                                      color: AppColors.gold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              KageProgressBar(
                                value: earned / badges.length,
                                color: AppColors.gold,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Badge list
                        for (final b in badges) ...[
                          _badgeCard(b),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          'Small Steps, Greater Knowledge',
                          style: AppTheme.onest(
                            size: 13,
                            heightPx: 20,
                            color: AppColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeCard(BadgeItem badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: badge.earned ? AppColors.surface : const Color(0xFF13151B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.earned ? AppColors.border : AppColors.borderStrong,
        ),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: badge.earned ? 1.0 : 0.55,
            child: SvgPicture.asset(badge.asset, width: 64, height: 64),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: AppTheme.onest(
                    size: 16,
                    heightPx: 24,
                    weight: FontWeight.w600,
                    color: badge.earned ? AppColors.text : AppColors.textSoft,
                  ),
                ),
                Text(
                  badge.subtitle,
                  style: AppTheme.onest(
                    size: 13,
                    heightPx: 18,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (badge.earned)
            const Icon(Icons.check, color: AppColors.success)
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Text(
                'Terkunci',
                style: AppTheme.onest(
                  size: 12,
                  heightPx: 16,
                  color: AppColors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
