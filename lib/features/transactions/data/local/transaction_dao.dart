import 'package:fintribe/core/db/base_dao.dart';
import 'package:fintribe/core/db/db_mappers.dart';
import 'package:fintribe/core/db/db_tables.dart';
import 'package:fintribe/core/sync/sync_status.dart';
import 'package:fintribe/features/transactions/domain/model/transaction_model.dart';

/// A [TransactionModel] paired with its local-only sync bookkeeping.
final class LocalTransaction {
  const LocalTransaction({
    required this.transaction,
    required this.syncStatus,
    this.isDeleted = false,
  });

  final TransactionModel transaction;
  final SyncStatus syncStatus;

  /// Soft-delete flag: hidden from the UI but kept until the delete syncs.
  final bool isDeleted;
}

/// Local store for transactions (SQLite, source of truth for the UI).
final class TransactionDao extends BaseDao<LocalTransaction> {
  /// Creates a [TransactionDao] over the open database.
  TransactionDao(super.db);

  @override
  String get table => DbTables.transactions;

  @override
  Map<String, Object?> toDb(LocalTransaction m) {
    final t = m.transaction;
    return {
      'id': t.id,
      'title': t.title,
      'amount': t.amount,
      'type': t.type.name,
      'category': t.category,
      'note': t.note,
      'occurred_at': DbMap.dateToIso(t.occurredAt),
      'created_at': DbMap.dateToIso(t.createdAt),
      'updated_at': DbMap.dateToIso(t.updatedAt),
      'sync_status': m.syncStatus.name,
      'is_deleted': DbMap.boolToInt(m.isDeleted),
    };
  }

  @override
  LocalTransaction fromDb(Map<String, Object?> row) => LocalTransaction(
    transaction: TransactionModel(
      id: row['id']! as String,
      title: row['title']! as String,
      amount: (row['amount']! as num).toDouble(),
      type: TransactionType.values.byName(row['type']! as String),
      category: row['category']! as String,
      note: row['note'] as String?,
      occurredAt: DbMap.isoToDate(row['occurred_at']),
      createdAt: DbMap.isoToDate(row['created_at']),
      updatedAt: DbMap.isoToDate(row['updated_at']),
    ),
    syncStatus: SyncStatus.fromDb(row['sync_status']),
    isDeleted: DbMap.intToBool(row['is_deleted']),
  );

  /// Visible transactions (not soft-deleted), newest first.
  Future<List<TransactionModel>> activeTransactions() async {
    final rows = await findAll(
      where: 'is_deleted = 0',
      orderBy: 'occurred_at DESC',
    );
    return rows.map((r) => r.transaction).toList();
  }

  /// Replaces the local cache with the server [transactions] (all `synced`).
  Future<void> replaceAllSynced(List<TransactionModel> transactions) async {
    await upsertAll(
      transactions
          .map((t) => LocalTransaction(transaction: t, syncStatus: SyncStatus.synced))
          .toList(),
    );
  }

  /// Marks a row's sync status (e.g. `synced` after a successful push).
  Future<void> setSyncStatus(String id, SyncStatus status) async {
    await db.update(
      table,
      {'sync_status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Soft-deletes a row so it disappears from the UI but survives for sync.
  Future<void> softDelete(String id) async {
    await db.update(
      table,
      {'is_deleted': 1, 'sync_status': SyncStatus.pending.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
