import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Bottom navigation 4 tab dengan item aktif berwarna aksen.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.quiz_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];

  static const List<String> _labels = ['Beranda', 'Kuis', 'Skor', 'Profil'];

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.border,
                width: responsive.shortestSide * 0.003,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.pagePadding * 0.25,
              vertical: responsive.smallGap * 0.35,
            ),
            child: Row(
              children: List.generate(_icons.length, (index) {
                final selected = index == currentIndex;

                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: _labels[index],
                    child: InkWell(
                      onTap: () => onTap(index),
                      borderRadius: BorderRadius.circular(responsive.radius),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.smallGap * 0.35,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.pagePadding * 0.28,
                                vertical: responsive.smallGap * 0.35,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.accent.withValues(alpha: 0.14)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  responsive.radius * 0.75,
                                ),
                              ),
                              child: Icon(
                                _icons[index],
                                size: responsive.iconSize * 0.92,
                                color: selected
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: responsive.smallGap * 0.3),
                            Text(
                              _labels[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: responsive.bodySize * 0.68,
                                fontWeight: selected
                                    ? FontWeight.w400
                                    : FontWeight.w300,
                                color: selected
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
