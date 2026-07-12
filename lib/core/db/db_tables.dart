/// Central registry of SQLite table names.
///
/// Reference these from DAOs instead of hard-coding strings so a rename is a
/// single-line change.
abstract final class DbTables {
  DbTables._();

  static const String users = 'users';
  static const String transactions = 'transactions';

  /// Offline mutation queue (create/update/delete replayed when online).
  static const String outbox = 'outbox';
}
