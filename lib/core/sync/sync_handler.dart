import 'package:fintribe/core/sync/outbox_entry.dart';

/// Feature-specific bridge that knows how to push one entity type's queued
/// mutations to the server.
///
/// Each feature implements this and registers it with the [SyncEngine] at
/// startup, keeping the engine itself entity-agnostic. A [push] that throws
/// signals failure and leaves the entry queued for retry.
abstract interface class SyncHandler {
  /// The [OutboxEntry.entityType] this handler is responsible for.
  String get entityType;

  /// Pushes a single queued mutation to the server.
  ///
  /// On success the engine removes the entry; on throw it is marked failed
  /// and retried on the next sync.
  Future<void> push(OutboxEntry entry);
}
