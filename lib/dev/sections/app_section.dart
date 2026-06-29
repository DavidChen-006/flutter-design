import 'package:flutter/material.dart';
import 'package:vasc_pro/dev/library/canvas_stage.dart';
import 'package:vasc_pro/dev/library/device_frame.dart';
import 'package:vasc_pro/dev/library/library_models.dart';
import 'package:vasc_pro/dev/library/workbench_theme.dart';
import 'package:vasc_pro/dev/storyboard/storyboard_models.dart';
import 'package:vasc_pro/dev/storyboard/storyboards.dart';

/// The "App" section walks a [Board]'s graph interactively in ONE iPhone frame:
/// start at the root node, then follow a button per outgoing edge (branches).
/// "Back" pops the navigation history, so cycles work too.
LibrarySection appSection() {
  final entries = <LibraryEntry>[];
  for (var i = 0; i < kBoards.length; i++) {
    final board = kBoards[i];
    entries.add(
      LibraryEntry(
        id: 'app-$i',
        label: board.title,
        icon: Icons.phone_iphone,
        builder: (context) => _AppWalkthrough(board: board),
      ),
    );
  }
  return LibrarySection(title: 'App', entries: entries);
}

class _AppWalkthrough extends StatelessWidget {
  const _AppWalkthrough({required this.board});

  final Board board;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CanvasHeader(
            title: board.title,
            subtitle: 'Walk the flow — follow a branch, or go back',
          ),
          Center(child: _Walker(board: board)),
        ],
      ),
    );
  }
}

/// Tracks the current node + a history stack, rendering the node in a
/// [DeviceFrame] with one stealth button per outgoing edge.
class _Walker extends StatefulWidget {
  const _Walker({required this.board});

  final Board board;

  @override
  State<_Walker> createState() => _WalkerState();
}

class _WalkerState extends State<_Walker> {
  late String _current = _rootId();
  final List<String> _history = [];

  String _rootId() {
    final board = widget.board;
    if (board.nodes.isEmpty) return '';
    final targets = board.edges.map((e) => e.to).toSet();
    return board.nodes
        .firstWhere((n) => !targets.contains(n.id),
            orElse: () => board.nodes.first)
        .id;
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;
    final node = board.nodeById(_current);
    if (node == null) {
      return Text('Empty board.', style: Workbench.entryLabel);
    }
    final outgoing = board.edges.where((e) => e.from == _current).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DeviceFrame(child: node.builder(context)),
        const SizedBox(height: 18),
        Text(node.label, style: Workbench.entryLabelSelected),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _NavButton(
              label: 'Back',
              onPressed: _history.isEmpty
                  ? null
                  : () => setState(() => _current = _history.removeLast()),
            ),
            for (final e in outgoing)
              _NavButton(
                label: e.label ?? board.nodeById(e.to)?.label ?? e.to,
                onPressed: () => setState(() {
                  _history.add(_current);
                  _current = e.to;
                }),
              ),
          ],
        ),
      ],
    );
  }
}

/// Sharp-cornered, transparent, white-bordered button matching the xAI stealth
/// chrome. Dims when disabled.
class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: enabled ? Workbench.borderStrong : Workbench.border,
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamilyFallback: const ['Menlo', 'SFMono-Regular', 'monospace'],
              fontSize: 13,
              letterSpacing: 1.4,
              color: enabled ? Workbench.text : Workbench.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
