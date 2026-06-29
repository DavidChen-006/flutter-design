import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel primitive: a section header with a trailing action.
///
/// A bold section title on the left and a tappable underlined action label on
/// the right. Matches the "Other Biomarkers" + "Edit" row.
class SectionHeaderAction extends StatelessWidget {
  const SectionHeaderAction({
    super.key,
    required this.title,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTypography.sectionTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          behavior: HitTestBehavior.opaque,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.inkSecondary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.inkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
