# Roles (who/what does what)

- **First chat (Project Organization):** single source for strategy, decisions, ADRs, and high-level coordination. Keep it open and don’t use it for large code diffs.
- **New chat per ticket:** implementation work + quick Q&A for that ticket (one ticket = one chat). Title the chat with the ticket id (e.g., `S02 — Router & Shell`).
- **Cursor (GPT-5):** heavy lifting code generation, iterative edits, and local testing. Use it for creating files/PR branches, then bring diffs back into the ticket chat for review.
- **GitHub / PRs:** canonical code history, CI runs, code review, and merging. Every ticket produces one PR.

# Concrete, repeatable workflow

1. **Plan in this chat** — decide scope and acceptance criteria for the ticket. Write checklist items and required files. Update `ORDER_OF_OPERATIONS.md`/`AGENTS.md` if needed.
2. **Open ticket chat** (new chat in project) titled `Sxx — short`: paste a 1-line scope + checklist + link to canvas docs. Use the ticket template (below).
3. **Generate code in Cursor** (GPT-5) or locally: create a feature branch `feat/Sxx-short`. Run local tests.
4. **Push branch & open PR** with checklist and small runnable diff. Trigger CI.
5. **Review in ticket chat**: paste PR link, ask for a concise code review + test plan. Iterate until green.
6. **Merge** when CI passes and you’re happy. Update `DECISIONS.md` with any ADRs. Close ticket chat or mark it resolved.
7. **Return to planning chat** for next ticket or retrospection.

# Naming & deliverable conventions (keeps context tight)

- **Branch:** `feat/Sxx-brief` or `fix/Sxx-brief`
- **PR title:** `Sxx: brief description`
- **Ticket chat title:** `Sxx — brief`
- **Commit message:** `feat: Sxx brief`
- **PR description must include:** checklist, commands to run, failing/passing tests, and one-paragraph learning recap.

# Ticket-chat starter template (copy/paste)

```
Ticket: Sxx — <short title>
Refs: ORDER_OF_OPERATIONS.md, STACK.md, nav_arch_plan.md
Scope: <1-2 sentence scope>
Checklist:
- [ ] create files: lib/...
- [ ] wire go_router routes
- [ ] unit test: ...
Deliverables: full file contents or unified patch, commands to run, test plan, 60s recap
Branch: feat/Sxx-brief

```

# How to use Cursor vs ticket chat

- **Cursor (GPT-5):** generate & iterate code, run unit tests locally. When done, copy the final patch into the ticket chat and push branch/PR. Don’t skip local tests.
- **Ticket chat:** final review, QA, and PR conversation. Keep everything reproducible (commands + env sample).

# Anti-context-rot rules (practical)

- Always include the **ticket id** in the first line of any prompt/chat.
- Always link to the canvas doc(s) being referenced.
- Keep patches **small** (one feature per PR). If >10 files, split into smaller tickets.
- After any architecture change, write a 1-paragraph ADR in `DECISIONS.md` immediately.

# Quick CI / testing expectations

- PR must run `flutter analyze` + `flutter test`.
- If feature affects UI, add at least one unit/widget test or a short test plan in PR description.
- Use GitHub Actions for gating merges.

# Daily practice tips (keeps momentum)

- Start each Cursor/chat session with the 1-line ticket header and the branch name.
- After generating code, run `fvm flutter test` and `fvm flutter analyze` before opening a PR.
- For multi-step tickets, create a `/play/` branch for prototypes; only move to main feature branch after approval + ADR if needed.

# One last minimal checklist for you to copy into a pinned note

- This planning chat = gameplan + ADRs.
- New chat per ticket (Sxx).
- Cursor for code generation; always test locally.
- One PR per ticket; CI green before merge.
- Update `DECISIONS.md` for big changes.
