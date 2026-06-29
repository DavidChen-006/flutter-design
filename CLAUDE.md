# Scaffold conventions

This repo is a reusable **Flutter design-system workbench**. Apps are created by
copying it; this file is inherited at copy-time and tells any agent how to build
on the scaffold. Follow it.

## 1. What this is

A desktop/mobile Flutter app whose root (`lib/app.dart` → `LibraryShell`) is a
left **sidebar + canvas** workbench with three sections:

- **Components** — every UI component, previewed in isolation.
- **Storyboards** — each storyboard rendered as a pan/zoom graph of iPhone frames.
- **App** — walk a storyboard's flow interactively in one frame.

Two design worlds that must NOT bleed into each other:

- **Tool chrome** — the workbench itself (`lib/dev/library/**`), styled with the
  xAI-stealth `Workbench` tokens (`lib/dev/library/workbench_theme.dart`).
- **The app** — the user's product: `lib/components/**`, `lib/design_system/**`,
  `lib/features/**`. Never restyle the user's components to match the tool, and
  never leak `Workbench` tokens into app components.

## 2. Component rules

Components live in `lib/components/`, one public widget per file, and are
registered in `lib/dev/sections/components_section.dart`.

- **Fine-grained decomposition — decompose to the interactive leaf.** Any
  tappable sub-element is its OWN public component. A nav bar is built from
  `NavButton` components; a row is built from its chips/cells as components.
  Composites compose *instances* of child components — never private inline
  `_Foo` widgets for things a user could point at, restyle, or reuse.

- **Press feedback — wrap every tap target in `Pressable`**
  (`lib/components/pressable.dart`). It animates on press (a scale dip) so the
  component visibly responds when clicked, even if the tap leads nowhere — this
  makes every component demonstrable in the gallery. Do NOT use a bare
  `GestureDetector`/`InkWell` as a component's primary tap.

- **Tokens only.** Read all color/spacing/typography/shadow from
  `lib/design_system/` (`AppColors`, `AppTypography`, `AppSpacing`,
  `AppShadows`). Never hardcode hex colors, paddings, radii, or text styles in a
  component.

- **Nesting — declare parent→child structure.** A composite registers its child
  components via `LibraryEntry.children`, so the sidebar shows the component tree
  (Photoshop-layers style: expand a "Nav Bar" entry to reveal its buttons).

### Registering a component

```dart
LibraryEntry(
  id: 'cmp-nav-bar',
  label: 'Nav Bar',
  icon: Icons.dock,
  builder: (_) => /* showcase of NavBar */,
  children: [
    LibraryEntry(id: 'cmp-nav-button', label: 'Nav Button', icon: Icons.crop_square,
                 builder: (_) => /* showcase of NavButton */),
  ],
)
```

## 3. Design tokens

`lib/design_system/` is the single source of truth for the app's look:
`app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_shadows.dart`.
Change a token → every component updates. Extend these files for new app styles;
do not invent parallel constants inside components.

## 4. Storyboards are directed graphs

A storyboard is a **`Board`** (`lib/dev/storyboard/storyboard_models.dart`):

- **`StoryNode { id, label, builder, position }`** — one iPhone frame carrying a
  real screen, placed at an x,y position on the board.
- **`StoryEdge { from, to, label? }`** — a directed transition.
- **`BoardStyle { background, arrowColor, arrowWidth }`** — the board surface;
  prompt-controllable, separate from the frames.
- **`Board { title, nodes, edges, style }`** — the graph.

Flows **branch** (several edges out of a node) and **cycle** (an edge pointing
back) — they are NOT forced linear. Boards are defined in
`lib/dev/storyboard/storyboards.dart` as `kBoards`.

**The storyboard is the live MAP OF THE WHOLE APP.** Put EVERY real screen in as
a frame and connect the screens with arrows, so the board shows the entire
product and how its screens flow into each other at a glance. Prefer ONE board
(e.g. titled `App Flow`) holding ALL the app's frames — do NOT scatter screens
across separate one-frame boards with no arrows between them. Label each
`StoryEdge` with the action that triggers the transition, and add a back-edge for
return paths (a cycle):

```dart
const List<Board> kBoards = [
  Board(
    title: 'App Flow',
    nodes: [
      StoryNode(id: 'welcome', label: 'Welcome', builder: _welcome, position: Offset(0, 0)),
      StoryNode(id: 'home',    label: 'Home',    builder: _home,    position: Offset(640, 0)),
      StoryNode(id: 'profile', label: 'Profile', builder: _profile, position: Offset(1280, 0)),
    ],
    edges: [
      StoryEdge(from: 'welcome', to: 'home',    label: 'Get started'),
      StoryEdge(from: 'home',    to: 'profile', label: 'Profile tab'),
      StoryEdge(from: 'profile', to: 'home',    label: 'Home tab'), // back (cycle)
    ],
  ),
];
```

**The flow is the user's to define — ALWAYS ask the user how screens connect**
before wiring edges. Render is `BoardView` (pan/zoom canvas + arrows). Hovering a
component inside a board frame shows its type name (`InspectScope`/`Inspectable`),
and this hover-inspection is enabled ONLY inside the Storyboards section.

## 5. Single source of truth

`storyboards → screens → components (style ← lib/design_system) + copy (← lib/content)`.
Storyboards and the App walker render the SAME screen objects, so every frame is
a live instance of the defined components. A screen reads its **style** from the
design tokens (`lib/design_system/`) and its **copy** from the content layer
(`lib/content/`). Edit a token, a component, or a string once and it changes
everywhere it is used. Keep it that way: never fork a component's code into a
screen, and never hardcode copy into a screen (see §6).

## 6. Content is a single source of truth

`lib/content/` is the single source of truth for the app's user-facing **copy**
(text, labels, data) — exactly as `lib/design_system/` is for style. Copy is
plain Dart const objects (NO json / i18n / localization framework), grouped by
screen/feature, with the same shape as the design tokens. A screen reads its
text from there:

```dart
Text(AppContent.welcome.title, style: AppTypography.title);
```

Rules:

- **NEVER hardcode copy in a screen.** No user-facing string literals in
  `lib/features/**`; add the string to a content class and reference it.
- **One content class per screen/feature**, exposed as a `const` instance on
  `AppContent` (e.g. `AppContent.welcome`) with `final String` fields. Mirror
  `lib/design_system/`: add a `lib/content/<feature>_content.dart`, then expose
  it on `AppContent` in `lib/content/app_content.dart`.
- **Components stay generic — copy is a PARAMETER, never baked in.** A component
  takes its text via constructor args (`OptionCard(title: ...)`); the screen
  passes the value from `lib/content/`. Baking copy into a component would stop
  it being reusable N times for N different things.
- **Change once → reflects everywhere.** Editing a string in `lib/content/`
  updates the live app AND every storyboard frame, because storyboards render
  the same screens.

## 7. How to use

- **Add a component** — create `lib/components/<name>.dart` (token-driven, tap
  target wrapped in `Pressable`); register it in `components_section.dart`; if it
  is composite, extract its interactive children as their own components and list
  them under `children`.
- **Add a screen** — create `lib/features/<flow>/<screen>.dart`, composed only
  from `lib/components/`, reading style from `lib/design_system/` and copy from
  `lib/content/` (never hardcode strings — see §6).
- **Add copy** — add a `final String` to the screen's content class in
  `lib/content/` (create `<feature>_content.dart` and expose it on `AppContent`
  for a new screen), then reference it as `AppContent.<feature>.<field>`.
- **Add / shape a board** — edit `kBoards` in `storyboards.dart`: add
  `StoryNode`s with positions and connect them with `StoryEdge`s. Ask the user
  for the flow.

## 8. Keep the base generic

This is the shared base scaffold. Do not commit app-specific screens, components,
or palettes here — those belong in the app repo that inherits this one. Only
general, reusable scaffold features belong in this repository.
