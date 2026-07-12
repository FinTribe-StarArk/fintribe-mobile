import 'package:fintribe/core/db/app_database.dart';
import 'package:fintribe/features/auth/data/local/user_dao.dart';
import 'package:fintribe/features/auth/domain/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

/// Exercises the generic [BaseDao] CRUD through the concrete [UserDao].
void main() {
  late AppDatabase appDb;
  late UserDao dao;

  User sampleUser(String id) =>
      User(id: id, email: '$id@fintribe.com', name: 'User $id');

  setUpAll(initFfi);

  setUp(() async {
    appDb = await openTestDatabase();
    dao = UserDao(appDb.db);
  });

  tearDown(() => appDb.close());

  test('upsert then findById round-trips the model', () async {
    final user = sampleUser('a');
    await dao.upsert(user);

    final loaded = await dao.findById('a');
    expect(loaded, equals(user));
  });

  test('upsert replaces on primary-key conflict', () async {
    await dao.upsert(sampleUser('a'));
    await dao.upsert(sampleUser('a').copyWith(name: 'Renamed'));

    expect(await dao.count(), 1);
    expect((await dao.findById('a'))!.name, 'Renamed');
  });

  test('upsertAll inserts everything in one batch', () async {
    await dao.upsertAll([sampleUser('a'), sampleUser('b'), sampleUser('c')]);
    expect(await dao.count(), 3);
  });

  test('findById returns null when missing', () async {
    expect(await dao.findById('missing'), isNull);
  });

  test('deleteById removes a single row', () async {
    await dao.upsertAll([sampleUser('a'), sampleUser('b')]);
    await dao.deleteById('a');

    expect(await dao.count(), 1);
    expect(await dao.findById('a'), isNull);
  });

  test('clear empties the table', () async {
    await dao.upsertAll([sampleUser('a'), sampleUser('b')]);
    await dao.clear();
    expect(await dao.count(), 0);
  });
}
