# ORDER_OF_OPERATIONS — Zero → Template Complete (concise)

Purpose: minimal, safe progression from an empty machine to a working template you understand.

1. **S01 — Scaffold project** ✅ DONE

   - Create Flutter project (FVM), add `flutter_lints`. Create folders: `lib/app`, `lib/core`, `lib/features`, `env/`.
   - Commit: `feat: S01 scaffold`

2. **S02 — Router & Shell** ✅ DONE

   - Add `go_router`. Implement `Home` and `Settings` routes and `app/app.dart` shell.
   - Commit: `feat: S02 router shell`

3. **S03 — State (Riverpod)** ✅ DONE (but no CounterController yet)

   - Add Riverpod. Implement one provider + `CounterController` and wire UI.
   - Add a unit test for provider.
   - Commit: `feat: S03 state`

4. **S04 — Theme & Tokens** ✅ DONE

   - Add `theme.dart` with ColorScheme, light/dark toggle via provider.
   - Commit: `feat: S04 theme`

5. **S05 — Env Config** ✅ DONE
   - Add `env/dev.sample.json` and `AppConfig` loader using `--dart-define-from-file`.
   - Commit: `feat: S05 config`

5a. **S05b - Supabase init** ✅ DONE

- wire up Supabase + Docker

6. **S06 — Logging & Errors**

   - Add `bootstrap.dart` using `runZonedGuarded`, integrate `logger`.
   - Commit: `feat: S06 logging`

7. **S07 — Local storage adapter (v0)**

   - Add `KeyValueStore` interface and SharedPreferences impl; tests for read/write.
   - Commit: `feat: S07 storage`

8. **S08 — API client (stub)**

   - Add `ApiClient` facade (Dio), error mapping, and a mocked endpoint used in a feature test.
   - Commit: `feat: S08 api`

9. **S09 — CI & basic tests** ✅ DONE

   - Add GitHub Action: `flutter analyze` + `flutter test`. Ensure caching.
   - Commit: `ci: add analyze & test`

10. **S10 — Example feature (end-to-end)**

    - Implement a tiny feature using the stack (e.g., Notes persisted via KeyValueStore). Exercise routing, state, storage, and tests.
    - Commit: `feat: S10 example`

11. **S11 — Auth & Local-first plan (design only)**

    - Draft minimal DB schema (Drift) and Supabase RLS sketch. Keep code out of core until verified.
    - Commit: `chore: S11 auth-plan`

12. **S12 — Drift + PowerSync integration (optional next phase)**
    - Integrate Drift and PowerSync; implement offline-first sync for example feature. Add tests for sync conflict basics.
    - Commit: `feat: S12 drift-sync`

**Guidelines**

- One ticket per PR. Keep PRs small and runnable.
- After each ticket: checklist, patch, commands, test plan, 60-sec recap (per project instructions).
- Prototype in `/play/` only; move to core with ADR.

**Minimal CLI checklist (local)**

- `fvm flutter run` — run app
- `fvm flutter test` — run tests
- `fvm flutter analyze` — linting

_Document created as a concise operational guide. Expand individual steps into tickets when ready._
