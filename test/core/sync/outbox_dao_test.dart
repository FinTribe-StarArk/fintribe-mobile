import 'package:fintribe/core/db/app_database.dart';
import 'package:fintribe/core/sync/outbox_dao.dart';
import 'package:fintribe/core/sync/outbox_entry.dart';
import 'package:fintribe/core/sync/sync_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase appDb;
  late OutboxDao dao;

  OutboxEntry entry(String id, {required DateTime createdAt}) => OutboxEntry(
    id: id,
    entityType: 'transaction',
    entityId: 'txn-$id',
    operation: OutboxOperation.create,
    payload: {'id': 'txn-$id', 'amount': 10},
    createdAt: createdAt,
  );

  setUpAll(initFfi);
  setUp(() async {
    appDb = await openTestDatabase();
    dao = OutboxDao(appDb.db);
  });
  tearDown(() => appDb.close());

  test('serializes the JSON payload through a round-trip', () async {
    await dao.upsert(entry('1', createdAt: DateTime.utc(2026)));
    final loaded = await dao.findById('1');
    expect(loaded!.payload, {'id': 'txn-1', 'amount': 10});
    expect(loaded.operation, OutboxOperation.create);
  });

  test('pending() returns entries oldest-first', () async {
    await dao.upsert(entry('new', createdAt: DateTime.utc(2026, 2)));
    await dao.upsert(entry('old', createdAt: DateTime.utc(2026, 1)));

    final pending = await dao.pending();
    expect(pending.map((e) => e.id), ['old', 'new']);
  });

  test('markFailed flips status and increments retryCount', () async {
    await dao.upsert(entry('1', createdAt: DateTime.utc(2026)));
    await dao.markFailed('1', 'boom');

    final loaded = await dao.findById('1');
    expect(loaded!.status, SyncStatus.failed);
    expect(loaded.retryCount, 1);
    expect(loaded.lastError, 'boom');
  });

  test('pending() still includes failed (retryable) entries', () async {
    await dao.upsert(entry('1', createdAt: DateTime.utc(2026)));
    await dao.markFailed('1', 'boom');
    expect(await dao.pending(), hasLength(1));
  });
}
