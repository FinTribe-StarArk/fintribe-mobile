import 'package:fintribe/core/db/migrations.dart';
import 'package:fintribe/core/utils/helpers/logger.dart';
import 'package:sqflite/sqflite.dart';

/// Owns the single sqflite [Database] connection and applies [Migrations].
///
/// The [DatabaseFactory] is injectable so tests can pass the FFI in-memory
/// factory (`databaseFactoryFfi` + [inMemoryDatabasePath]) while production
/// uses the default platform factory.
///
/// ```dart
/// final appDb = AppDatabase();
/// await appDb.open(await AppDatabase.defaultPath());
/// final db = appDb.db; // pass to DAOs
/// ```
final class AppDatabase {
  /// Creates an [AppDatabase]. Pass [factory] to override the sqflite backend
  /// (e.g. `databaseFactoryFfi` in tests); defaults to the platform factory.
  AppDatabase({DatabaseFactory? factory})
    : _factory = factory ?? databaseFactory;

  final DatabaseFactory _factory;
  Database? _db;

  /// The open database. Throws [StateError] if [open] has not completed.
  Database get db =>
      _db ?? (throw StateError('AppDatabase.open() was not called'));

  /// Whether a connection is currently open.
  bool get isOpen => _db != null;

  /// Default on-device database path (`<databasesPath>/fintribe.db`).
  static Future<String> defaultPath() async {
    final dir = await databaseFactory.getDatabasesPath();
    return '$dir/fintribe.db';
  }

  /// Opens (or reuses) the connection at [path] and runs pending migrations.
  Future<Database> open(String path) async {
    if (_db != null) return _db!;
    _db = await _factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
    AppLogger.I.d('✅ SQLite opened (v${Migrations.latestVersion}) at $path');
    return _db!;
  }

  /// Closes the connection. Safe to call when already closed.
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  /// Fresh install: run every migration up to the target version.
  Future<void> _onCreate(Database db, int version) =>
      _runMigrations(db, from: 0, to: version);

  /// Upgrade: run only migrations in `(from, to]`.
  Future<void> _onUpgrade(Database db, int from, int to) =>
      _runMigrations(db, from: from, to: to);

  Future<void> _runMigrations(
    Database db, {
    required int from,
    required int to,
  }) async {
    final pending =
        Migrations.all.where((m) => m.version > from && m.version <= to).toList()
          ..sort((a, b) => a.version.compareTo(b.version));
    for (final migration in pending) {
      for (final statement in migration.statements) {
        await db.execute(statement);
      }
      AppLogger.I.d('📦 Applied migration v${migration.version}');
    }
  }
}
