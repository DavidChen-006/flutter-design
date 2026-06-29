import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';

/// A generic composite component: a bottom-style bar built from [DemoNavButton]
/// instances. Exists to demonstrate parent→child component NESTING — the bar is
/// the parent, each button is its own reusable child component, and the sidebar
/// reveals that structure.
class DemoNavBar extends StatelessWidget {
  const DemoNavBar({super.key, this.currentIndex = 0, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DemoNavButton(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: currentIndex == 0,
            onTap: () => onTap?.call(0),
          ),
          DemoNavButton(
            icon: Icons.search,
            label: 'Search',
            selected: currentIndex == 1,
            onTap: () => onTap?.call(1),
          ),
          DemoNavButton(
            icon: Icons.person_outline,
            label: 'Profile',
            selected: currentIndex == 2,
            onTap: () => onTap?.call(2),
          ),
        ],
      ),
    );
  }
}

/// A single nav button — its own reusable component (the child of [DemoNavBar]).
class DemoNavButton extends StatelessWidget {
  const DemoNavButton({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
