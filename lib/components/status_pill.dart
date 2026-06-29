import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel primitive: a status pill.
///
/// White rounded pill with a leading icon (optionally inside a tinted, rounded
/// badge), a bold title, an optional grey subtitle, and an optional trailing
/// chevron. Used for the "Active / Until changed" and "—°F / No location" chips.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.icon,
    this.iconBackground,
    this.iconColor = AppColors.inkSecondary,
    required this.title,
    this.subtitle,
    this.showChevron = false,
    this.onTap,
  });

  final IconData icon;
  final Color? iconBackground;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          boxShadow: AppShadows.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _leadingIcon(),
            const SizedBox(width: AppSpacing.sm + 2),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.inkSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: AppColors.inkTertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _leadingIcon() {
    if (iconBackground == null) {
      return Icon(icon, size: 24, color: iconColor);
    }
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(iconBackground!, Colors.white, 0.18)!,
            iconBackground!,
          ],
        ),
      ),
      child: Icon(icon, size: 22, color: AppColors.onPrimary),
    );
  }
}
