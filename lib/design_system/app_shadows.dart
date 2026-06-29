import 'package:flutter/material.dart';

/// LAYER 1 — Design tokens: soft neumorphic shadows for the Bevel cards.
///
/// White cards on the grey canvas lift via a soft, large, low-opacity shadow
/// (no harsh edges). Used by every card/pill so elevation stays consistent.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> pill = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 14,
      spreadRadius: -3,
      offset: Offset(0, 6),
    ),
  ];
}
