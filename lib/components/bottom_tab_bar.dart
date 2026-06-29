import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';

/// Bevel bottom navigation: a white stadium bar of four tabs (the active one in
/// a soft grey highlight) beside a separate floating circular "+" button.
class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.onAdd,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;
  final VoidCallback? onAdd;

  static const List<_TabItem> _tabs = [
    _TabItem(icon: Icons.home, label: 'Home'),
    _TabItem(icon: Icons.menu_book, label: 'Journal'),
    _TabItem(icon: Icons.directions_run, label: 'Fitness'),
    _TabItem(icon: Icons.favorite, label: 'Biology'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              boxShadow: AppShadows.pill,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  _Tab(
                    item: _tabs[i],
                    selected: i == currentIndex,
                    onTap: () => onTap?.call(i),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        GestureDetector(
          onTap: onAdd,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
              boxShadow: AppShadows.pill,
            ),
            child: const Icon(Icons.add, size: 30, color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, this.onTap});

  final _TabItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.ink : AppColors.inkSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.cardAlt : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
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

class _TabItem {
  const _TabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
