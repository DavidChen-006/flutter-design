import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';

/// LAYER 2 — Bevel pill button.
///
/// A soft white stadium chip with an optional leading icon and a bold label —
/// e.g. the "🔒 Unlock with Pro" chip on the Biological Age screen.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.background = AppColors.card,
    this.foreground = AppColors.ink,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(100),
            boxShadow: AppShadows.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
