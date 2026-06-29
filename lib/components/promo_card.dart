import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// Bevel "Upgrade to Bevel Pro" promo card: a soft glossy banner with a title,
/// body, a dismiss (X), a rounded logo mark, and a small pill action button.
class PromoCard extends StatelessWidget {
  const PromoCard({
    super.key,
    required this.title,
    required this.body,
    this.actionLabel = 'View',
    this.onAction,
    this.onClose,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: AppShadows.card,
        // Subtle glossy white → pale lavender/blue wash.
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDFDFF),
            Color(0xFFF1F0F8),
            Color(0xFFEAEDF6),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.cardTitle),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        body,
                        style: AppTypography.metaGrey.copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: onClose,
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.inkSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _LogoMark(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: _PillButton(label: actionLabel, onTap: onAction),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dark glossy rounded-square brand mark placeholder.
class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A3A3E), Color(0xFF111113)],
        ),
        boxShadow: AppShadows.pill,
      ),
      alignment: Alignment.center,
      child: const Text(
        'B',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimary,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: AppColors.ink),
        ),
      ),
    );
  }
}
