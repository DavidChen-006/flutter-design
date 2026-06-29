import 'package:flutter/material.dart';
import '../../components/app_button.dart';
import '../../components/option_card.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../dev/library/inspectable.dart';

/// LAYER 3 — A real production screen, composed only from LAYER 2 primitives.
///
/// This SAME widget is rendered by the live app AND referenced as a frame in the
/// Storyboard registry (lib/dev/storyboard/storyboards.dart). Editing it updates
/// both places — the single-source-of-truth the video describes.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Welcome', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            Text('Choose how you want to get started.',
                style: AppTypography.caption),
            const SizedBox(height: AppSpacing.lg),
            Inspectable(
              OptionCard(
                title: 'Create an account',
                subtitle: 'Set up a new profile',
                selected: _selected == 0,
                onTap: () => setState(() => _selected = 0),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Inspectable(
              OptionCard(
                title: 'Sign in',
                subtitle: 'Continue with an existing account',
                selected: _selected == 1,
                onTap: () => setState(() => _selected = 1),
              ),
            ),
            const Spacer(),
            Inspectable(AppButton(label: 'Continue', onPressed: () {})),
          ],
        ),
      ),
    );
  }
}
