# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

FinTribe — a scalable, **offline-first** Flutter financial app. Dart/Flutter SDK `^3.12.2`. Built by a small (2-person) team, so the architecture favors clarity and low boilerplate over layers of indirection. `auth` (online) and `transactions` (offline-first) are the two reference features; other routes are placeholders.

## Commands

Flutter may not be on `PATH`; it lives at `C:\src\flutter\bin`. In PowerShell prefix commands with `$env:Path += ";C:\src\flutter\bin";` if `flutter` isn't found.

```bash
flutter pub get                                          # install deps
dart run build_runner build --delete-conflicting-outputs # regenerate *.freezed.dart / *.g.dart
dart run build_runner watch  --delete-conflicting-outputs # codegen in watch mode
flutter analyze                                          # lint (must be clean)
flutter test                                             # run all tests
flutter test test/features/auth/auth_repo_test.dart      # single test file
flutter test --plain-name "falls back to the cached user" # single test by name
```

**Run flavors** — always pass a `-t` target (no default flavor is wired):

```bash
flutter run -t lib/main_dev.dart       # dev
flutter run -t lib/main_staging.dart   # staging
flutter run -t lib/main_prod.dart      # prod
```

**After editing any `@freezed` or `@JsonSerializable` class, rerun `build_runner`** or it won't compile. Generated `*.freezed.dart` / `*.g.dart` files are committed. `build_runner` prints a warning that `--delete-conflicting-outputs` is ignored on this version — harmless; keep passing it.

## Architecture

Feature-first: `lib/features/<feature>/` with shared infrastructure in `lib/core/`. Each feature is split into `data/` (repos, DAOs, providers, sync handlers), `domain/` (freezed models), and `ui/` (screens + their providers/state).

**Bootstrap flow:** `main_<flavor>.dart` → `FinTribeApp.run(Environment.x)` (`lib/main.dart`) sets `ApiConstants.setEnvironment` (swaps base URL) → `runApp(ProviderScope(...))`. `appInitializationProvider` (`lib/core/providers.dart`) gates the UI: it opens SQLite, loads SharedPreferences + theme, registers sync handlers, starts the `SyncEngine`, and flushes any queued offline writes before the real `MaterialApp.router` renders.

**State management — Riverpod v3, hand-written providers (NO codegen).** This project deliberately does **not** use `riverpod_generator`/`@riverpod`. Declare providers manually: `Provider`, `NotifierProvider`, `AsyncNotifierProvider`, `FutureProvider`. Async flows use `AsyncNotifier<T>` + `AsyncValue.guard` (see `transactions_provider.dart`, `auth_provider.dart`). `@freezed` + `json_serializable` codegen **is** used, but only for domain models.

**Dependency injection is centralized in `lib/core/providers.dart`.** All low-level singletons (DB, DAOs, `ApiClient`, connectivity, `SyncEngine`, repos) are defined there; feature files declare only their own feature-facing providers (e.g. `transactionsProvider`) and read the core ones. Do not re-declare a repo/DAO provider inside a feature.

**Offline-first data flow (the core pattern):**
- **SQLite is the single source of truth the UI reads.** `AppDatabase` (`lib/core/db/`) owns one sqflite connection; schema changes are append-only `Migration`s in `migrations.dart`. DAOs extend the thin generic `BaseDao<T>` — a concrete DAO supplies only `table`, `toDb`, and `fromDb`. `DbMap` (`db_mappers.dart`) handles `bool↔int` and `DateTime↔ISO`; **DateTimes are stored and read back as UTC** (convert to local only at display time).
- **Reads** return cached rows immediately, then trigger a best-effort remote `refresh()` — so the UI works offline.
- **Writes** apply to the local DB *and* enqueue an `OutboxEntry` (the `outbox` table). They never hit the network directly.
- **The `SyncEngine`** (`lib/core/sync/`) drains the outbox: it's entity-agnostic and delegates each queued mutation to a registered `SyncHandler` (one per entity type, e.g. `TransactionSyncHandler`). It auto-runs when connectivity returns (via `ConnectivityService`) and can be flushed on demand. A `SyncHandler.push` that throws leaves the entry queued and increments its retry count.
- The `transactions` feature is the end-to-end template for all of this — copy its shape (`data/local` DAO, `data/repo` repo, `data/sync` handler, `ui/provider` + `ui/screen`) for new offline-first features.

**Networking:** `DioClient.create` builds the configured `Dio`; `ApiClient` wraps it with typed `get/post/put/patch/delete` returning `ApiResponse<T>`, converting every `DioException` via `ErrorHandler.handle` into a typed `NetworkException` subclass. Repositories call `ApiClient`, never `Dio`. `AuthInterceptor` injects the bearer token and does queued 401 refresh. `ApiClient` is intentionally a plain (non-`final`) class so repos can mock it in tests.

**Storage roles:** `SecureStorage` (flutter_secure_storage) → auth tokens only; `Preferences` (SharedPreferences, with an `InMemoryPreferences` fallback) → simple settings like theme; SQLite → all structured/cached data.

**Routing:** `go_router` exposed as `routerProvider` in `lib/core/router/app_router.dart`; constants in `route_names.dart` (paths `kebab-case`, names `camelCase`). It has an **auth-guard `redirect`** driven by `authProvider` (unauthenticated → login; authenticated → kept out of auth routes), with a `refreshListenable` bridged from Riverpod. Screens never navigate on login/logout — they mutate auth state and the redirect moves them.

**Auth specifics:** the backend returns **only a JWT at `data.token`** (no user object, no refresh token). `AuthRepo` derives the `User` from the token claims (`user_id`, `email`) via `Jwt.decode` (`core/utils/helpers/jwt.dart`), plus `name` from the register form, and caches it in the `users` table for offline session restore. `fetchCurrentUser` restores from the stored token (checking `Jwt.isExpired`) — there is no profile endpoint. Register posts `{name, email, password}`; login posts `{email, password}`.

**Theme:** `AppTheme.light`/`.dark` driven by `themeModeProvider` (`ThemeModeNotifier`, persisted to `Preferences`); light/dark/system all supported.

## Testing conventions

Unit tests are expected for new functions — this repo is also a learning vehicle for testing, so keep coverage tight and behavior-focused.

- DB/DAO/repo tests run against a real in-memory SQLite via **`sqflite_common_ffi`**. Use the helper `test/helpers/test_database.dart`: call `initFfi()` in `setUpAll`, `openTestDatabase()` in `setUp`, and `appDb.close()` in `tearDown`.
- Mock collaborators with **`mocktail`** (`class MockApiClient extends Mock implements ApiClient {}`). Fake `ConnectivityService`/`SyncHandler` by hand (see `sync_engine_test.dart`) rather than mocking.
- Inject `now`/`Uuid` into repos (as `TransactionRepo` does) to keep time/ids deterministic.
- Test mirror mirrors `lib/` layout under `test/`.

## Conventions

- **Repositories are concrete `final` classes — no abstract interface, no `Impl` suffix** (`AuthRepo`, `TransactionRepo`). Constructors take public-named params assigned to private fields (`{required ApiClient api}) : _api = api`) for DI + mockability; the `prefer_initializing_formals` lint is intentionally off for this.
- `final class` for non-extended classes; private `._()` constructor for static-only utilities (`ApiConstants`, `AppRouter`, `DbTables`).
- Files `snake_case`; classes `PascalCase`; providers `camelCase` + `Provider`.
- Lints are stricter than default (`analysis_options.yaml`): `require_trailing_commas`, `prefer_final_locals`, `unawaited_futures` as **error**. Generated files are excluded. Keep `flutter analyze` clean.
- Commits follow Conventional Commits with scopes: types `feat|fix|refactor|style|docs|test|chore|perf|ci`; scopes include `auth|core|network|theme|router|storage|widgets` (add `db|sync|transactions` as needed). Imperative mood, ≤72-char subject, no trailing period. PRs target `main`; active work is on `development`.

## Gotchas

- **`docs/` predates this architecture in places** — treat the code and this file as the source of truth where they disagree (e.g. any mention of `@riverpod` codegen or Hive is stale; the app uses manual providers and SQLite).
- If tests fail to compile with `Member not found: 'transformTimeout'` from `dio`, the pub cache copy of dio is corrupted — delete `~/AppData/Local/Pub/Cache/hosted/pub.dev/dio-<ver>` and re-run `flutter pub get`.
- IDE diagnostics for freezed/json symbols (`_$Foo`, `.g.dart` URIs) are expected until `build_runner` has run; they are not real errors.
- Dev API is `http://localhost:8080/api/v1` (plain HTTP). On an **Android emulator** use `10.0.2.2` instead of `localhost`; cleartext is enabled for debug builds only (`android/app/src/debug/AndroidManifest.xml`). The app targets mobile (sqflite) — it does not run on Flutter web without an FFI web shim.
