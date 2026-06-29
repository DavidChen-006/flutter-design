/// LAYER 0 — Content tokens: copy for the Welcome screen.
///
/// Single source of truth for the text rendered by
/// `lib/features/welcome/welcome_screen.dart`. Edit a string here and it updates
/// the live app AND the Welcome frame in the storyboard, because both render the
/// same `WelcomeScreen`.
class WelcomeContent {
  const WelcomeContent();

  final String title = 'Welcome';
  final String subtitle = 'Choose how you want to get started.';

  final String createAccountTitle = 'Create an account';
  final String createAccountSubtitle = 'Set up a new profile';

  final String signInTitle = 'Sign in';
  final String signInSubtitle = 'Continue with an existing account';

  final String continueLabel = 'Continue';
}
