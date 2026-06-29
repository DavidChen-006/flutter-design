/// LAYER 0 — Content tokens: copy for the example storyboard's demo frames.
///
/// Single source of truth for the placeholder text in the scaffold's example
/// "App Flow" board (`lib/dev/storyboard/storyboards.dart`): the frame captions,
/// the arrow (edge) labels, and the copy rendered inside the placeholder frames.
/// Replace these with your app's real screen copy when you build out the board.
class DemoBoardContent {
  const DemoBoardContent();

  /// Caption shown above the Welcome frame on the board.
  final String welcomeLabel = 'Welcome';

  // Branch A demo frame — caption/title, its subtitle, and the arrow that
  // leads to it.
  final String branchAName = 'Branch A';
  final String branchASubtitle = 'Sign up path';
  final String branchAEdge = 'Sign up';

  // Branch B demo frame — caption/title, its subtitle, and the arrow that
  // leads to it.
  final String branchBName = 'Branch B';
  final String branchBSubtitle = 'Sign in path';
  final String branchBEdge = 'Sign in';

  /// Label on the back-edge (the cycle that returns to Welcome).
  final String backEdge = 'Back';
}
