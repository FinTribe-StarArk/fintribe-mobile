import 'dart:convert';

import 'package:fintribe/core/constants/storage_constants.dart';
import 'package:fintribe/core/db/app_database.dart';
import 'package:fintribe/core/network/api_client.dart';
import 'package:fintribe/core/network/api_response.dart';
import 'package:fintribe/core/storage/secure_storage.dart';
import 'package:fintribe/features/auth/data/local/user_dao.dart';
import 'package:fintribe/features/auth/data/repo/auth_repo.dart';
import 'package:fintribe/features/auth/domain/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_database.dart';

class MockApiClient extends Mock implements ApiClient {}

/// Builds an unsigned JWT with [payload] as its claims (test-only).
String fakeJwt(Map<String, dynamic> payload) {
  String seg(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  return '${seg({'alg': 'HS256'})}.${seg(payload)}.sig';
}

void main() {
  late AppDatabase appDb;
  late UserDao userDao;
  late MockApiClient api;
  late InMemorySecureStorage storage;
  late AuthRepo repo;

  const userId = 'c197342a-5834-4b76-897f-d47c3a958a36';
  const email = 'dafa@example.com';

  // A token valid until well into the future.
  final validToken = fakeJwt({
    'user_id': userId,
    'email': email,
    'exp': DateTime(2999).millisecondsSinceEpoch ~/ 1000,
  });

  ApiResponse<Map<String, dynamic>> tokenResponse(String token) =>
      ApiResponse<Map<String, dynamic>>(
        data: {
          'success': true,
          'message': 'ok',
          'data': {'token': token},
        },
        statusCode: 200,
        statusMessage: 'OK',
      );

  setUpAll(initFfi);

  setUp(() async {
    appDb = await openTestDatabase();
    userDao = UserDao(appDb.db);
    api = MockApiClient();
    storage = InMemorySecureStorage();
    repo = AuthRepo(apiClient: api, secureStorage: storage, userDao: userDao);
  });

  tearDown(() => appDb.close());

  test('login derives the user from the JWT and stores the token', () async {
    when(
      () => api.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
    ).thenAnswer((_) async => tokenResponse(validToken));

    final user = await repo.login(email, 'Password123');

    expect(user.id, userId);
    expect(user.email, email);
    expect(await storage.read(StorageConstants.accessToken), validToken);
    expect((await userDao.current())!.id, userId);
  });

  test('register keeps the name from the form on the derived user', () async {
    when(
      () => api.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
    ).thenAnswer((_) async => tokenResponse(validToken));

    final user = await repo.register(
      name: 'Dafa Aldian',
      email: email,
      password: 'Password123',
    );

    expect(user.name, 'Dafa Aldian');
    expect(user.email, email);
    expect((await userDao.current())!.name, 'Dafa Aldian');
  });

  test('throws when the server response carries no token', () async {
    when(
      () => api.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
    ).thenAnswer(
      (_) async => const ApiResponse<Map<String, dynamic>>(
        data: {'success': true, 'data': {}},
        statusCode: 200,
        statusMessage: 'OK',
      ),
    );

    expect(() => repo.login(email, 'x'), throwsA(isA<Exception>()));
  });

  test('fetchCurrentUser returns null when no token is stored', () async {
    expect(await repo.fetchCurrentUser(), isNull);
  });

  test('fetchCurrentUser returns the cached user for a valid token', () async {
    await storage.write(StorageConstants.accessToken, validToken);
    await userDao.cache(const User(id: userId, email: email, name: 'Dafa'));

    final user = await repo.fetchCurrentUser();
    expect(user!.name, 'Dafa');
  });

  test('fetchCurrentUser clears an expired token', () async {
    final expired = fakeJwt({
      'user_id': userId,
      'email': email,
      'exp': DateTime(2000).millisecondsSinceEpoch ~/ 1000,
    });
    await storage.write(StorageConstants.accessToken, expired);
    await userDao.cache(const User(id: userId, email: email));

    expect(await repo.fetchCurrentUser(), isNull);
    expect(await storage.read(StorageConstants.accessToken), isNull);
    expect(await userDao.current(), isNull);
  });

  test('logout clears the token and cached user', () async {
    await storage.write(StorageConstants.accessToken, validToken);
    await userDao.cache(const User(id: userId, email: email));

    await repo.logout();

    expect(await storage.read(StorageConstants.accessToken), isNull);
    expect(await userDao.current(), isNull);
  });
}
