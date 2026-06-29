import '../sections/app_section.dart';
import '../sections/components_section.dart';
import '../sections/storyboards_section.dart';
import 'library_models.dart';

/// THE workbench, declared in one place. Order = Components (top), Storyboards
/// (middle), App (bottom). Each section is a registry you extend by adding
/// entries inside its `*_section.dart` file — the shell renders whatever is here.
List<LibrarySection> buildLibrarySections() => [
      componentsSection(),
      storyboardsSection(),
      appSection(),
    ];
