import 'package:flutter/material.dart';
import 'package:vasc_pro/dev/library/canvas_stage.dart';
import 'package:vasc_pro/dev/library/device_frame.dart';
import 'package:vasc_pro/dev/library/library_models.dart';
import 'package:vasc_pro/dev/library/workbench_theme.dart';
import 'package:vasc_pro/dev/storyboard/storyboard_models.dart';
import 'package:vasc_pro/dev/storyboard/storyboards.dart';

/// The "App" section — the INHERITANCE layer. It reads the SAME [kStoryboards]
/// data as the Storyboards section, but instead of laying every frame out side
/// by side, it lets you walk a single storyboard interactively inside one
/// iPhone frame (Next/Back), as if you were using the live build.
LibrarySection appSection() {
  final entries = <LibraryEntry>[];
  for (var i = 0; i < kStoryboards.length; i++) {
    final sb = kStoryboards[i];
    entries.add(
      LibraryEntry(
        id: 'app-$i',
        label: sb.title,
        icon: Icons.phone_iphone,
        builder: (context) => _AppWalkthrough(storyboard: sb),
      ),
    );
  }
  return LibrarySection(title: 'App', entries: entries);
}

class _AppWalkthrough extends StatelessWidget {
  const _AppWalkthrough({required this.storyboard});

  final Storyboard storyboard;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CanvasHeader(title: storyboard.title, subtitle: 'Walk through the build'),
          Center(child: _Walker(frames: storyboard.frames)),
        ],
      ),
    );
  }
}

/// Holds the current frame index and renders one [DeviceFrame] plus stealth Next
/// / Back controls beneath it.
class _Walker extends StatefulWidget {
  const _Walker({required this.frames});

  final List<Frame> frames;

  @override
  State<_Walker> createState() => _WalkerState();
}

class _WalkerState extends State<_Walker> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final frames = widget.frames;
    if (frames.isEmpty) {
      return Text('No frames in this storyboard.', style: Workbench.entryLabel);
    }

    final frame = frames[_index];
    final atStart = _index == 0;
    final atEnd = _index == frames.length - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DeviceFrame(child: frame.builder(context)),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavButton(
              label: 'Back',
              onPressed: atStart ? null : () => setState(() => _index--),
            ),
            const SizedBox(width: 20),
            Text(
              '${_index + 1} / ${frames.length}  ·  ${frame.label}',
              style: Workbench.entryLabel,
            ),
            const SizedBox(width: 20),
            _NavButton(
              label: 'Next',
              onPressed: atEnd ? null : () => setState(() => _index++),
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
