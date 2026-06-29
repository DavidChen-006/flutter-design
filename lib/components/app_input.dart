import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Primitive: input box.
///
/// The input field reused across forms and storyboard flows. Same widget in the
/// Gallery and in production, so styling stays consistent.
class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.label),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.caption,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
