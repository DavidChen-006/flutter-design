import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';

/// LAYER 2 — Bevel "Biological Age" radial dial.
///
/// A large ticked ruler ring, open at the bottom, with min/max labels at its
/// lower ends, a white knob that slides across the bottom gap (driven by
/// [progress]), the current [value] beneath, an optional [center] widget (e.g.
/// the "Unlock with Pro" pill) in the middle, and a faint cluster of blurred
/// dots behind it suggesting locked data. Renders on a light gradient surface.
class RadialAgeGauge extends StatelessWidget {
  const RadialAgeGauge({
    super.key,
    required this.value,
    required this.minLabel,
    required this.maxLabel,
    this.progress = 0.5,
    this.center,
  });

  final String value;
  final String minLabel;
  final String maxLabel;

  /// 0 = left/bottom end, 1 = right/bottom end, 0.5 = bottom centre.
  final double progress;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 360.0;
        final radius = w / 2 - 18;
        final cy = radius + 8;
        final dialH = radius * 2 + 20;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: w,
              height: dialH,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _AgeDialPainter(
                        progress: progress.clamp(0.0, 1.0),
                        minLabel: minLabel,
                        maxLabel: maxLabel,
                      ),
                    ),
                  ),
                  Positioned(
                    top: cy - 66,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 200,
                          height: 52,
                          child: CustomPaint(painter: _DotsPainter()),
                        ),
                        const SizedBox(height: 6),
                        ?center,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AgeDialPainter extends CustomPainter {
  _AgeDialPainter({
    required this.progress,
    required this.minLabel,
    required this.maxLabel,
  });

  final double progress;
  final String minLabel;
  final String maxLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2 - 18;
    final center = Offset(size.width / 2, radius + 8);

    final gapHalf = 32 * math.pi / 180; // half of the bottom opening
    final bottom = math.pi / 2; // 6 o'clock
    final leftEnd = bottom + gapHalf; // lower-left arc end (min)
    final rightEnd = bottom - gapHalf; // lower-right arc end (max)
    final sweep = 2 * math.pi - 2 * gapHalf;

    // Fine radial tick ruler around the open ring.
    const tickCount = 92;
    final tick = Paint()..strokeCap = StrokeCap.round;
    for (var i = 0; i <= tickCount; i++) {
      final a = leftEnd + sweep * (i / tickCount);
      final isMajor = i % 10 == 0;
      final len = isMajor ? 15.0 : 9.0;
      tick
        ..strokeWidth = isMajor ? 1.6 : 1.0
        ..color = isMajor ? AppColors.inkTertiary : AppColors.hairline;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(center + dir * (radius - len), center + dir * radius, tick);
    }

    // Knob: slides across the bottom gap (0 -> left end, 1 -> right end).
    final knobA = leftEnd - 2 * gapHalf * progress;
    final knobPos = center + Offset(math.cos(knobA), math.sin(knobA)) * radius;
    canvas.drawCircle(
      knobPos + const Offset(0, 1.5),
      9,
      Paint()..color = const Color(0x16000000),
    );
    canvas.drawCircle(knobPos, 8, Paint()..color = AppColors.card);
    canvas.drawCircle(
      knobPos,
      8,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.hairline,
    );

    // Min / max labels at the lower arc ends.
    _label(canvas, minLabel,
        center + Offset(math.cos(leftEnd), math.sin(leftEnd)) * (radius - 30));
    _label(canvas, maxLabel,
        center + Offset(math.cos(rightEnd), math.sin(rightEnd)) * (radius - 30));
  }

  void _label(Canvas canvas, String text, Offset at) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppColors.inkTertiary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_AgeDialPainter old) =>
      old.progress != progress ||
      old.minLabel != minLabel ||
      old.maxLabel != maxLabel;
}

/// Faint scattered dots suggesting blurred / locked data behind the centre.
class _DotsPainter extends CustomPainter {
  const _DotsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final paint = Paint();
    for (var i = 0; i < 34; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final r = 1.5 + rnd.nextDouble() * 2.5;
      final opacity = 0.35 + rnd.nextDouble() * 0.5;
      paint.color = Color.fromRGBO(255, 255, 255, opacity);
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => false;
}
