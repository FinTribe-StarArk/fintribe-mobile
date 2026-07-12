import 'dart:async';

import 'package:fintribe/core/db/app_database.dart';
import 'package:fintribe/core/network/connectivity_service.dart';
import 'package:fintribe/core/sync/outbox_dao.dart';
import 'package:fintribe/core/sync/outbox_entry.dart';
import 'package:fintribe/core/sync/sync_engine.dart';
import 'package:fintribe/core/sync/sync_handler.dart';
import 'package:fintribe/core/sync/sync_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

/// Connectivity double whose online state and stream are test-controlled.
class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({this.online = true});
  bool online;
  final _controller = StreamController<bool>.broadcast();

  @override
  Future<bool> get isOnline async => online;

  @override
  Stream<bool> get onStatusChange => _controller.stream;

  void emit(bool value) => _controller.add(value);
}

/// Records pushes and optionally fails for a given entity id.
class RecordingHandler implements SyncHandler {
  final List<String> pushed = [];
  final Set<String> failFor;
  RecordingHandler({this.failFor = const {}});

  @override
  String get entityType => 'transaction';

  @override
  Future<void> push(OutboxEntry entry) async {
    if (failFor.contains(entry.entityId)) {
      throw Exception('push failed for ${entry.entityId}');
    }
    pushed.add(entry.entityId);
  }
}

void main() {
  late AppDatabase appDb;
  late OutboxDao outbox;

  OutboxEntry entry(String id) => OutboxEntry(
    id: id,
    entityType: 'transaction',
    entityId: 'txn-$id',
    operation: OutboxOperation.create,
    payload: const {},
    createdAt: DateTime.utc(2026),
  );

  setUpAll(initFfi);
  setUp(() async {
    appDb = await openTestDatabase();
    outbox = OutboxDao(appDb.db);
  });
  tearDown(() => appDb.close());

  test('skips work and reports offline when there is no connection', () async {
    final engine = SyncEngine(
      outboxDao: outbox,
      connectivity: FakeConnectivity(online: false),
    )..register(RecordingHandler());
    await outbox.upsert(entry('1'));

    final result = await engine.sync();

    expect(result.skippedOffline, isTrue);
    expect(await outbox.pending(), hasLength(1)); // untouched
  });

  test('pushes pending entries and clears them on success', () async {
    final handler = RecordingHandler();
    final engine = SyncEngine(
      outboxDao: outbox,
      connectivity: FakeConnectivity(),
    )..register(handler);
    await outbox.upsert(entry('1'));
    await outbox.upsert(entry('2'));

    final result = await engine.sync();

    expect(result.pushed, 2);
    expect(handler.pushed, ['txn-1', 'txn-2']);
    expect(await outbox.pending(), isEmpty);
  });

  test('keeps failed entries queued and marks them failed', () async {
    final handler = RecordingHandler(failFor: {'txn-2'});
    final engine = SyncEngine(
      outboxDao: outbox,
      connectivity: FakeConnectivity(),
    )..register(handler);
    await outbox.upsert(entry('1'));
    await outbox.upsert(entry('2'));

    final result = await engine.sync();

    expect(result.pushed, 1);
    expect(result.failed, 1);
    final remaining = await outbox.pending();
    expect(remaining, hasLength(1));
    expect(remaining.single.entityId, 'txn-2');
    expect(remaining.single.retryCount, 1);
  });

  test('start() drains the outbox when connectivity is regained', () async {
    final handler = RecordingHandler();
    final conn = FakeConnectivity(online: true);
    final engine = SyncEngine(outboxDao: outbox, connectivity: conn)
      ..register(handler)
      ..start();
    await outbox.upsert(entry('1'));

    conn.emit(true);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(handler.pushed, ['txn-1']);
    await engine.stop();
  });
}
