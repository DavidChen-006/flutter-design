import 'package:flutter/material.dart';

/// LAYER 1 — Design tokens: colors.
///
/// Single source of truth for color. Every component reads from here; nothing
/// hard-codes a Color literal. Change a value here and it propagates to the
/// Gallery, the Storyboard, and the live app simultaneously.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryPressed = Color(0xFF1D4ED8);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFDC2626);

  // ── Bevel home-screen palette (neumorphic light health dashboard) ──────────
  static const Color canvas = Color(0xFFECECEE); // app background (cool grey)
  static const Color card = Color(0xFFFFFFFF); // white cards
  static const Color cardAlt = Color(0xFFF5F5F7); // inset / track surfaces

  static const Color ink = Color(0xFF1A1A1C); // primary text
  static const Color inkSecondary = Color(0xFF8A8A8E); // secondary grey
  static const Color inkTertiary = Color(0xFFB6B6BB); // faint grey / placeholders
  static const Color hairline = Color(0xFFE6E6E9); // dividers / ring tracks

  static const Color accentOrange = Color(0xFFF2994A); // warnings, energy, strain
  static const Color accentGreen = Color(0xFF5BD08A); // active / live status
  static const Color avatarBlue = Color(0xFFBFD7EA); // avatar chip fill
}
