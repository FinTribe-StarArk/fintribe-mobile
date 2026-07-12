import 'package:fintribe/core/db/base_dao.dart';
import 'package:fintribe/core/db/db_mappers.dart';
import 'package:fintribe/core/db/db_tables.dart';
import 'package:fintribe/features/auth/domain/model/user.dart';

/// Local cache of the signed-in [User].
///
/// Lets the app show the current user immediately on launch (offline-first)
/// before — or instead of — a network profile fetch.
final class UserDao extends BaseDao<User> {
  /// Creates a [UserDao] over the open database.
  UserDao(super.db);

  @override
  String get table => DbTables.users;

  @override
  Map<String, Object?> toDb(User m) => {
    'id': m.id,
    'email': m.email,
    'name': m.name,
    'photo_url': m.photoUrl,
    'created_at': DbMap.dateToIso(m.createdAt),
    'updated_at': DbMap.dateToIso(m.updatedAt),
  };

  @override
  User fromDb(Map<String, Object?> row) => User(
    id: row['id']! as String,
    email: row['email']! as String,
    name: row['name'] as String?,
    photoUrl: row['photo_url'] as String?,
    createdAt: DbMap.isoToDateOrNull(row['created_at']),
    updatedAt: DbMap.isoToDateOrNull(row['updated_at']),
  );

  /// The most recently cached user, if any.
  Future<User?> current() async {
    final rows = await findAll(limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  /// Replaces the cached user with [user].
  Future<void> cache(User user) async {
    await clear();
    await upsert(user);
  }
}
