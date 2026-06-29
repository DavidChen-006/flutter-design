import 'package:flutter/material.dart';
import 'workbench_theme.dart';

/// Sleek stealth header at the top of a canvas page: mono title, muted subtitle,
/// and a hairline divider to separate the chrome from the content below.
class CanvasHeader extends StatelessWidget {
  const CanvasHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Workbench.canvasTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 7),
          Text(subtitle!, style: Workbench.canvasSubtitle),
        ],
        Container(
          height: 1,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20, bottom: 28),
          color: Workbench.border,
        ),
      ],
    );
  }
}

/// Hosts a component's variants directly on the dark canvas — no panel, no white
/// box. Constrains to phone width so primitives preview at app width.
class ComponentStage extends StatelessWidget {
  const ComponentStage({super.key, required this.child, this.width = 393});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}
