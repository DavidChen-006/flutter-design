import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel metric ring (Strain / Recovery / Sleep dial).
///
/// A thick circular track with an optional progress arc and a centred value,
/// with a grey label beneath. Pass [active] false for the empty "-%" state.
class MetricRing extends StatelessWidget {
  const MetricRing({
    super.key,
    required this.value,
    required this.label,
    this.progress = 0,
    this.color = AppColors.accentOrange,
    this.active = true,
  });

  final String value;
  final String label;

  /// 0..1 sweep of the progress arc (only drawn when [active]).
  final double progress;
  final Color color;
  final bool active;

  static const double _size = 96;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _size,
          height: _size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: active ? progress.clamp(0.0, 1.0) : 0,
              color: color,
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.ink : AppColors.inkTertiary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: AppTypography.metaGrey, textAlign: TextAlign.center),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.hairline;
    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      final arc = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

/// LAYER 2 — Bevel metric card: a white card holding metric rings in a row with
/// hairline dividers (the Strain / Recovery / Sleep panel).
class MetricRingRow extends StatelessWidget {
  const MetricRingRow({super.key, required this.rings});

  final List<Widget> rings;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < rings.length; i++) {
      if (i > 0) {
        children.add(Container(width: 1, height: 120, color: AppColors.hairline));
      }
      children.add(Expanded(child: Center(child: rings[i])));
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
