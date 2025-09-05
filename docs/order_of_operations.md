# ORDER_OF_OPERATIONS — template_v2

This document lists the canonical work tickets (S01…S12) and short checklists for each. Keep entries brief; use branches `feat/SXX-...` and one ticket per PR.

---

## S01 — Scaffold ✅ DONE
- Create Flutter app template
- .gitignore, env/dev.sample.json, README, basic folder layout

## S02 — Router & App Shell ✅ DONE
- Add go_router, AppShell, Home, Settings routes
- Responsive scaffolds

## S03 — State (Riverpod) ✅ DONE
- Add Riverpod setup and simple provider patterns
- Ensure providers are testable

## S04 — Theme & Tokens ✅ DONE
- Add tokenized light & dark themes
- Expose AppTheme.light() / AppTheme.dark()

### S04.1 — Auth skeleton (dev-safe) ✅ DONE
- SupabaseService singleton (init safe)
- AuthController (StateNotifier) that exposes AuthState
- SignIn screen (dev-safe) and router redirect to `/sign-in`

## S05 — Env Config & Local Supabase ✅ DONE
- env/dev.sample.json; main reads env/dev.json defensively
- Local Supabase instructions + docs/LOCAL_SUPABASE.md (dev-only)

## S06 — Logging & Global Error Handling
- Add `bootstrap.dart` using `runZonedGuarded` and a `Logger` abstraction
- Wire a pluggable error reporter (console by default)

## S07 — Local storage adapter (KeyValue v0)
- Add `KeyValueStore` interface and `SharedPrefsKeyValueStore` implementation
- Replace direct SharedPreferences usage with adapter where appropriate

## S08 — API client (stub)
- Add a simple ApiClient facade (dio or http) with a `BaseResponse` wrapper
- Keep it testable and injectable; no network calls in unit tests

## S09 — CI & Basic Tests ✅ DONE
- Add GitHub Actions workflow to run `flutter pub get`, `flutter analyze`, `flutter test` on PRs & pushes to `main`

## S10 — Example feature (end-to-end)
- Small CRUD feature that uses local persistence + optional server sync stub
- Serves as integration playground for routing, theming, auth, and storage

## S11 — Onboarding & Join Codes (design + implementation) ⚠️ DESIGN COMPLETE — IMPLEMENTATION PENDING

**Status:** The onboarding design (roles, admin/client flows, join-code behavior) is implemented in `nav_arch_plan.md`. The implementation ticket (S11) has been added to this document and remains to be implemented; see checklist below.
**Rationale:** The nav_arch_plan.md specifies role-aware onboarding and join-code behavior. This ticket implements that design so the app supports Admin and Client onboarding flows and studio linking.

Checklist (minimal MVP):
- [ ] Add `/onboarding` route and `OnboardingScreen` shell
- [ ] Add `lib/features/onboarding/admin_onboarding.dart` and `client_onboarding.dart` UI
- [ ] Implement `onboardingProvider` to hold role + form state
- [ ] Implement a `JoinCodeService` that can generate/verifiy join codes (local mock + Supabase implementation later)
- [ ] On Admin submit: create (or mock-create) a `studio` entity and persist a `join_code`; show code on success and expose regen in Settings
- [ ] On Client submit: accept a join code and link the `profile` to the `studio` (local mock for now)
- [ ] Add unit/widget tests that validate onboarding flows and join-code entry (mock Supabase or KeyValueStore as needed)

Notes:
- Treat server-side persistence (Supabase) as a later step; start with a local mock service so UI/tests remain deterministic.
- Ensure join codes are short, human-friendly (6–8 chars, alphanumeric) and unique in production via server checks.

## S12 — Local-first DB & Sync (Drift + PowerSync)
- Add Drift schema for local models and PowerSync scaffolding for syncing with Supabase
- Prioritize offline-first patterns and conflict resolution

---

### Change log
- 2025-09-04: Added explicit S11 ticket for Onboarding & Join Codes (implementation) to align ORDER_OF_OPERATIONS with nav_arch_plan.md and current repo progress.

---

*End of document.*

