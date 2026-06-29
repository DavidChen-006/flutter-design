import 'package:flutter/material.dart';
import '../../components/biomarker_card.dart';
import '../../components/bottom_tab_bar.dart';
import '../../components/circle_icon_button.dart';
import '../../components/pill_button.dart';
import '../../components/radial_age_gauge.dart';
import '../../components/screen_title.dart';
import '../../components/section_header_action.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../dev/library/inspectable.dart';

/// LAYER 3 — The Bevel "Biological Age" (Biology) screen, composed from the
/// extracted Bevel components on the soft ambient gradient. Rendered live in the
/// App and as a frame in the "Biology" storyboard.
class BiologyScreen extends StatelessWidget {
  const BiologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          // Ambient gradient glow at the top (blue → cream), fading to canvas.
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 520,
            child: IgnorePointer(child: _AmbientGlow()),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                120,
              ),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Inspectable(
                    CircleIconButton(icon: Icons.more_horiz, onTap: () {}),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Inspectable(
                  ScreenTitle(
                    title: 'Biological Age',
                    subtitle: 'As of June 29',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Inspectable(
                  RadialAgeGauge(
                    value: '34.5',
                    minLabel: '29.5',
                    maxLabel: '39.5',
                    progress: 0.5,
                    center: PillButton(
                      label: 'Unlock with Pro',
                      icon: Icons.lock_outline,
                      onTap: () {},
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Inspectable(
                  SectionHeaderAction(
                    title: 'Other Biomarkers',
                    actionLabel: 'Edit',
                    onAction: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Inspectable(BiomarkerCard(title: 'Weight', unit: 'lbs')),
                const SizedBox(height: AppSpacing.sm),
                const Inspectable(
                  BiomarkerCard(title: 'HRV Baselines', unit: 'ms'),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Inspectable(
                  BiomarkerCard(title: 'RHR Baselines', unit: 'bpm'),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Inspectable(
                  BiomarkerCard(title: 'Body Fat Percentage', unit: '%'),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Inspectable(
                  BiomarkerCard(title: 'Lean Body Mass', unit: 'lbs'),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.md,
            child: SafeArea(
              top: false,
              child: Inspectable(
                BottomTabBar(currentIndex: 3, onTap: (_) {}, onAdd: () {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft diagonal blue→cream glow behind the title and dial, fading into the
/// grey canvas.
class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFD9E6F4).withValues(alpha: 0.9), // cool blue corner
            const Color(0xFFF3EFDD).withValues(alpha: 0.7), // warm cream
            AppColors.canvas.withValues(alpha: 0), // fade out
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}
