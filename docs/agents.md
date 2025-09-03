# AGENTS.md — Project Orientation for Agents

**Purpose:** Give any agent (human or automated) the minimal orientation needed to contribute safely and predictably.

## Canonical docs (read first)

1. `STACK.md` — tech choices and libs
2. `nav_arch_plan.md` — routes, onboarding, join-code rules
3. `ORDER_OF_OPERATIONS.md` — ticket sequence and milestones
4. Project **Instructions** (ChatGPT project) — operational rules and delivery format

## Quick rules (short)

- **One ticket per PR.** Keep PRs small and runnable. Follow `S01…S12` sequence unless directed otherwise.
- **Deliverables per ticket:** checklist, patch/files (full file content), apply commands, test or test plan, 60‑sec learning recap. (See project Instructions.)
- **Branch & commit:** `feat/Sxx-<short>` or `fix/Sxx-<short>`. Commit message: `feat: Sxx <short description>`.
- **Files:** include exact file paths. Keep files minimal and commented.

## Coding & architecture constraints

- Use Riverpod + go\_router + Drift + PowerSync + Supabase by default (see `STACK.md`).
- Core lives in `lib/app`, `lib/core`, `lib/features`. Feature packs live separately.
- No production secrets committed. Use `env/dev.sample.json`; ignore `env/dev.json`.

## Auth & security

- Auth: email+password (Supabase). Roles: Admin, Client. Studios partition data via `studio_id`. Enforce via RLS on server. Client checks are UX only. See `nav_arch_plan.md`.

## Tests & CI

- Provide at least one unit/test per ticket or a clear test plan. Add GitHub Action for `flutter analyze` + `flutter test` where applicable.

## When in doubt

- Ask the user clarifying questions
- Choose the minimal, conservative option. Note new decisions as a one‑paragraph ADR in `DECISIONS.md`. Ask the user before changing the stack or adding major features.

---

*Keep this file tiny. Expand only when adding agent automation that needs more detail.*

