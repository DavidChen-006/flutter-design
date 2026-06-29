import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel primitive: the floating account bar.
///
/// A white stadium pill that sits at the top-right of the home screen: a share
/// action and a circular avatar showing the user's initials.
class AccountBar extends StatelessWidget {
  const AccountBar({
    super.key,
    required this.initials,
    this.onShare,
    this.onProfile,
  });

  final String initials;
  final VoidCallback? onShare;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: AppShadows.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onShare,
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.ios_share, size: 22, color: AppColors.ink),
          ),
          const SizedBox(width: AppSpacing.md),
          GestureDetector(
            onTap: onProfile,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.avatarBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                initials,
                style: AppTypography.caption.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
