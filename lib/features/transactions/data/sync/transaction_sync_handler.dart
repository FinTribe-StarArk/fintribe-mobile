import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/network/api_client.dart';
import 'package:fintribe/core/sync/outbox_entry.dart';
import 'package:fintribe/core/sync/sync_handler.dart';
import 'package:fintribe/core/sync/sync_status.dart';
import 'package:fintribe/features/transactions/data/local/transaction_dao.dart';
import 'package:fintribe/features/transactions/data/repo/transaction_repo.dart';

/// Pushes queued transaction mutations to the server.
///
/// Registered with the `SyncEngine` at startup. On a successful create/update
/// it flips the local row to [SyncStatus.synced]; on delete it removes the
/// now-obsolete local row. Any thrown error keeps the entry queued for retry.
final class TransactionSyncHandler implements SyncHandler {
  /// Creates the handler over the network [api] and local [local] store.
  const TransactionSyncHandler({
    required ApiClient api,
    required TransactionDao local,
  }) : _api = api,
       _local = local;

  final ApiClient _api;
  final TransactionDao _local;

  @override
  String get entityType => TransactionRepo.entityType;

  @override
  Future<void> push(OutboxEntry entry) async {
    switch (entry.operation) {
      case OutboxOperation.create:
        await _api.post(ApiConstants.transactions, data: entry.payload);
        await _local.setSyncStatus(entry.entityId, SyncStatus.synced);
      case OutboxOperation.update:
        await _api.put(
          ApiConstants.transaction(entry.entityId),
          data: entry.payload,
        );
        await _local.setSyncStatus(entry.entityId, SyncStatus.synced);
      case OutboxOperation.delete:
        await _api.delete(ApiConstants.transaction(entry.entityId));
        await _local.deleteById(entry.entityId);
    }
  }
}
