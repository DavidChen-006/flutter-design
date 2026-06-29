import 'package:flutter/material.dart';
import '../../features/welcome/welcome_screen.dart';
import 'storyboard_models.dart';

/// LAYER 3 — The storyboard REGISTRY.
///
/// This is where you map out every path your app can go down, frame by frame.
/// Start with the flows you know exist (onboarding, sign-in, settings...) and
/// add to them as you build. Each frame references a REAL screen, so the
/// storyboard always reflects production.
///
/// HOW TO ADD A NEW PATH:
///   1. Build the screen in `lib/features/<flow>/<screen>.dart` using ONLY
///      widgets from lib/components/ (which use ONLY lib/design_system/ tokens).
///   2. Add a Frame here:  Frame(label: 'Step name', builder: (_) => YourScreen())
///   3. It now appears in the Storyboard tab AND reuses the exact production code.
const List<Storyboard> kStoryboards = [
  Storyboard(
    title: 'Example flow',
    frames: [
      Frame(label: 'Welcome', builder: _welcome),
      // Add the next frames of this path here as you build them, e.g.:
      // Frame(label: 'Sign up', builder: (_) => SignUpScreen()),
      // Frame(label: 'Profile', builder: (_) => ProfileScreen()),
    ],
  ),
  // Add more storyboards (paths) here, e.g. Storyboard(title: 'Settings', ...).
];

// A top-level function keeps the registry `const` (closures/tear-offs aren't const).
WelcomeScreen _welcome(BuildContext context) => const WelcomeScreen();
