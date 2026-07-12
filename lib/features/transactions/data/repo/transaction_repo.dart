import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/network/api_client.dart';
import 'package:fintribe/core/sync/outbox_dao.dart';
import 'package:fintribe/core/sync/outbox_entry.dart';
import 'package:fintribe/core/sync/sync_status.dart';
import 'package:fintribe/features/transactions/data/local/transaction_dao.dart';
import 'package:fintribe/features/transactions/domain/model/transaction_model.dart';
import 'package:uuid/uuid.dart';

/// Offline-first repository for transactions.
///
/// The local [TransactionDao] is the single source of truth the UI reads.
/// Reads return cached data immediately; [refresh] pulls the server and
/// updates the cache. Writes apply to the cache *and* enqueue an
/// [OutboxEntry], so they work offline and are replayed by the sync engine.
final class TransactionRepo {
  /// Creates a [TransactionRepo].
  TransactionRepo({
    required ApiClient api,
    required TransactionDao local,
    required OutboxDao outbox,
    Uuid uuid = const Uuid(),
    DateTime Function() now = DateTime.now,
  }) : _api = api,
       _local = local,
       _outbox = outbox,
       _uuid = uuid,
       _now = now;

  /// The outbox [entityType] used for all transaction mutations.
  static const String entityType = 'transaction';

  final ApiClient _api;
  final TransactionDao _local;
  final OutboxDao _outbox;
  final Uuid _uuid;
  final DateTime Function() _now;

  /// Cached transactions for the UI (local-first, newest first).
  Future<List<TransactionModel>> getAll() => _local.activeTransactions();

  /// Pulls the server list and replaces the local cache. Returns the fresh list.
  Future<List<TransactionModel>> refresh() async {
    final response = await _api.get<List<dynamic>>(ApiConstants.transactions);
    final list = (response.data ?? [])
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    await _local.replaceAllSynced(list);
    return list;
  }

  /// Creates a transaction locally and queues it for the server.
  Future<TransactionModel> create({
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    String? note,
    DateTime? occurredAt,
  }) async {
    final timestamp = _now();
    final txn = TransactionModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      type: type,
      category: category,
      note: note,
      occurredAt: occurredAt ?? timestamp,
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    await _local.upsert(
      LocalTransaction(transaction: txn, syncStatus: SyncStatus.pending),
    );
    await _enqueue(OutboxOperation.create, txn);
    return txn;
  }

  /// Updates an existing transaction locally and queues the change.
  Future<TransactionModel> update(TransactionModel transaction) async {
    final updated = transaction.copyWith(updatedAt: _now());
    await _local.upsert(
      LocalTransaction(transaction: updated, syncStatus: SyncStatus.pending),
    );
    await _enqueue(OutboxOperation.update, updated);
    return updated;
  }

  /// Soft-deletes a transaction locally and queues the deletion.
  Future<void> delete(TransactionModel transaction) async {
    await _local.softDelete(transaction.id);
    await _enqueue(OutboxOperation.delete, transaction);
  }

  Future<void> _enqueue(OutboxOperation op, TransactionModel txn) {
    return _outbox.upsert(
      OutboxEntry(
        id: _uuid.v4(),
        entityType: entityType,
        entityId: txn.id,
        operation: op,
        payload: txn.toJson(),
        createdAt: _now(),
      ),
    );
  }
}
