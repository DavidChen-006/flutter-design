import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Primitive: badge.
///
/// Small status pill. Tone selects a semantic color from the design tokens.
enum AppBadgeTone { neutral, success, danger }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
  });

  final String label;
  final AppBadgeTone tone;

  Color get _color => switch (tone) {
        AppBadgeTone.neutral => AppColors.textSecondary,
        AppBadgeTone.success => AppColors.success,
        AppBadgeTone.danger => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
