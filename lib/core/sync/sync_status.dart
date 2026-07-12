/// Sync state of a locally-stored record relative to the server.
enum SyncStatus {
  /// Local change not yet pushed to the server.
  pending,

  /// Local copy matches the server.
  synced,

  /// Last push attempt failed; will be retried.
  failed;

  /// Parses a stored DB string, defaulting to [SyncStatus.pending].
  static SyncStatus fromDb(Object? value) => SyncStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => SyncStatus.pending,
  );
}

/// The kind of mutation queued in the outbox for a record.
enum OutboxOperation {
  create,
  update,
  delete;

  /// Parses a stored DB string. Throws [ArgumentError] on an unknown value.
  static OutboxOperation fromDb(Object? value) => OutboxOperation.values
      .firstWhere(
        (o) => o.name == value,
        orElse: () => throw ArgumentError('Unknown OutboxOperation: $value'),
      );
}
