import 'package:flutter/material.dart';

/// LAYER 3 — Storyboard data model.
///
/// A [Storyboard] is one path/flow through the app (e.g. "Onboarding",
/// "Compliance"). Each [Frame] is one screen in that path. A frame's [builder]
/// returns a REAL production widget — the storyboard never re-creates screens,
/// it points at them.
class Frame {
  const Frame({required this.label, required this.builder});

  final String label;
  final WidgetBuilder builder;
}

class Storyboard {
  const Storyboard({required this.title, required this.frames});

  final String title;
  final List<Frame> frames;
}
