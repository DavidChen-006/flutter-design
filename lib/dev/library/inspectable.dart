import 'package:flutter/material.dart';
import 'workbench_theme.dart';

/// Workbench helper: wraps a component so HOVERING it reveals its type name,
/// letting you point at exactly which component you want changed. It's purely a
/// hover tooltip — no effect on layout, taps, or the screen's own behaviour, so
/// it's safe to leave around the production widgets.
class Inspectable extends StatelessWidget {
  const Inspectable(this.child, {super.key, this.name});

  final Widget child;

  /// Optional explicit name; defaults to the child's runtime type
  /// (e.g. `StressCard`).
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: name ?? child.runtimeType.toString(),
      waitDuration: const Duration(milliseconds: 120),
      preferBelow: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Workbench.sidebarBg,
        border: Border.all(color: Workbench.borderStrong),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(
        fontFamilyFallback: ['Menlo', 'SFMono-Regular', 'monospace'],
        fontSize: 12,
        color: Workbench.text,
      ),
      child: child,
    );
  }
}
