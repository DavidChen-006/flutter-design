import 'package:flutter/widgets.dart';
import '../../content/app_content.dart';
import '../../features/_demo/placeholder_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import 'storyboard_models.dart';

/// LAYER 3 — The board REGISTRY (the live map of the whole app).
///
/// The storyboard is ONE picture of your entire product: every real screen is an
/// iPhone frame ([StoryNode]) and every navigation path between screens is a
/// directed arrow ([StoryEdge]). Keep ALL your screens in a single board (e.g.
/// `App Flow`) so the storyboard shows the whole app and how it connects at a
/// glance — do NOT scatter screens across separate one-frame boards with no
/// arrows between them.
///
/// Flows branch (several edges out of a node) and cycle (an edge pointing back) —
/// they are NOT forced linear. Drag a frame by its caption to rearrange; the
/// arrows follow.
///
/// HOW TO SHAPE A FLOW:
///   1. Build the screen in `lib/features/<flow>/<screen>.dart`.
///   2. Add a `StoryNode(id, label, builder, position)` to the board's `nodes`.
///   3. Connect nodes with `StoryEdge(from, to, label)` — label each arrow with
///      the action that triggers the transition; add a back-edge for return paths.
///
/// The board below is a PLACEHOLDER flow. Replace these demo frames with your
/// app's real screens — keep them all in this one board — and rewire the arrows.
// Frame captions and edge labels are sourced from the content layer
// (`lib/content/`) — the single source of truth for copy — so the registry is
// `final`, not `const`.
final List<Board> kBoards = [
  Board(
    title: 'App Flow',
    nodes: [
      StoryNode(
        id: 'start',
        label: AppContent.demoBoard.welcomeLabel,
        builder: _welcome,
        position: const Offset(0, 0),
      ),
      StoryNode(
        id: 'a',
        label: AppContent.demoBoard.branchAName,
        builder: _branchA,
        position: const Offset(640, -380),
      ),
      StoryNode(
        id: 'b',
        label: AppContent.demoBoard.branchBName,
        builder: _branchB,
        position: const Offset(640, 380),
      ),
    ],
    edges: [
      StoryEdge(from: 'start', to: 'a', label: AppContent.demoBoard.branchAEdge),
      StoryEdge(from: 'start', to: 'b', label: AppContent.demoBoard.branchBEdge),
      StoryEdge(from: 'b', to: 'start', label: AppContent.demoBoard.backEdge), // cycle
    ],
  ),
];

// Top-level builder functions keep the screen builders tidy and reusable across
// boards. The placeholder frames read their copy from the content layer.
WelcomeScreen _welcome(BuildContext context) => const WelcomeScreen();
PlaceholderScreen _branchA(BuildContext context) => PlaceholderScreen(
      title: AppContent.demoBoard.branchAName,
      subtitle: AppContent.demoBoard.branchASubtitle,
    );
PlaceholderScreen _branchB(BuildContext context) => PlaceholderScreen(
      title: AppContent.demoBoard.branchBName,
      subtitle: AppContent.demoBoard.branchBSubtitle,
    );
