import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/quiz_data.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class KageWordmark extends StatelessWidget {
  const KageWordmark({
    super.key,
    this.size = 40,
    this.heightPx = 48,
    this.letterSpacing = 8,
    this.paddingLeft = 8,
  });

  final double size;
  final double heightPx;
  final double letterSpacing;
  final double paddingLeft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft),
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.goldLight, AppColors.gold],
        ).createShader(bounds),
        child: Text(
          'KAGE',
          style: AppTheme.cinzel(
            size: size,
            heightPx: heightPx,
            letterSpacing: letterSpacing,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SakuraPetal extends StatelessWidget {
  const SakuraPetal({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.angle,
    required this.opacity,
    this.color = const Color(0xFFE07A96),
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final double angle;
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: angle * math.pi / 180,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(width * 0.7, height * 0.7),
                bottomRight: Radius.elliptical(width * 0.7, height * 0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated version: falls, sways, and spins like a real falling petal ──────
class AnimatedSakuraPetal extends StatefulWidget {
  const AnimatedSakuraPetal({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.angle,
    required this.opacity,
    this.color = const Color(0xFFE07A96),
    this.fallDistance = 700,
    this.duration = const Duration(seconds: 5),
    this.delayFraction = 0.0, // 0.0‥1.0 — initial phase offset
    this.swayAmplitude = 18.0,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final double angle; // base rotation in degrees
  final double opacity;
  final Color color;
  final double fallDistance;
  final Duration duration;
  final double delayFraction;
  final double swayAmplitude;

  @override
  State<AnimatedSakuraPetal> createState() => _AnimatedSakuraPetalState();
}

class _AnimatedSakuraPetalState extends State<AnimatedSakuraPetal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..value = widget.delayFraction.clamp(0.0, 1.0)
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final dy = t * widget.fallDistance;
        final dx = math.sin(t * 2 * math.pi) * widget.swayAmplitude;
        final spin = t * 2 * math.pi; // full rotation over one fall cycle
        return Positioned(
          left: widget.left,
          top: widget.top,
          child: Opacity(
            opacity: widget.opacity * (1 - (t > 0.85 ? (t - 0.85) / 0.15 : 0)),
            child: Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.rotate(
                angle: widget.angle * math.pi / 180 + spin,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(
                        widget.width * 0.7,
                        widget.height * 0.7,
                      ),
                      bottomRight: Radius.elliptical(
                        widget.width * 0.7,
                        widget.height * 0.7,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MoonGlow extends StatelessWidget {
  const MoonGlow({super.key, required this.size, this.glow = 30});

  final double size;
  final double glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          colors: [Color(0xFFFFFBE8), Color(0xFFDCD6C4), Color(0xFF9AA3BD)],
          stops: [0, 0.62, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8D2FF).withValues(alpha: 0.32),
            blurRadius: glow,
            spreadRadius: glow * 0.28,
          ),
        ],
      ),
    );
  }
}

class Lantern extends StatelessWidget {
  const Lantern({super.key, this.opacity = 1});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 2, height: 26, color: const Color(0xFF6B5A3A)),
          Container(
            width: 16,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFF2B45A),
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF2B45A).withValues(alpha: 0.5),
                  blurRadius: 28,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated version: sways like a lantern in the wind ───────────────────────
class AnimatedLantern extends StatefulWidget {
  const AnimatedLantern({
    super.key,
    this.opacity = 1,
    this.duration = const Duration(milliseconds: 2200),
    this.maxAngle = 0.18, // radians (~10°)
    this.delayFraction = 0.0,
  });

  final double opacity;
  final Duration duration;
  final double maxAngle;
  final double delayFraction;

  @override
  State<AnimatedLantern> createState() => _AnimatedLanternState();
}

class _AnimatedLanternState extends State<AnimatedLantern>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..value = widget.delayFraction.clamp(0.0, 1.0);
    _angle = Tween<double>(
      begin: -widget.maxAngle,
      end: widget.maxAngle,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity,
      child: AnimatedBuilder(
        animation: _angle,
        builder: (_, child) => Transform(
          alignment: Alignment.topCenter, // pivot at the hanging point
          transform: Matrix4.rotationZ(_angle.value),
          child: child,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 2, height: 26, color: const Color(0xFF6B5A3A)),
            Container(
              width: 16,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF2B45A),
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80F2B45A),
                    blurRadius: 28,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarField extends StatelessWidget {
  const StarField({super.key, this.height = 360});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _StarPainter()),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const stars = [
      Offset(30, 60),
      Offset(90, 130),
      Offset(150, 40),
      Offset(220, 100),
      Offset(310, 150),
      Offset(350, 220),
      Offset(60, 250),
      Offset(80, 160),
      Offset(330, 60),
      Offset(300, 190),
    ];
    for (final s in stars) {
      canvas.drawCircle(s, 1.1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MountainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path()
      ..moveTo(0, size.height * 0.70)
      ..lineTo(size.width * 0.12, size.height * 0.45)
      ..lineTo(size.width * 0.24, size.height * 0.62)
      ..lineTo(size.width * 0.38, size.height * 0.30)
      ..lineTo(size.width * 0.52, size.height * 0.58)
      ..lineTo(size.width * 0.66, size.height * 0.38)
      ..lineTo(size.width * 0.80, size.height * 0.60)
      ..lineTo(size.width * 0.92, size.height * 0.42)
      ..lineTo(size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class PathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.42, 0)
      ..lineTo(size.width * 0.58, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ToriiArt extends StatelessWidget {
  const ToriiArt({
    super.key,
    this.width = 240,
    this.height = 200,
    this.opacity = 1,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SvgPicture.asset(
        'assets/svg/torii.svg',
        width: width,
        height: height,
      ),
    );
  }
}

class EmblemMark extends StatelessWidget {
  const EmblemMark({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/logo_emblem.svg',
      width: size,
      height: size,
    );
  }
}

class CategoryIconBadge extends StatelessWidget {
  const CategoryIconBadge({
    super.key,
    required this.category,
    this.size = 52,
    this.iconSize = 26,
  });

  final QuizCategory category;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          colors: [category.gradientInner, category.gradientOuter],
        ),
        border: Border.all(color: category.color, width: 1.5),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        category.iconAsset,
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              color: enabled ? AppColors.primary : AppColors.borderStrong,
              borderRadius: BorderRadius.circular(12),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: AppTheme.onest(
                  size: 16,
                  heightPx: 24,
                  weight: FontWeight.w600,
                  color: enabled ? AppColors.text : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.width,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onTap;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enabled ? AppColors.outline : AppColors.borderStrong,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: AppTheme.onest(
                  size: 15,
                  heightPx: 22,
                  weight: FontWeight.w500,
                  color: enabled ? AppColors.text : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.onToggleObscure,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocus)
      ..dispose();
    super.dispose();
  }

  void _handleFocus() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final focused = _focusNode.hasFocus;
    final borderColor = hasError
        ? AppColors.primaryText
        : focused
        ? AppColors.gold
        : AppColors.borderStrong;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: focused && !hasError
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.10),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: hasError
                    ? AppColors.primaryText
                    : focused
                    ? AppColors.gold
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscure && widget.onToggleObscure != null,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  autofillHints: widget.autofillHints,
                  enableSuggestions: !widget.obscure,
                  autocorrect: !widget.obscure,
                  style: AppTheme.onest(size: 14, heightPx: 20),
                  cursorColor: AppColors.gold,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: AppTheme.onest(
                      size: 14,
                      heightPx: 20,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              if (widget.onToggleObscure != null)
                Semantics(
                  button: true,
                  label: widget.obscure
                      ? 'Tampilkan password'
                      : 'Sembunyikan password',
                  child: GestureDetector(
                    onTap: widget.onToggleObscure,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Icon(
                        widget.obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 13,
                  color: AppColors.primaryText,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: AppTheme.onest(
                      size: 12,
                      heightPx: 16,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class KageProgressBar extends StatelessWidget {
  const KageProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color = AppColors.primary,
    this.glow = false,
  });

  final double value;
  final double height;
  final Color color;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderStrong,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        widthFactor: value.clamp(0, 1),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: glow
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.8),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key, this.onTap, this.label = 'Kembali'});

  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap ?? () => context.pop(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.chevron_left, size: 28, color: AppColors.text),
        ),
      ),
    );
  }
}

class ScoreRow extends StatelessWidget {
  const ScoreRow({super.key, required this.result, this.compact = false});

  final QuizResult result;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cat = categoryById(result.categoryId);
    final date =
        '${result.playedAt.day.toString().padLeft(2, '0')} ${_month(result.playedAt.month)} ${result.playedAt.year}';
    final dur = _fmt(result.duration);
    return Container(
      height: compact ? 64 : 68,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CategoryIconBadge(
            category: cat,
            size: compact ? 40 : 44,
            iconSize: compact ? 20 : 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: AppTheme.onest(
                    size: compact ? 15 : 16,
                    heightPx: compact ? 20 : 22,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$date · $dur',
                  style: AppTheme.onest(
                    size: 12,
                    heightPx: 16,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${result.score}',
            style: AppTheme.onest(
              size: compact ? 20 : 22,
              heightPx: 28,
              weight: FontWeight.w700,
              color: scoreTint(result.score),
            ),
          ),
        ],
      ),
    );
  }

  static String _month(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return names[m - 1];
  }

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class KageBottomNav extends StatelessWidget {
  const KageBottomNav({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 + MediaQuery.paddingOf(context).bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.navBar,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _item(context, 0, Icons.home_outlined, 'Beranda', '/beranda'),
          _item(context, 1, Icons.assignment_outlined, 'Kuis', '/kategori'),
          _item(context, 2, Icons.bar_chart_rounded, 'Skor', '/riwayat'),
          _item(context, 3, Icons.person_outline, 'Profil', '/profil'),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int i,
    IconData icon,
    String label,
    String path,
  ) {
    final active = index == i;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go(path),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: active ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: active ? AppColors.primaryText : AppColors.textMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.onest(
                  size: 12,
                  heightPx: 16,
                  color: active ? AppColors.primaryText : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopWash extends StatelessWidget {
  const TopWash({
    super.key,
    this.height = 220,
    this.colors = const [Color(0xFF161433), AppColors.background],
  });

  final double height;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: height,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.child,
    this.navIndex,
    this.stack = const [],
  });

  final Widget child;
  final int? navIndex;
  final List<Widget> stack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ...stack,
                SafeArea(bottom: false, child: child),
              ],
            ),
          ),
          if (navIndex != null) KageBottomNav(index: navIndex!),
        ],
      ),
    );
  }
}
