# STACK.md — Flutter Template (v0)

**Purpose:** Minimal, pragmatic stack for a local‑first Flutter app with roleed auth and Supabase sync.

## Frontend
- **Framework:** Flutter (stable via FVM)
- **State / DI:** flutter_riverpod
- **Navigation:** go_router

## Local-first / Sync
- **Local DB:** Drift (SQLite)
- **Sync engine:** PowerSync (Drift ↔ Supabase/Postgres)
- **Connectivity:** connectivity_plus
- **Background sync (optional):** workmanager / Flutter foreground service

## Backend / Auth / Data
- **BaaS:** Supabase (Auth, Postgres, Realtime)
- **Auth client:** supabase_flutter
- **Access control:** Postgres Row-Level Security (RLS) + studio_id checks

## HTTP / Networking / Logging
- **HTTP wrapper:** dio (used via ApiClient facade)
- **Logging:** logger

## Tooling
- **Codegen:** drift_dev, build_runner
- **Lints:** flutter_lints (+ small project overrides)
- **Versioning:** FVM (pin Flutter version)
- **CI (v0):** GitHub Actions: analyze + test

## Security notes (short)
- Enforce data isolation server-side with RLS; client only for UX.
- Never embed service_role keys in app binaries; use server middleware if needed.

## Optional / Future
- Analytics: Rudder/Firebase
- Hosted sync middleware (if complex sync rules needed)
- Mono-repo: Melos (if many packages)

---

*Keep this file tiny — expand with concrete versions and ADRs later.*

