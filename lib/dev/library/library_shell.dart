import 'package:flutter/material.dart';
import 'library_models.dart';
import 'workbench_theme.dart';

/// The workbench: a left sidebar (stealth chrome) listing every section and its
/// entries, beside a canvas that renders the selected entry. The three sections
/// (Components / Storyboards / App) are just data — see library.dart.
class LibraryShell extends StatefulWidget {
  const LibraryShell({super.key, required this.sections});

  final List<LibrarySection> sections;

  @override
  State<LibraryShell> createState() => _LibraryShellState();
}

class _LibraryShellState extends State<LibraryShell> {
  late LibraryEntry _selected = widget.sections
      .firstWhere((s) => s.entries.isNotEmpty)
      .entries
      .first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Workbench.bg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Sidebar(
            sections: widget.sections,
            selectedId: _selected.id,
            onSelect: (e) => setState(() => _selected = e),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Workbench.border),
          Expanded(
            child: Container(
              color: Workbench.bg,
              child: KeyedSubtree(
                key: ValueKey(_selected.id),
                child: _selected.builder(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.sections,
    required this.selectedId,
    required this.onSelect,
  });

  final List<LibrarySection> sections;
  final String selectedId;
  final ValueChanged<LibraryEntry> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Workbench.sidebarWidth,
      color: Workbench.sidebarBg,
      child: SafeArea(
        right: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            for (var i = 0; i < sections.length; i++) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(20, i == 0 ? 22 : 26, 20, 10),
                child: Text(
                  sections[i].title.toUpperCase(),
                  style: Workbench.sectionHeader,
                ),
              ),
              for (final entry in sections[i].entries)
                _SidebarItem(
                  entry: entry,
                  selected: entry.id == selectedId,
                  onTap: () => onSelect(entry),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final LibraryEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final bg = selected
        ? Workbench.surfaceSelected
        : (_hovered ? Workbench.surfaceHover : Colors.transparent);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: selected ? Workbench.border : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.entry.icon,
                size: 16,
                color: selected ? Workbench.text : Workbench.textMuted,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  widget.entry.label,
                  style: selected
                      ? Workbench.entryLabelSelected
                      : Workbench.entryLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
