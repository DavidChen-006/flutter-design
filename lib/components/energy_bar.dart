import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';

/// LAYER 2 — Bevel energy bar: a bolt icon, a segmented tick meter, and the
/// percentage. The leftmost [value] fraction of ticks is filled with [color].
class EnergyBar extends StatelessWidget {
  const EnergyBar({
    super.key,
    required this.value,
    required this.percentLabel,
    this.icon = Icons.bolt,
    this.color = AppColors.accentOrange,
  });

  /// 0..1 fraction of the meter that is filled.
  final double value;
  final String percentLabel;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: SizedBox(
              height: 22,
              child: CustomPaint(
                painter: _TickMeterPainter(
                  value: value.clamp(0.0, 1.0),
                  color: color,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            percentLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _TickMeterPainter extends CustomPainter {
  const _TickMeterPainter({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 6.0;
    final count = (size.width / gap).floor();
    final filled = (count * value).round();
    final cy = size.height / 2;

    for (var i = 0; i < count; i++) {
      final x = i * gap + gap / 2;
      final paint = Paint()
        ..color = i < filled ? color : AppColors.hairline
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(x, cy - size.height / 2),
        Offset(x, cy + size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_TickMeterPainter old) =>
      old.value != value || old.color != color;
}
