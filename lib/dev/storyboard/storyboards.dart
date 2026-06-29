import 'package:flutter/widgets.dart';
import '../../features/_demo/placeholder_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import 'storyboard_models.dart';

/// LAYER 3 — The board REGISTRY.
///
/// Each [Board] is a storyboard modeled as a directed graph: nodes are iPhone
/// frames placed at x,y positions, edges are the directed transitions between
/// them. Flows can branch and loop — they are NOT forced to be linear.
///
/// HOW TO ADD / SHAPE A FLOW:
///   1. Build the screen in `lib/features/<flow>/<screen>.dart`.
///   2. Add a `StoryNode(id, label, builder, position)` to a board's `nodes`.
///   3. Connect it with `StoryEdge(from, to, label)` entries — branch by adding
///      several edges out of one node; loop back by pointing an edge at an
///      earlier node. Drag/zoom the board to read the graph.
const List<Board> kBoards = [
  Board(
    title: 'Example Flow',
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
