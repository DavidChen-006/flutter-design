import 'package:flutter/material.dart';

/// Monochrome "stealth" tokens for the WORKBENCH CHROME ONLY (sidebar, canvas,
/// section headers, device-frame bezel, entry list). Kept entirely separate from
/// the user's app design system (`lib/design_system/`) so the two never bleed
/// into each other. Direction: deep near-black, hairline borders, mono labels,
/// depth via contrast + spacing rather than shadows — Linear / Vercel / xAI.
class Workbench {
  Workbench._();

  // Palette ------------------------------------------------------------------
  static const Color bg = Color(0xFF0D0E11); // canvas, near-black
  static const Color sidebarBg = Color(0xFF09090B); // sidebar, a touch deeper
  static const Color text = Color(0xFFF5F5F7); // primary text
  static const Color textDim = Color(0xCCFFFFFF); // ~80%
  static const Color textMuted = Color(0x80FFFFFF); // 50%
  static const Color textFaint = Color(0x40FFFFFF); // 25% — section headers
  static const Color border = Color(0x12FFFFFF); // ~7% hairline
  static const Color borderStrong = Color(0x24FFFFFF); // ~14%
  static const Color surface = Color(0x0AFFFFFF); // ~4%
  static const Color surfaceHover = Color(0x14FFFFFF); // 8%
  static const Color surfaceSelected = Color(0x1FFFFFFF); // ~12%
  static const Color focusRing = Color(0x803B82F6); // blue 50%

  /// Legacy token (component stage no longer paints a panel). Kept transparent
  /// for back-compat with any callers.
  static const Color stage = Color(0x00000000);

  static const double sidebarWidth = 240;

  static const List<String> _mono = ['Menlo', 'SFMono-Regular', 'monospace'];

  // Typography ---------------------------------------------------------------
  static const TextStyle sectionHeader = TextStyle(
    fontFamilyFallback: _mono,
    fontSize: 11,
    color: textFaint,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle entryLabel = TextStyle(
    fontSize: 13.5,
    color: textDim,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle entryLabelSelected = TextStyle(
    fontSize: 13.5,
    color: text,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle canvasTitle = TextStyle(
    fontFamilyFallback: _mono,
    fontSize: 22,
    color: text,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle canvasSubtitle = TextStyle(
    fontSize: 13.5,
    height: 1.5,
    color: textMuted,
  );
}
