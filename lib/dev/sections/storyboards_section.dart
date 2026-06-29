import 'package:flutter/material.dart';
import 'package:vasc_pro/dev/library/canvas_stage.dart';
import 'package:vasc_pro/dev/library/device_frame.dart';
import 'package:vasc_pro/dev/library/inspectable.dart';
import 'package:vasc_pro/dev/library/library_models.dart';
import 'package:vasc_pro/dev/storyboard/storyboards.dart';

/// The "Storyboards" section is a SINGLE tab. Selecting it shows every storyboard
/// at once — one iPhone frame per storyboard, each labeled above with the
/// storyboard's name, laid out in a wrapping grid so you can see them all
/// together. Hover any component inside a frame to reveal its type name.
LibrarySection storyboardsSection() {
  return LibrarySection(
    title: 'Storyboards',
    entries: [
      LibraryEntry(
        id: 'sb-all',
        label: 'All Screens',
        icon: Icons.grid_view,
        builder: _allScreens,
      ),
    ],
  );
}

Widget _allScreens(BuildContext context) {
  // One iPhone frame per storyboard, using its first screen, labeled with the
  // storyboard's name (shown above the frame by DeviceFrame).
  final frames = <Widget>[
    for (final sb in kStoryboards)
      if (sb.frames.isNotEmpty)
        DeviceFrame(
          label: sb.title,
          // This is the only place hover-inspection is enabled.
          child: InspectScope(child: sb.frames.first.builder(context)),
        ),
  ];

  return SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CanvasHeader(
          title: 'Storyboards',
          subtitle: '${frames.length} '
              '${frames.length == 1 ? 'screen' : 'screens'} · '
              'hover a component to see its name',
        ),
        Wrap(spacing: 40, runSpacing: 40, children: frames),
      ],
    ),
  );
}
