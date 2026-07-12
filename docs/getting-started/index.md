# Getting Started

## Prerequisites

- Flutter SDK >= 3.12.2
- Dart SDK >= 3.12.2
- Android Studio / VS Code with Flutter extension
- Xcode (for iOS development, macOS only)

## Setup

```bash
# Clone the repository
git clone <repo-url>
cd fintribe

# Install dependencies
flutter pub get

# Generate freezed & json_serializable code
dart run build_runner build --delete-conflicting-outputs

# Run on a connected device
flutter run
```

## Environment Flavors

The project supports three flavors:

| Flavor    | Entry Point       | Description                  |
|-----------|-------------------|------------------------------|
| dev       | `main_dev.dart`   | Development environment      |
| staging   | `main_staging.dart`| Staging/QA environment      |
| prod      | `main_prod.dart`  | Production environment       |

Run a specific flavor:

```bash
flutter run -t lib/main_dev.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_prod.dart
```

## Code Generation

After modifying any file annotated with `@freezed` or `@JsonSerializable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Testing

Unit tests are expected for new functions. DB/DAO/repo tests use an in-memory
SQLite via `sqflite_common_ffi`; collaborators are mocked with `mocktail`.

```bash
flutter test                                            # all tests
flutter test test/features/auth/auth_repo_test.dart     # one file
flutter test --plain-name "falls back to the cached user" # one test
```

Use the shared helper `test/helpers/test_database.dart` (`initFfi()` in
`setUpAll`, `openTestDatabase()` in `setUp`, `close()` in `tearDown`).

## Local persistence

The app is **offline-first** on SQLite (`sqflite`). See
[Architecture](../architecture/project-structure.md) for the read-cache /
write-outbox / sync-engine flow. (Hive is no longer used.)
