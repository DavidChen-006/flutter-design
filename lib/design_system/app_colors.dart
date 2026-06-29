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
}
