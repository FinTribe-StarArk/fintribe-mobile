import 'package:sqflite/sqflite.dart';

/// Thin generic Data Access Object.
///
/// Subclasses supply only three things — [table], [toDb], and [fromDb] — and
/// inherit the common CRUD boilerplate. This keeps each concrete DAO tiny
/// while still using plain SQL under the hood (no code generation).
///
/// ```dart
/// final class UserDao extends BaseDao<User> {
///   UserDao(super.db);
///   @override String get table => DbTables.users;
///   @override Map<String, Object?> toDb(User m) => { ... };
///   @override User fromDb(Map<String, Object?> row) => User(...);
/// }
/// ```
abstract class BaseDao<T> {
  /// Creates a DAO backed by an open sqflite [db].
  BaseDao(this.db);

  /// The open database handle.
  final Database db;

  /// Name of the backing table.
  String get table;

  /// Primary key column. Override if not `id`.
  String get primaryKey => 'id';

  /// Serializes [model] to a SQLite-compatible row map.
  Map<String, Object?> toDb(T model);

  /// Deserializes a row map back into [T].
  T fromDb(Map<String, Object?> row);

  /// Inserts or replaces [model] (upsert on [primaryKey] conflict).
  Future<void> upsert(T model, {DatabaseExecutor? txn}) {
    return (txn ?? db).insert(
      table,
      toDb(model),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Batched upsert of [models] in a single transaction.
  Future<void> upsertAll(List<T> models) async {
    if (models.isEmpty) return;
    final batch = db.batch();
    for (final model in models) {
      batch.insert(
        table,
        toDb(model),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Returns the row matching [id], or `null`.
  Future<T?> findById(Object id) async {
    final rows = await db.query(
      table,
      where: '$primaryKey = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : fromDb(rows.first);
  }

  /// Returns all rows, optionally filtered/ordered.
  Future<List<T>> findAll({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final rows = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
    return rows.map(fromDb).toList();
  }

  /// Deletes the row with [id]. Returns the number of rows removed.
  Future<int> deleteById(Object id) {
    return db.delete(table, where: '$primaryKey = ?', whereArgs: [id]);
  }

  /// Deletes every row in [table].
  Future<int> clear() => db.delete(table);

  /// Number of rows in [table].
  Future<int> count() async {
    final result = await db.rawQuery('SELECT COUNT(*) AS c FROM $table');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
