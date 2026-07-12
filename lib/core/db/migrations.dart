import 'package:fintribe/core/db/db_tables.dart';

/// A single, versioned schema change expressed as raw SQL statements.
///
/// Migrations are append-only: never edit a shipped [Migration]; add a new one
/// with the next [version] instead. On a fresh install every migration up to
/// the current DB version runs in order; on upgrade only the newer ones run.
final class Migration {
  const Migration({required this.version, required this.statements});

  /// Schema version this migration brings the database *to*.
  final int version;

  /// SQL statements executed in order for this version.
  final List<String> statements;
}

/// Ordered list of all schema migrations. Bump [Migrations.latestVersion]
/// (implicitly, via the highest [Migration.version]) by appending here.
abstract final class Migrations {
  Migrations._();

  static const List<Migration> all = [_v1];

  /// Highest known schema version — used as the `openDatabase` version.
  static int get latestVersion =>
      all.map((m) => m.version).fold(0, (a, b) => a > b ? a : b);

  static const Migration _v1 = Migration(
    version: 1,
    statements: [
      '''
      CREATE TABLE ${DbTables.users} (
        id         TEXT PRIMARY KEY,
        email      TEXT NOT NULL,
        name       TEXT,
        photo_url  TEXT,
        created_at TEXT,
        updated_at TEXT
      )
      ''',
      '''
      CREATE TABLE ${DbTables.transactions} (
        id          TEXT PRIMARY KEY,
        title       TEXT NOT NULL,
        amount      REAL NOT NULL,
        type        TEXT NOT NULL,
        category    TEXT NOT NULL,
        note        TEXT,
        occurred_at TEXT NOT NULL,
        created_at  TEXT NOT NULL,
        updated_at  TEXT NOT NULL,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        is_deleted  INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE ${DbTables.outbox} (
        id          TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id   TEXT NOT NULL,
        operation   TEXT NOT NULL,
        payload     TEXT NOT NULL,
        status      TEXT NOT NULL DEFAULT 'pending',
        retry_count INTEGER NOT NULL DEFAULT 0,
        last_error  TEXT,
        created_at  TEXT NOT NULL
      )
      ''',
      'CREATE INDEX idx_outbox_status ON ${DbTables.outbox} (status, created_at)',
      'CREATE INDEX idx_txn_occurred ON ${DbTables.transactions} (occurred_at)',
    ],
  );
}
