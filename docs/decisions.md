### ADR-002 — Router & Shell (2025-09-03)

Decision: Use `go_router` with a Riverpod-provided `routerProvider` and a simple ShellRoute-based AppShell that provides a responsive shell (NavigationRail on wide screens, BottomNavigationBar on narrow screens). Rationale: keeps routing declarative, testable, and enables nested routes while using Riverpod for runtime provider access and easy state-driven route changes.
