import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vasc_pro/dev/library/device_frame.dart';
import 'package:vasc_pro/dev/library/inspectable.dart';
import 'package:vasc_pro/dev/library/workbench_theme.dart';
import 'package:vasc_pro/dev/storyboard/storyboard_models.dart';

/// Renders a [Board] as a pan/zoom canvas. Each node becomes a positioned
/// [DeviceFrame]; each directed [StoryEdge] is drawn as a curved arrow from the
/// source frame to the target frame (branches and cycles included). Hover
/// inspection is enabled inside every frame. Frames are draggable by their
/// caption (Figma-style), and the edges re-anchor to the live frame rects.
class BoardView extends StatefulWidget {
  const BoardView({super.key, required this.board});

  final Board board;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  // Footprint of one node = iPhone 15 DeviceFrame (393×852 + 10px bezel each
  // side) plus the caption row above it.
  static const double _nodeW = 413;
  static const double _nodeH = 900;
  static const double _pad = 240;

  /// Live top-left positions per node id. Seeded from the board's nodes and
  /// updated as the user drags a frame, so both the positioned frames and the
  /// [_EdgePainter] read the same moving rects.
  late Map<String, Offset> _positions;

  @override
  void initState() {
    super.initState();
    _positions = {for (final n in widget.board.nodes) n.id: n.position};
  }

  @override
  void didUpdateWidget(BoardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Switching boards resets the layout to the new board's seed positions.
    if (widget.board != oldWidget.board) {
      _positions = {for (final n in widget.board.nodes) n.id: n.position};
    }
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;
    if (board.nodes.isEmpty) return const SizedBox.shrink();

    var minX = double.infinity, minY = double.infinity;
    var maxX = double.negativeInfinity, maxY = double.negativeInfinity;
    for (final n in board.nodes) {
      minX = math.min(minX, n.position.dx);
      minY = math.min(minY, n.position.dy);
      maxX = math.max(maxX, n.position.dx + _nodeW);
      maxY = math.max(maxY, n.position.dy + _nodeH);
    }
    final origin = Offset(_pad - minX, _pad - minY);
    final canvasW = (maxX - minX) + _pad * 2;
    final canvasH = (maxY - minY) + _pad * 2;

    final rects = <String, Rect>{
      for (final n in board.nodes)
        n.id: Rect.fromLTWH(
          _positions[n.id]!.dx + origin.dx,
          _positions[n.id]!.dy + origin.dy,
          _nodeW,
          _nodeH,
        ),
    };

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(600),
      minScale: 0.25,
      maxScale: 2,
      child: SizedBox(
        width: canvasW,
        height: canvasH,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: board.style.background)),
            Positioned.fill(
              child: CustomPaint(painter: _EdgePainter(board, rects)),
            ),
            for (final n in board.nodes)
              Positioned(
                left: rects[n.id]!.left,
                top: rects[n.id]!.top,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The caption is the drag handle: grab a frame by its title
                    // to move it. Pointer deltas are already in canvas
                    // coordinates (the InteractiveViewer transforms them), so
                    // they're added straight to the live position.
                    MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (d) => setState(
                          () => _positions[n.id] = _positions[n.id]! + d.delta,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              n.label.toUpperCase(),
                              style: Workbench.sectionHeader.copyWith(
                                color: Workbench.textMuted,
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ),
                    // The inner screen stays fully interactive (and so does its
                    // hover-inspector) — only the caption above drags the frame.
                    DeviceFrame(child: InspectScope(child: n.builder(context))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Draws a curved directed arrow per edge, anchored to the borders of the
/// source/target frame rects so the lines meet the frames cleanly.
class _EdgePainter extends CustomPainter {
  _EdgePainter(this.board, this.rects);

  final Board board;
  final Map<String, Rect> rects;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = board.style.arrowColor
      ..strokeWidth = board.style.arrowWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = board.style.arrowColor
      ..style = PaintingStyle.fill;

    for (final e in board.edges) {
      final a = rects[e.from];
      final b = rects[e.to];
      if (a == null || b == null) continue;

      final start = _border(a, b.center);
      final end = _border(b, a.center);
      final dx = (end.dx - start.dx) * 0.5;
      final c1 = Offset(start.dx + dx, start.dy);
      final c2 = Offset(end.dx - dx, end.dy);

      canvas.drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy),
        stroke,
      );
      _arrowHead(canvas, end, c2, fill);
      if (e.label != null) _label(canvas, e.label!, (start + end) / 2);
    }
  }

  /// Point on rect [r]'s border in the direction of [toward].
  Offset _border(Rect r, Offset toward) {
    final c = r.center;
    final dir = toward - c;
    if (dir.dx == 0 && dir.dy == 0) return c;
    final ax = dir.dx.abs(), ay = dir.dy.abs();
    final sx = ax > 1e-6 ? (r.width / 2) / ax : double.infinity;
    final sy = ay > 1e-6 ? (r.height / 2) / ay : double.infinity;
    return c + dir * math.min(sx, sy);
  }

  void _arrowHead(Canvas canvas, Offset tip, Offset from, Paint fill) {
    final dir = tip - from;
    final angle = math.atan2(dir.dy, dir.dx);
    const len = 16.0, spread = 0.5;
    final p1 =
        tip - Offset(math.cos(angle - spread), math.sin(angle - spread)) * len;
    final p2 =
        tip - Offset(math.cos(angle + spread), math.sin(angle + spread)) * len;
    canvas.drawPath(
      Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close,
      fill,
    );
  }

  void _label(Canvas canvas, String text, Offset at) {
    final tp = TextPainter(
      text: TextSpan(
        text: text.toUpperCase(),
        style: TextStyle(
          color: board.style.arrowColor,
          fontSize: 15,
          letterSpacing: 1.2,
          fontFamilyFallback: const ['Menlo', 'SFMono-Regular', 'monospace'],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: at,
      width: tp.width + 18,
      height: tp.height + 10,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      Paint()..color = board.style.background,
    );
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _EdgePainter old) => true;
}
