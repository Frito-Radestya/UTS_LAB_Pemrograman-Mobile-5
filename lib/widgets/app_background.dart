import 'package:flutter/material.dart';

/// Latar gambar kuil dengan overlay gelap agar teks tetap terbaca.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/bg_temple.jpg', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xA60D0D0D), Color(0xE60D0D0D)],
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
