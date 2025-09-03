# Navigation & Architecture Plan (v0)

**Purpose:** minimal, extendable navigation and responsive scaffolds for the template.

---

## App flow

`Auth (email+password)` → `Onboarding` → `Dashboard`

### Onboarding (role-aware)

- **Role selection:** Admin | Client (single sign-in screen chooses role).
- **Admin flow:** provide `profile name`, `studio name`, `phone`, `bio`. On success, a permanent **join code** is created for the studio. Admin can regenerate a new join code from Settings.
- **Client flow:** provide `profile name`, `age`, `phone`. Prompted for a **join code** but NOT required. Clients can use the app without joining a studio; they can enter a join code later from Settings to join a studio.

---

## Data / Security (high level)

- **Studios** own clients. Data is isolated by `studio_id`.
- **Roles:** Admin, Client (extendable). Role and studio linkage stored in `profiles`/`users` in Supabase.
- **Access control:** server-side RLS enforces isolation. Client-side checks only affect UX; server is authoritative.
- **Permissions:** template supports flexible read/write rules — implement per-table RLS or claim-driven checks depending on feature needs.

---

## Main routes & screens

- `/auth` — sign-in / role select
- `/onboarding` — role-specific onboarding forms
- `/dashboard` — main shell
  - Tabs (bottom nav on mobile):
    1. **Home** (Dashboard)
    2. **Placeholder A**
    3. **Placeholder B**
  - App bar: left avatar button → `/profile`; right settings icon → `/settings`
- `/profile` — edit profile (avatar upload optional)
- `/settings` — regenerate join code (admins), enter join code (clients), other app settings

---

## Navigation behavior

- **Mobile:** BottomNavigationBar with 3 tabs. App bar with avatar (left) and settings (right).
- **Tablet:** Prefer a hamburger menu → drawer, or persistent bottom bar depending on width; keep header actions visible.
- **Desktop:** Side nav (left) with persistent content area; header actions in top-right corner.

Note: scaffolds are separate components (SmartphoneScaffold, TabletScaffold, DesktopScaffold) that share the same route names and page widgets.

---

## Avatar UX

- Default: initial-circle placeholder (initials).
- Optional: user can upload image (Supabase Storage). Upload is optional and not required to use app.
- Image avatars can be added once they reach the dashboard after completing onboarding

---

## Join code rules

- **Permanent code** per studio by default.
- Admins may regenerate code in Settings (new code replaces old). Implement regeneration with confirmation dialog.
- Clients may enter code in onboarding or later in Settings to link to a studio.

---

## Minimal responsive rules (v0)

- Implement simple breakpoints:
  - **Phone:** width < 600 — mobile scaffold
  - **Tablet:** 600 ≤ width < 1024 — tablet scaffold
  - **Desktop:** width ≥ 1024 — desktop scaffold
- Keep scaffolds intentionally minimal; expand when implementing specific features.
