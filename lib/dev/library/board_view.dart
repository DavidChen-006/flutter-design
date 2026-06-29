import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vasc_pro/dev/library/device_frame.dart';
import 'package:vasc_pro/dev/library/inspectable.dart';
import 'package:vasc_pro/dev/library/workbench_theme.dart';
import 'package:vasc_pro/dev/storyboard/storyboard_models.dart';
import 'package:widget_arrows/widget_arrows.dart';

/// Renders a [Board] as a pan/zoom canvas. Each node becomes a positioned
/// [DeviceFrame]; each directed [StoryEdge] is a real arrow OBJECT — an
/// [ArrowElement] from the `widget_arrows` package that binds the source frame
/// to the target frame by id and re-routes itself from their LIVE render boxes
/// (branches and cycles included). Hover inspection is enabled inside every
/// frame. Frames are draggable by their caption (Figma-style); because the
/// arrows read the frames' live rects, they follow the drag at any zoom.
class BoardView extends StatefulWidget {
  const BoardView({super.key, required this.board});

  final Board board;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  // Footprint of one node = iPhone 15 DeviceFrame (393×852 + 10px bezel each
  // side) plus the caption/handle row above it.
  static const double _nodeW = 413;
  static const double _nodeH = 900;
  static const double _pad = 240;

  /// Live top-left positions per node id. Seeded from the board's nodes and
  /// updated as the user drags a frame, so the positioned frames, the edge
  /// anchor choice and the labels all read the same moving rects.
  late Map<String, Offset> _positions;

  /// Drives the canvas transform; lets us map pointer positions into scene
  /// (canvas) coordinates so a dragged frame tracks the cursor 1:1 at any zoom.
  final TransformationController _transform = TransformationController();

  /// Key on the InteractiveViewer so we can resolve global→viewport→scene.
  final GlobalKey _viewportKey = GlobalKey();

  /// Bumped on every drag frame so the [ArrowContainer]'s painter repaints and
  /// the arrows re-read the moving frame render boxes mid-drag.
  final ValueNotifier<int> _tick = ValueNotifier(0);

  /// While a frame handle is pressed, canvas panning is suspended so the drag
  /// moves the frame instead of the whole graph (resolves the gesture arena vs.
  /// InteractiveViewer). Zoom stays enabled throughout.
  bool _panEnabled = true;

  // Per-drag anchors (scene-space).
  Offset _dragStartScene = Offset.zero;
  Offset _dragStartPos = Offset.zero;

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
  void dispose() {
    _transform.dispose();
    _tick.dispose();
    super.dispose();
  }

  /// Maps a global pointer position to scene/canvas coordinates via the
  /// viewport render box and the current transform.
  Offset _toScene(Offset global) {
    final box = _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return global;
    return _transform.toScene(box.globalToLocal(global));
  }

  void _setPan(bool enabled) {
    if (_panEnabled != enabled) setState(() => _panEnabled = enabled);
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

    // Outgoing edges per source node, so each frame can be wrapped in one
    // ArrowElement per edge it originates.
    final outgoing = <String, List<StoryEdge>>{};
    for (final e in board.edges) {
      if (rects[e.from] == null || rects[e.to] == null) continue;
      (outgoing[e.from] ??= []).add(e);
    }

    return InteractiveViewer(
      key: _viewportKey,
      transformationController: _transform,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(600),
      panEnabled: _panEnabled,
      minScale: 0.25,
      maxScale: 2,
      child: SizedBox(
        width: canvasW,
        height: canvasH,
        child: Stack(
          // Don't clip frames/labels dragged beyond the seed canvas bounds.
          clipBehavior: Clip.none,
          children: [
            // The arrow layer: ArrowContainer paints every edge's ArrowElement
            // on top of the frames it owns, re-reading their live render boxes.
            ArrowContainer(
              listenables: [_tick],
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ColoredBox(color: board.style.background),
                  ),
                  for (final n in board.nodes)
                    Positioned(
                      left: rects[n.id]!.left,
                      top: rects[n.id]!.top,
                      child: _wrapFrame(
                        node: n,
                        edges: outgoing[n.id] ?? const [],
                        rects: rects,
                        style: board.style,
                      ),
                    ),
                ],
              ),
            ),
            // Edge labels sit ABOVE the arrows so the chip masks the line it
            // annotates; positioned at the midpoint of the two live frames.
            for (final e in board.edges)
              if (e.label != null &&
                  rects[e.from] != null &&
                  rects[e.to] != null)
                Positioned(
                  left: (rects[e.from]!.center.dx + rects[e.to]!.center.dx) / 2,
                  top: (rects[e.from]!.center.dy + rects[e.to]!.center.dy) / 2,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -0.5),
                    child: _EdgeLabel(text: e.label!, style: board.style),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  /// Wraps a node's frame in its anchor [ArrowElement] (id = node id, the target
  /// for incoming edges) plus one source [ArrowElement] per outgoing edge. All
  /// share the frame's render box, so each edge anchors to the live frame; the
  /// anchors are picked from the current rects so arrows leave/enter the side
  /// facing the other frame.
  Widget _wrapFrame({
    required StoryNode node,
    required List<StoryEdge> edges,
    required Map<String, Rect> rects,
    required BoardStyle style,
  }) {
    Widget current = ArrowElement(id: node.id, child: _frame(node));
    for (var i = 0; i < edges.length; i++) {
      final e = edges[i];
      final (sourceAnchor, targetAnchor) = _anchors(
        rects[e.from]!.center,
        rects[e.to]!.center,
      );
      current = ArrowElement(
        id: '${node.id}__out_$i',
        targetId: e.to,
        sourceAnchor: sourceAnchor,
        targetAnchor: targetAnchor,
        color: style.arrowColor,
        width: style.arrowWidth,
        tipLength: 14,
        tipAngleOutwards: 0.5,
        child: current,
      );
    }
    return current;
  }

  /// The node's frame: a drag handle above a fully-interactive device frame.
  Widget _frame(StoryNode node) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle: grab a frame by this bar to move it. A Listener suspends
        // canvas panning the instant the handle is pressed, so this drag wins
        // over InteractiveViewer; the motion is mapped through the transform so
        // the frame tracks the cursor at any zoom, and each drag frame ticks the
        // arrow painter so the edges follow live.
        Listener(
          onPointerDown: (_) => _setPan(false),
          onPointerUp: (_) => _setPan(true),
          onPointerCancel: (_) => _setPan(true),
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) {
                _dragStartScene = _toScene(d.globalPosition);
                _dragStartPos = _positions[node.id]!;
              },
              onPanUpdate: (d) {
                final scene = _toScene(d.globalPosition);
                setState(() {
                  _positions[node.id] =
                      _dragStartPos + (scene - _dragStartScene);
                  _tick.value++;
                });
              },
              onPanEnd: (_) => _setPan(true),
              child: _DragHandle(label: node.label),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // The inner screen stays fully interactive (taps, scroll,
        // hover-inspector) — only the handle above drags the frame.
        DeviceFrame(child: InspectScope(child: node.builder(context))),
      ],
    );
  }

  /// Picks the (source, target) border anchors for an edge from the dominant
  /// axis between the two frame centers, so the arrow leaves/enters the facing
  /// side rather than a fixed corner. Recomputed each build → adapts to drags.
  (Alignment, Alignment) _anchors(Offset from, Offset to) {
    final d = to - from;
    if (d.dx.abs() >= d.dy.abs()) {
      return d.dx >= 0
          ? (Alignment.centerRight, Alignment.centerLeft)
          : (Alignment.centerLeft, Alignment.centerRight);
    }
    return d.dy >= 0
        ? (Alignment.bottomCenter, Alignment.topCenter)
        : (Alignment.topCenter, Alignment.bottomCenter);
  }
}

/// A visible grab bar above each frame — the explicit drag target.
class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Workbench.surface,
        border: Border.all(color: Workbench.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.drag_indicator, size: 14, color: Workbench.textMuted),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: Workbench.sectionHeader.copyWith(color: Workbench.textMuted),
          ),
        ],
      ),
    );
  }
}

/// A small chip annotating an edge with the action that triggers the
/// transition, drawn over the arrow at its midpoint.
class _EdgeLabel extends StatelessWidget {
  const _EdgeLabel({required this.text, required this.style});

  final String text;
  final BoardStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: style.arrowColor,
          fontSize: 15,
          letterSpacing: 1.2,
          fontFamilyFallback: const ['Menlo', 'SFMono-Regular', 'monospace'],
        ),
      ),
    );
  }
}
