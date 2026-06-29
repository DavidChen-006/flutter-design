import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel "Today's stress" card.
///
/// A white card with a status header, the last-updated meta line, three stats
/// (Highest / Lowest / Average) split by hairline dividers, and a dotted radial
/// stress gauge sweeping green → yellow → orange → red.
class StressCard extends StatelessWidget {
  const StressCard({
    super.key,
    this.title = "Today's stress",
    required this.updated,
    required this.highest,
    required this.lowest,
    required this.average,
    this.onTap,
  });

  final String title;
  final String updated;
  final String highest;
  final String lowest;
  final String average;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: AppTypography.cardTitle),
                const Spacer(),
                const Icon(Icons.arrow_outward,
                    size: 20, color: AppColors.inkSecondary),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(updated, style: AppTypography.caption),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _stat(highest, 'Highest'),
                      _divider(),
                      _stat(lowest, 'Lowest'),
                      _divider(),
                      _stat(average, 'Average'),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const SizedBox(
                  width: 84,
                  height: 84,
                  child: CustomPaint(painter: _StressGaugePainter()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.statValue),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.metaGrey),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: AppColors.hairline);
}

class _StressGaugePainter extends CustomPainter {
  const _StressGaugePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    const ticks = 40;
    const startAngle = math.pi * 0.75; // 135°, bottom-left
    const sweep = math.pi * 1.5; // 270°

    const colors = [
      Color(0xFF5BD08A), // green
      Color(0xFFE2C744), // yellow
      Color(0xFFF2994A), // orange
      Color(0xFFE26A5A), // red
    ];

    for (var i = 0; i < ticks; i++) {
      final t = i / (ticks - 1);
      final angle = startAngle + sweep * t;
      final color = _lerpStops(colors, t).withValues(alpha: 0.55);

      final outer = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (radius - 9) * math.cos(angle),
        center.dy + (radius - 9) * math.sin(angle),
      );

      final paint = Paint()
        ..color = color
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(inner, outer, paint);
    }

    // Centre dash.
    final dash = Paint()
      ..color = AppColors.ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - 7, center.dy),
      Offset(center.dx + 7, center.dy),
      dash,
    );
  }

  Color _lerpStops(List<Color> stops, double t) {
    if (t <= 0) return stops.first;
    if (t >= 1) return stops.last;
    final scaled = t * (stops.length - 1);
    final i = scaled.floor();
    return Color.lerp(stops[i], stops[i + 1], scaled - i)!;
  }

  @override
  bool shouldRepaint(_StressGaugePainter old) => false;
}
