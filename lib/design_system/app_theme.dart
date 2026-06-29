import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// LAYER 1 — ThemeData assembled from the design tokens.
///
/// Applied once at the MaterialApp root so Flutter's built-in widgets inherit
/// the same palette and typography as the custom components.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        textTheme: const TextTheme(
          titleLarge: AppTypography.title,
          titleMedium: AppTypography.heading,
          bodyMedium: AppTypography.body,
          labelLarge: AppTypography.label,
          bodySmall: AppTypography.caption,
        ),
      );
}
