### ADR-002 — Router & Shell (2025-09-03)

Decision: Use `go_router` with a Riverpod-provided `routerProvider` and a simple ShellRoute-based AppShell that provides a responsive shell (NavigationRail on wide screens, BottomNavigationBar on narrow screens). Rationale: keeps routing declarative, testable, and enables nested routes while using Riverpod for runtime provider access and easy state-driven route changes.

### ADR-003 — Theme & Tokens (2025-09-03)

Decision: Adopt Material 3 theming with explicit tokenized colors. We define brand and surface tokens in `lib/theme/app_colors.dart` (derived from the color reference) and construct `ColorScheme`s directly for light and dark modes (`app_theme_light.dart`, `app_theme_dark.dart`) to preserve intended brand colors and ensure contrast. `AppTheme.light()` and `AppTheme.dark()` expose the `ThemeData`s. Rationale: explicit tokens keep color usage consistent, testable, and resilient to future palette changes while aligning with Material 3.
