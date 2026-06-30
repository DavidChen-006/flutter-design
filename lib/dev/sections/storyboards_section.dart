import 'package:flutter/material.dart';
import 'package:flutter_design/dev/library/board_view.dart';
import 'package:flutter_design/dev/library/library_models.dart';
import 'package:flutter_design/dev/library/workbench_theme.dart';
import 'package:flutter_design/dev/storyboard/storyboards.dart';

/// The "Storyboards" section: one entry per [Board]. Each renders the board as a
/// pan/zoom graph — positioned iPhone frames connected by directed arrows
/// (branches and cycles). Drag to pan, scroll to zoom, hover a frame's
/// components to see their names.
LibrarySection storyboardsSection() {
  final entries = <LibraryEntry>[];
  for (var i = 0; i < kBoards.length; i++) {
    final index = i;
    final board = kBoards[index];
    entries.add(
      LibraryEntry(
        id: 'board-$index',
        label: board.title,
        icon: Icons.account_tree_outlined,
        builder: (_) => _BoardCanvas(boardIndex: index),
      ),
    );
  }
  return LibrarySection(title: 'Storyboards', entries: entries);
}

class _BoardCanvas extends StatelessWidget {
  const _BoardCanvas({required this.boardIndex});

  final int boardIndex;

  @override
  Widget build(BuildContext context) {
    final board = kBoards[boardIndex];
    return Stack(
      children: [
        Positioned.fill(child: BoardView(board: board)),
        Positioned(
          top: 16,
          left: 20,
          child: IgnorePointer(
            child: Text(
              'drag to pan · scroll to zoom · hover a component to see its name',
              style: Workbench.canvasSubtitle,
            ),
          ),
        ),
      ],
    );
  }
}
