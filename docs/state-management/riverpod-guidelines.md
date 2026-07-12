# Riverpod Guidelines

This project uses **Riverpod v3 with manually-written providers — no
`riverpod_generator`, no `@riverpod`.** (Only `freezed` + `json_serializable`
use code generation, and only for domain models.)

## Provider choices

| Need                                   | Use                               |
|----------------------------------------|-----------------------------------|
| Singleton / dependency                 | `Provider<T>`                     |
| Mutable sync state with methods        | `NotifierProvider<N, S>`         |
| Async state with methods (load + edit) | `AsyncNotifierProvider<N, S>`    |
| One-shot async fetch                   | `FutureProvider<T>`              |

## Rules

1. **Declare providers by hand** — see `core/providers.dart` and feature
   `*_provider.dart` files.
2. **Centralize DI in `core/providers.dart`.** Feature files declare only their
   own feature-facing providers and read the core ones. Never re-declare a
   repo/DAO provider inside a feature.
3. **`ref.watch` in `build`, `ref.read` in callbacks/methods.**
4. **Async flows use `AsyncNotifier` + `AsyncValue.guard`.**

## Example — offline-first AsyncNotifier

```dart
// features/transactions/ui/provider/transactions_provider.dart
final class TransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  TransactionRepo get _repo => ref.read(transactionRepoProvider);

  @override
  Future<List<TransactionModel>> build() async {
    final cached = await _repo.getAll();        // local-first: instant, offline-ok
    unawaited(_refreshInBackground());          // best-effort remote refresh
    return cached;
  }

  Future<void> add({ ... }) async {
    await _repo.create(...);                     // writes local + enqueues outbox
    await _reload();
    unawaited(ref.read(syncEngineProvider).sync());
  }
}

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
      TransactionsNotifier.new,
    );
```

## Testing providers

Override the underlying repo/DAO providers in a `ProviderContainer`, or (more
commonly here) test the repo directly against an in-memory SQLite DB. See
`test/` and `docs/` testing notes.
