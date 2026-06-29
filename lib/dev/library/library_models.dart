import 'package:flutter/widgets.dart';

/// Generalized "library" model shared by all three workbench sections
/// (Components, Storyboards, App). Each section is just a [LibrarySection]
/// holding a list of [LibraryEntry] — adding a custom part means appending an
/// entry to the relevant registry. The sidebar and canvas treat every entry the
/// same way, regardless of which section it belongs to.
class LibraryEntry {
  const LibraryEntry({
    required this.id,
    required this.label,
    required this.icon,
    required this.builder,
    this.children = const [],
  });

  /// Stable unique id (used as the selection key in the shell).
  final String id;

  /// Label shown in the sidebar.
  final String label;

  /// Sidebar icon.
  final IconData icon;

  /// Builds the main-canvas content when this entry is selected.
  final WidgetBuilder builder;

  /// Optional nested child entries, shown indented beneath this entry in the
  /// sidebar (Photoshop-layers style). Lets a composite component reveal the
  /// sub-components it is built from — e.g. a nav bar expands into its buttons.
  final List<LibraryEntry> children;
}

class LibrarySection {
  const LibrarySection({required this.title, required this.entries});

  /// Rendered as the uppercase mono group header in the sidebar.
  final String title;

  final List<LibraryEntry> entries;
}
