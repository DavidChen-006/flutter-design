import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel primitive: a biomarker row.
///
/// White rounded card showing a biomarker's title, a grey "no trends" status
/// line (circle-✕ + status text + bold value/unit), and a small trend slider
/// with a dotted baseline on the right. Repeated down the "Other Biomarkers"
/// list (Weight, HRV Baselines, RHR Baselines, Body Fat Percentage, …).
class BiomarkerCard extends StatelessWidget {
  const BiomarkerCard({
    super.key,
    required this.title,
    this.status = 'No trends available',
    required this.unit,
    this.value = '—',
  });

  final String title;
  final String status;
  final String unit;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg - 4,
        vertical: AppSpacing.md + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.cardTitle),
                const SizedBox(height: AppSpacing.sm + 2),
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.inkTertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 11,
                        color: AppColors.card,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$status • ',
                              style: AppTypography.body.copyWith(
                                color: AppColors.inkTertiary,
                              ),
                            ),
                            TextSpan(
                              text: '$value$unit',
                              style: AppTypography.body.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const _MiniTrendSlider(),
        ],
      ),
    );
  }
}

/// The small right-hand trend control: a track line with a knob at the far
/// right, and a dotted baseline beneath it.
class _MiniTrendSlider extends StatelessWidget {
  const _MiniTrendSlider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Track line with a knob pinned to the right end.
          SizedBox(
            height: 12,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 2, color: AppColors.hairline),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.inkTertiary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Dotted baseline.
          const SizedBox(
            height: 2,
            child: CustomPaint(painter: _DottedLinePainter()),
          ),
        ],
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  const _DottedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.hairline
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dash = 2.0;
    const gap = 4.0;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) => false;
}
