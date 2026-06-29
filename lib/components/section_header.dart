import 'package:flutter/material.dart';
import '../design_system/app_typography.dart';

/// LAYER 2 — Bevel primitive: a section header.
///
/// Bold, left-aligned section title that separates home-screen groups, e.g.
/// "Stress & Energy".
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppTypography.sectionTitle),
    );
  }
}
