import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Primitive: button.
///
/// The ONE button used everywhere. Variants are expressed via [AppButtonVariant]
/// (mirrors the video's "primary" vs "ghost / outline" example). Both the Gallery
/// and production screens render this exact widget — no parallel button code.
enum AppButtonVariant { primary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isGhost = variant == AppButtonVariant.ghost;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isGhost ? Colors.transparent : AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: isGhost
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.label.copyWith(
                color: isGhost ? AppColors.primary : AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
