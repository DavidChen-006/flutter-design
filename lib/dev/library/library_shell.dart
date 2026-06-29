import 'package:flutter/material.dart';
import 'library_models.dart';
import 'workbench_theme.dart';

/// The workbench: a left sidebar (stealth chrome) listing every section and its
/// entries, beside a canvas that renders the selected entry. The three sections
/// (Components / Storyboards / App) are just data — see library.dart.
///
/// Entries can NEST: an entry with [LibraryEntry.children] renders as an
/// expandable row (Photoshop-layers style) whose children sit indented beneath
/// it, revealing a composite component's sub-components.
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

  // Ids of entries currently expanded. Default: everything with children is
  // expanded, so the nested structure is visible out of the box.
  late final Set<String> _expanded = _collectExpandable();

  Set<String> _collectExpandable() {
    final ids = <String>{};
    void walk(LibraryEntry e) {
      if (e.children.isNotEmpty) {
        ids.add(e.id);
        for (final c in e.children) {
          walk(c);
        }
      }
    }

    for (final section in widget.sections) {
      for (final e in section.entries) {
        walk(e);
      }
    }
    return ids;
  }

  void _toggle(String id) => setState(() {
        if (!_expanded.remove(id)) _expanded.add(id);
      });

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
            expanded: _expanded,
            onSelect: (e) => setState(() => _selected = e),
            onToggle: _toggle,
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
    required this.expanded,
    required this.onSelect,
    required this.onToggle,
  });

  final List<LibrarySection> sections;
  final String selectedId;
  final Set<String> expanded;
  final ValueChanged<LibraryEntry> onSelect;
  final ValueChanged<String> onToggle;

  /// Flattens an entry (and, if expanded, its children) into a list of rows,
  /// each tagged with its nesting depth for indentation.
  List<Widget> _rows(LibraryEntry entry, int depth) {
    final hasChildren = entry.children.isNotEmpty;
    final isExpanded = expanded.contains(entry.id);
    return [
      _SidebarItem(
        entry: entry,
        depth: depth,
        selected: entry.id == selectedId,
        hasChildren: hasChildren,
        expanded: isExpanded,
        onTap: () => onSelect(entry),
        onToggle: () => onToggle(entry.id),
      ),
      if (hasChildren && isExpanded)
        for (final child in entry.children) ..._rows(child, depth + 1),
    ];
  }

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
              for (final entry in sections[i].entries) ..._rows(entry, 0),
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
    required this.depth,
    required this.selected,
    required this.hasChildren,
    required this.expanded,
    required this.onTap,
    required this.onToggle,
  });

  final LibraryEntry entry;
  final int depth;
  final bool selected;
  final bool hasChildren;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onToggle;

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
    // Indent children; the disclosure slot keeps icons aligned across siblings.
    final leftInset = 12.0 + widget.depth * 14.0;

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
          padding: EdgeInsets.only(
            left: leftInset,
            right: 12,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: selected ? Workbench.border : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Disclosure triangle (only for entries with children); fixed-width
              // slot so leaf rows keep their icon aligned with parents.
              SizedBox(
                width: 18,
                child: widget.hasChildren
                    ? GestureDetector(
                        onTap: widget.onToggle,
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedRotation(
                          turns: widget.expanded ? 0.25 : 0.0,
                          duration: const Duration(milliseconds: 120),
                          child: const Icon(
                            Icons.chevron_right,
                            size: 15,
                            color: Workbench.textMuted,
                          ),
                        ),
                      )
                    : null,
              ),
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
