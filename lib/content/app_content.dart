import 'demo_board_content.dart';
import 'welcome_content.dart';

/// LAYER 0 — Content: the single source of truth for user-facing COPY.
///
/// Mirrors how `lib/design_system/` is the single source of truth for STYLE.
/// Screens read their text from here (e.g. `AppContent.welcome.title`) instead
/// of hardcoding string literals inline, so editing a string in ONE place
/// cascades to every screen AND every storyboard frame — storyboards render
/// those same screens.
///
/// Copy is grouped by screen/feature: one content class per feature, exposed as
/// a `const` instance below. Components stay generic — they keep taking copy as
/// constructor parameters; content is data passed in by the screen, never baked
/// into a component (so one component can be reused N times for N different
/// things).
class AppContent {
  AppContent._();

  /// Copy for the Welcome screen.
  static const WelcomeContent welcome = WelcomeContent();

  /// Copy for the example storyboard's placeholder/demo frames.
  static const DemoBoardContent demoBoard = DemoBoardContent();
}
