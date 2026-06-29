import 'package:flutter/material.dart';
import 'package:vasc_pro/dev/library/canvas_stage.dart';
import 'package:vasc_pro/dev/library/device_frame.dart';
import 'package:vasc_pro/dev/library/library_models.dart';
import 'package:vasc_pro/dev/storyboard/storyboards.dart';

/// Builds the "Storyboards" section: one entry per storyboard in [kStoryboards],
/// each rendered as a horizontal row of side-by-side iPhone device frames (one
/// frame per step in the flow). The storyboard data is the single source of
/// truth — frames render their real screens in the user's own theme.
LibrarySection storyboardsSection() {
  final entries = <LibraryEntry>[];
  for (var i = 0; i < kStoryboards.length; i++) {
    final sb = kStoryboards[i];
    entries.add(
      LibraryEntry(
        id: 'sb-$i',
        label: sb.title,
        icon: Icons.dashboard_outlined,
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CanvasHeader(
                  title: sb.title,
                  subtitle: '${sb.frames.length} '
                      '${sb.frames.length == 1 ? 'frame' : 'frames'}',
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final frame in sb.frames) ...[
                        DeviceFrame(
                          label: frame.label,
                          child: frame.builder(context),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  return LibrarySection(title: 'Storyboards', entries: entries);
}
