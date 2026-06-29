import 'package:flutter/material.dart';
import 'workbench_theme.dart';

/// Marks a subtree where component hover-inspection is active. ONLY the
/// Storyboards section enables it, so hover labels appear there and nowhere else
/// — not the App walkthrough, not the Components page, not the live app.
class InspectScope extends InheritedWidget {
  const InspectScope({super.key, this.enabled = true, required super.child});

  final bool enabled;

  /// True only when an enabled [InspectScope] is an ancestor.
  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<InspectScope>();
    return scope?.enabled ?? false;
  }

  @override
  bool updateShouldNotify(InspectScope oldWidget) =>
      enabled != oldWidget.enabled;
}

/// Wraps a component so that — ONLY inside an enabled [InspectScope] (the
/// Storyboards section) — hovering it reveals its type name, letting you point
/// at exactly which component to change. Everywhere else it is a pure
/// pass-through with zero effect on layout, taps, or behaviour.
class Inspectable extends StatelessWidget {
  const Inspectable(this.child, {super.key, this.name});

  final Widget child;

  /// Optional explicit name; defaults to the child's runtime type
  /// (e.g. `StressCard`).
  final String? name;

  @override
  Widget build(BuildContext context) {
    if (!InspectScope.of(context)) return child;
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
