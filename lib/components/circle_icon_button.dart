import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';

/// LAYER 2 — Bevel primitive: a soft circular icon button.
///
/// A floating circle (white by default) with a soft shadow and a centered icon.
/// Used for the top-right "⋯" menu on the Biological Age screen.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 52,
    this.iconColor = AppColors.ink,
    this.background = AppColors.card,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color iconColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: AppShadows.pill,
        ),
        child: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }
}
