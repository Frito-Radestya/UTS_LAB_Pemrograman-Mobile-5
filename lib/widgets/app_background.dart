import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Latar ilustrasi KAGE dengan overlay gelap agar teks tetap terbaca.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.imageAsset = AppAssets.home,
  });

  final Widget child;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: AppColors.midnight),
        Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const ColoredBox(color: AppColors.midnight);
          },
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x990B0D12), Color(0xF20B0D12)],
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
