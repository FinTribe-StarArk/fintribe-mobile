# Folder & File Structure Rules

## Feature Module Structure

Every feature **must** follow this structure:

```
features/<feature_name>/
├── data/
│   ├── local/                 # SQLite DAO(s) — offline-first features
│   │   └── <feature>_dao.dart
│   ├── repo/
│   │   └── <feature>_repo.dart   # concrete, no _impl suffix
│   ├── sync/                  # SyncHandler — offline-first features
│   │   └── <feature>_sync_handler.dart
│   └── provider/
│       └── <feature>_provider.dart
├── domain/
│   └── model/
│       └── <entity_name>_model.dart   # @freezed + json_serializable
└── ui/
    └── <sub_feature>/
        ├── <feature>_screen.dart
        ├── <feature>_provider.dart
        └── <feature>_state.dart
```

## Rules

1. **One feature per folder** — Don't mix concerns across features.
2. **Data layer** contains only data-fetching logic (API calls, DB queries).
3. **Domain layer** contains only business entities and models. No Flutter imports.
4. **UI layer** contains only presentation logic (providers, widgets, screens).
5. **No cross-feature imports** at the UI level — use core for shared code.
6. **Repositories are concrete `final` classes** — no abstract interface, no
   `Impl` suffix. Mock them (or `ApiClient`) directly in tests via mocktail.
7. **Offline-first features** read local-first via a DAO and enqueue writes to
   the outbox; a `SyncHandler` pushes them when online. See the `transactions`
   feature as the reference.

## Core Module Rules

1. `core/` contains code used by **two or more** features.
2. Single-feature utilities belong inside that feature's folder.
3. `core/constants/` — Only compile-time constants. No runtime values.
4. `core/helpers/` — Pure functions, no state, no side effects.
5. `core/global_widgets/` — Reusable widgets only. One widget per file.
