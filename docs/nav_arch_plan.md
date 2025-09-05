# Navigation & Architecture Plan (v1)

**Purpose:** minimal, extendable navigation with hard separation of Admin and Client experiences after onboarding.

---

## App flow

`Auth (email+password)` → `Onboarding` → role-specific app:

- Admin → `/admin/home`
- Client → `/client/home`

---

## Route namespaces

Public (shared):

- `/auth` — sign-in (may present role choice if needed)
- `/onboarding` — collects role-specific profile fields

Admin app (isolated):

- `/admin` — shell (AdminAppShell)
  - `/admin/home`
  - `/admin/profile`
  - `/admin/settings`

Client app (isolated):

- `/client` — shell (ClientAppShell)
  - `/client/home`
  - `/client/profile`
  - `/client/settings`

Legacy/compat (temporary redirects only):

- `/` → redirect to role home when signed in (admin → `/admin/home`, client → `/client/home`)
- `/sign-in` → `/auth`
- `/dashboard` → role home (remove once code & links are updated)

---

## Routing guards

- Unauthenticated:
  - Any path → `/auth` (except already on `/auth`).
- Signed-in, not onboarded:
  - Any non-public path → `/onboarding`.
- Signed-in and onboarded:
  - Admin user: `/client/*` → redirect to `/admin/home`
  - Client user: `/admin/*` → redirect to `/client/home`
- Fallback: unknown routes → redirect to role home.

State sources:

- Auth status from AuthController.
- Onboarding completion + persisted role from onboardingProvider.

---

## Onboarding (role-aware)

- **Role selection:** Admin | Client
- **Admin flow:** provide `profile name`, `studio name`, `phone`, `bio`. On success, a permanent **join code** is created for the studio. Admin can regenerate a new join code from Settings.
- **Client flow:** provide `profile name`, `age`, `phone`. Prompted for a **join code** but NOT required. Clients can use the app without joining a studio; they can enter a join code later from Settings to join a studio.

---

## Data / Security (high level)

- **Studios** own clients. Data is isolated by `studio_id`.
- **Roles:** Admin, Client (extendable). Role and studio linkage stored in `profiles`/`users` in Supabase.
- **Access control:** server-side RLS enforces isolation. Client-side checks only affect UX; server is authoritative.
- **Permissions:** template supports flexible read/write rules — implement per-table RLS or claim-driven checks depending on feature needs.

---

## Navigation behavior

- **Mobile:** BottomNavigationBar per role shell (e.g., Home, Settings). App bar with avatar (left → `/profile`) and settings (right → `/settings`).
- **Tablet:** Drawer or bottom bar depending on width; keep header actions visible.
- **Desktop:** Side nav (left) with persistent content area; header actions in top-right corner.
- Breakpoints:
  - **Phone:** width < 600 — mobile scaffold
  - **Tablet:** 600 ≤ width < 1024 — tablet scaffold
  - **Desktop:** width ≥ 1024 — desktop scaffold

Note: `AdminAppShell` and `ClientAppShell` may share scaffold components (`SmartphoneScaffold`, `TabletScaffold`, `DesktopScaffold`) but are mounted under separate namespaces.

---

## Avatar UX

- Default: initial-circle placeholder (initials).
- Optional: user can upload image (Supabase Storage). Upload is optional and not required to use app.
- Image avatars can be added once they reach their role home after completing onboarding.

---

## Join code rules

- **Permanent code** per studio by default.
- Admins may regenerate code in Settings (new code replaces old). Implement regeneration with confirmation dialog.
- Clients may enter code in onboarding or later in Settings to link to a studio.
