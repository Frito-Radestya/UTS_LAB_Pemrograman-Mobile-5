import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BoltButton extends StatelessWidget {
  const BoltButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.secondary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: secondary
            ? context.colors.surfaceContainerHighest
            : AppColors.yellow,
        foregroundColor: secondary ? context.colors.onSurface : Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: context.space,
          vertical: context.space * 1.05,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.space),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(label, textAlign: TextAlign.center)),
          if (icon != null) ...[
            SizedBox(width: context.space * .5),
            Icon(icon, size: 19),
          ],
        ],
      ),
    );
  }
}

class BoltCard extends StatelessWidget {
  const BoltCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.space * 1.15);
    return Material(
      color: color ?? context.colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: .4),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.space),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 3,
        height: 18,
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      SizedBox(width: context.space * .5),
      Expanded(child: Text(title, style: context.text.titleMedium)),
      if (action != null)
        TextButton(
          onPressed: onAction,
          child: Text(
            action!,
            style: context.text.labelSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
    ],
  );
}

class BoltLogo extends StatelessWidget {
  const BoltLogo({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.bolt_rounded,
        color: context.colors.primary,
        size: compact ? 26 : 32,
      ),
      Flexible(
        child: Text(
          'BoltQuiz',
          style: (compact ? context.text.titleMedium : context.text.titleLarge)
              ?.copyWith(letterSpacing: -1),
        ),
      ),
    ],
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, this.icon, this.color});
  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? context.colors.primary;
    final foreground =
        Theme.of(context).brightness == Brightness.light &&
            accent.computeLuminance() > .45
        ? Color.lerp(accent, Colors.black, .58)!
        : accent;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space * .65,
        vertical: context.space * .4,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: context.text.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.trailing,
    this.back = false,
  });
  final String title;
  final Widget? trailing;
  final bool back;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (back) ...[
        IconButton.filledTonal(
          tooltip: 'Kembali',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
        ),
        SizedBox(width: context.space * .5),
      ] else ...[
        Icon(Icons.bolt_rounded, color: context.colors.primary),
        SizedBox(width: context.space * .4),
      ],
      Expanded(child: Text(title, style: context.text.titleMedium)),
      ?trailing,
    ],
  );
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => BoltCard(
    padding: EdgeInsets.symmetric(
      horizontal: context.space * .5,
      vertical: context.space,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(context.space * .45),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: context.colors.primary, size: 22),
        ),
        SizedBox(height: context.space * .5),
        Text(
          value,
          style: context.text.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.text.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
