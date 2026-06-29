import 'package:flutter/widgets.dart';
import 'package:vasc_pro/dev/library/workbench_theme.dart';

/// LAYER 3 — Storyboard data model, as a DIRECTED GRAPH.
///
/// A [Board] is the storyboard surface. It owns a set of [StoryNode]s (each an
/// iPhone frame carrying a real screen, placed at an x,y position) and a set of
/// directed [StoryEdge]s connecting them. The flow is NOT forced to be linear —
/// a node can branch to several others, and edges can point back (cycles). The
/// board's look (background, arrows) lives in [BoardStyle] so it stays
/// prompt-controllable, separate from the frames it lays out.
class StoryNode {
  const StoryNode({
    required this.id,
    required this.label,
    required this.builder,
    this.position = Offset.zero,
  });

  /// Unique id, referenced by edges.
  final String id;

  /// Caption shown above the frame.
  final String label;

  /// Builds the REAL screen this frame carries.
  final WidgetBuilder builder;

  /// Top-left position of the frame on the board canvas.
  final Offset position;
}

/// A directed connection `from` → `to` (optionally labeled, e.g. the action that
/// triggers the transition).
class StoryEdge {
  const StoryEdge({required this.from, required this.to, this.label});

  final String from;
  final String to;
  final String? label;
}

/// The board's visual configuration — background and arrow styling. Defaults
/// follow the workbench chrome; override per board to restyle the surface.
class BoardStyle {
  const BoardStyle({
    this.background = Workbench.bg,
    this.arrowColor = Workbench.textMuted,
    this.arrowWidth = 2,
  });

  final Color background;
  final Color arrowColor;
  final double arrowWidth;
}

/// One storyboard, modeled as a graph of [nodes] joined by [edges].
class Board {
  const Board({
    required this.title,
    required this.nodes,
    this.edges = const [],
    this.style = const BoardStyle(),
  });

  final String title;
  final List<StoryNode> nodes;
  final List<StoryEdge> edges;
  final BoardStyle style;

  StoryNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }
}
