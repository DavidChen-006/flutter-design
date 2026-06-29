import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel primitive: an outlined alert banner.
///
/// Full-width white card with a coloured border, a filled warning glyph, bold
/// coloured text, and a trailing arrow — e.g. "Why do I have no data? →".
class AlertBanner extends StatelessWidget {
  const AlertBanner({
    super.key,
    required this.text,
    this.icon = Icons.error_outline,
    this.color = AppColors.accentOrange,
    this.onTap,
  });

  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: AppColors.onPrimary),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Text(
                text,
                style: AppTypography.cardTitle.copyWith(color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.arrow_forward, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}
