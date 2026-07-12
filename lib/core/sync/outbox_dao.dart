import 'dart:convert';

import 'package:fintribe/core/db/base_dao.dart';
import 'package:fintribe/core/db/db_tables.dart';
import 'package:fintribe/core/sync/outbox_entry.dart';
import 'package:fintribe/core/sync/sync_status.dart';

/// Persists the offline mutation queue (the "outbox").
final class OutboxDao extends BaseDao<OutboxEntry> {
  /// Creates an [OutboxDao] over the open database.
  OutboxDao(super.db);

  @override
  String get table => DbTables.outbox;

  @override
  Map<String, Object?> toDb(OutboxEntry m) => {
    'id': m.id,
    'entity_type': m.entityType,
    'entity_id': m.entityId,
    'operation': m.operation.name,
    'payload': jsonEncode(m.payload),
    'status': m.status.name,
    'retry_count': m.retryCount,
    'last_error': m.lastError,
    'created_at': m.createdAt.toUtc().toIso8601String(),
  };

  @override
  OutboxEntry fromDb(Map<String, Object?> row) => OutboxEntry(
    id: row['id']! as String,
    entityType: row['entity_type']! as String,
    entityId: row['entity_id']! as String,
    operation: OutboxOperation.fromDb(row['operation']),
    payload: jsonDecode(row['payload']! as String) as Map<String, dynamic>,
    status: SyncStatus.fromDb(row['status']),
    retryCount: row['retry_count']! as int,
    lastError: row['last_error'] as String?,
    createdAt: DateTime.parse(row['created_at']! as String).toLocal(),
  );

  /// Entries awaiting a push, oldest first.
  Future<List<OutboxEntry>> pending() => findAll(
    where: 'status != ?',
    whereArgs: [SyncStatus.synced.name],
    orderBy: 'created_at ASC',
  );

  /// Marks an entry as failed and increments its retry counter.
  Future<void> markFailed(String id, String error) async {
    await db.rawUpdate(
      'UPDATE $table SET status = ?, retry_count = retry_count + 1, '
      'last_error = ? WHERE id = ?',
      [SyncStatus.failed.name, error, id],
    );
  }
}
