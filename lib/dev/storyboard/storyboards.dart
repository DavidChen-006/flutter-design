import 'package:flutter/widgets.dart';
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
const List<Board> kBoards = [
  Board(
    title: 'App Flow',
    nodes: [
      StoryNode(
        id: 'start',
        label: 'Welcome',
        builder: _welcome,
        position: Offset(0, 0),
      ),
      StoryNode(
        id: 'a',
        label: 'Branch A',
        builder: _branchA,
        position: Offset(640, -380),
      ),
      StoryNode(
        id: 'b',
        label: 'Branch B',
        builder: _branchB,
        position: Offset(640, 380),
      ),
    ],
    edges: [
      StoryEdge(from: 'start', to: 'a', label: 'Sign up'),
      StoryEdge(from: 'start', to: 'b', label: 'Sign in'),
      StoryEdge(from: 'b', to: 'start', label: 'Back'), // cycle
    ],
  ),
];

// Top-level functions keep the registry `const` (closures/tear-offs aren't const).
WelcomeScreen _welcome(BuildContext context) => const WelcomeScreen();
PlaceholderScreen _branchA(BuildContext context) =>
    const PlaceholderScreen(title: 'Branch A', subtitle: 'Sign up path');
PlaceholderScreen _branchB(BuildContext context) =>
    const PlaceholderScreen(title: 'Branch B', subtitle: 'Sign in path');
