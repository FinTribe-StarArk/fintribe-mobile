import 'package:fintribe/core/db/app_database.dart';
import 'package:fintribe/core/network/api_client.dart';
import 'package:fintribe/core/network/api_response.dart';
import 'package:fintribe/core/sync/outbox_dao.dart';
import 'package:fintribe/core/sync/sync_status.dart';
import 'package:fintribe/features/transactions/data/local/transaction_dao.dart';
import 'package:fintribe/features/transactions/data/repo/transaction_repo.dart';
import 'package:fintribe/features/transactions/domain/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_database.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AppDatabase appDb;
  late TransactionDao local;
  late OutboxDao outbox;
  late MockApiClient api;
  late TransactionRepo repo;

  final fixedNow = DateTime.utc(2026, 7, 12);

  setUpAll(initFfi);

  setUp(() async {
    appDb = await openTestDatabase();
    local = TransactionDao(appDb.db);
    outbox = OutboxDao(appDb.db);
    api = MockApiClient();
    repo = TransactionRepo(
      api: api,
      local: local,
      outbox: outbox,
      now: () => fixedNow,
    );
  });

  tearDown(() => appDb.close());

  group('create (offline write)', () {
    test('persists locally as pending and enqueues an outbox create', () async {
      final txn = await repo.create(
        title: 'Coffee',
        amount: 4.5,
        type: TransactionType.expense,
        category: 'Food',
      );

      // Visible in the local cache immediately (no network needed).
      final cached = await repo.getAll();
      expect(cached, [txn]);

      // Local row is marked pending until synced.
      final row = await local.findById(txn.id);
      expect(row!.syncStatus, SyncStatus.pending);

      // Exactly one queued mutation describing the create.
      final pending = await outbox.pending();
      expect(pending, hasLength(1));
      expect(pending.single.entityId, txn.id);
      expect(pending.single.payload['title'], 'Coffee');

      verifyNever(() => api.post(any(), data: any(named: 'data')));
    });
  });

  group('delete (offline write)', () {
    test('soft-deletes locally and enqueues an outbox delete', () async {
      final txn = await repo.create(
        title: 'Rent',
        amount: 1000,
        type: TransactionType.expense,
        category: 'Housing',
      );

      await repo.delete(txn);

      // Hidden from the UI list...
      expect(await repo.getAll(), isEmpty);
      // ...but still queued for the server (create + delete).
      final ops = await outbox.pending();
      expect(ops, hasLength(2));
    });
  });

  group('refresh (pull)', () {
    test('replaces the local cache with the server list', () async {
      when(() => api.get<List<dynamic>>(any())).thenAnswer(
        (_) async => ApiResponse<List<dynamic>>(
          data: [_serverJson('srv-1'), _serverJson('srv-2')],
          statusCode: 200,
          statusMessage: 'OK',
        ),
      );

      final result = await repo.refresh();

      expect(result.map((t) => t.id), ['srv-1', 'srv-2']);
      // Server rows are cached as already-synced.
      final row = await local.findById('srv-1');
      expect(row!.syncStatus, SyncStatus.synced);
    });
  });
}

Map<String, dynamic> _serverJson(String id) => {
  'id': id,
  'title': 'Server $id',
  'amount': 12.0,
  'type': 'income',
  'category': 'Salary',
  'note': null,
  'occurred_at': DateTime.utc(2026).toIso8601String(),
  'created_at': DateTime.utc(2026).toIso8601String(),
  'updated_at': DateTime.utc(2026).toIso8601String(),
};
