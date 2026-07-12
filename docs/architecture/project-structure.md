# Project Structure

Feature-first with a shared `core/`. SQLite is the offline-first source of
truth; the `transactions` feature is the reference implementation of the full
read-cache + write-outbox + sync pattern.

```
lib/
├── main.dart                          # FinTribeApp shell (takes an Environment)
├── main_dev.dart / main_staging.dart / main_prod.dart   # flavor entry points
│
├── core/
│   ├── constants/                     # api / app / storage / ui constants
│   ├── db/
│   │   ├── app_database.dart          # owns the sqflite connection + migrations
│   │   ├── migrations.dart            # append-only versioned schema (raw SQL)
│   │   ├── db_tables.dart             # table-name constants
│   │   ├── base_dao.dart              # generic CRUD DAO (table/toDb/fromDb)
│   │   └── db_mappers.dart            # bool<->int, DateTime<->ISO (UTC) helpers
│   ├── sync/
│   │   ├── sync_status.dart           # SyncStatus + OutboxOperation enums
│   │   ├── outbox_entry.dart          # @freezed queued mutation
│   │   ├── outbox_dao.dart            # persists the mutation queue
│   │   ├── sync_handler.dart          # per-entity push interface
│   │   └── sync_engine.dart           # drains outbox; connectivity-triggered
│   ├── network/
│   │   ├── dio_client.dart            # Dio factory
│   │   ├── api_client.dart            # typed HTTP wrapper -> ApiResponse<T>
│   │   ├── auth_interceptor.dart      # token inject + queued 401 refresh
│   │   ├── connectivity_service.dart  # online/offline signal (connectivity_plus)
│   │   ├── error_handler.dart         # DioException -> NetworkException
│   │   ├── network_exceptions.dart    # typed exception hierarchy
│   │   └── api_response.dart          # generic response wrapper
│   ├── storage/                       # secure_storage (tokens) + preferences
│   ├── theme/ · router/ · global_widgets/ · utils/helpers/
│   └── providers.dart                 # CENTRAL dependency-injection graph
│
└── features/
    ├── auth/                          # online feature (+ offline user cache)
    │   ├── data/local/user_dao.dart
    │   ├── data/repo/auth_repo.dart
    │   ├── data/provider/auth_provider.dart
    │   ├── domain/model/user.dart     # @freezed + json_serializable
    │   └── ui/login/                  # screen + form provider/state
    └── transactions/                  # OFFLINE-FIRST reference feature
        ├── data/local/transaction_dao.dart
        ├── data/repo/transaction_repo.dart      # cache read + outbox write
        ├── data/sync/transaction_sync_handler.dart
        ├── domain/model/transaction_model.dart
        └── ui/provider/ · ui/screen/

test/                                  # mirrors lib/; helpers/test_database.dart
```

## Layer rules

- **UI** watches providers only. **Providers** hold state and call repos.
- **Repos** are the only place that talks to both `ApiClient` and DAOs. They read
  local-first and enqueue writes to the outbox — never call `Dio` directly.
- **DAOs** extend `BaseDao<T>` and own all SQL for one table.
- **DI** lives in `core/providers.dart`; features don't re-declare core providers.
