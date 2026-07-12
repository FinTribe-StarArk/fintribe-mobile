import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/constants/storage_constants.dart';
import 'package:fintribe/core/db/app_database.dart';
import 'package:fintribe/core/network/api_client.dart';
import 'package:fintribe/core/network/connectivity_service.dart';
import 'package:fintribe/core/network/dio_client.dart';
import 'package:fintribe/core/storage/preferences.dart';
import 'package:fintribe/core/storage/secure_storage.dart';
import 'package:fintribe/core/sync/outbox_dao.dart';
import 'package:fintribe/core/sync/sync_engine.dart';
import 'package:fintribe/features/auth/data/local/user_dao.dart';
import 'package:fintribe/features/auth/data/repo/auth_repo.dart';
import 'package:fintribe/features/transactions/data/local/transaction_dao.dart';
import 'package:fintribe/features/transactions/data/repo/transaction_repo.dart';
import 'package:fintribe/features/transactions/data/sync/transaction_sync_handler.dart';

/// Central dependency-injection graph.
///
/// Low-level singletons (storage, database, network, sync) live here so
/// features can compose them without re-declaring wiring. Feature-facing
/// providers (e.g. `transactionsProvider`) live in their feature folders and
/// read from these.

/// ─────────────────────────────────────────────────────────────
/// Storage
/// ─────────────────────────────────────────────────────────────

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return const FlutterSecureStorageService();
});

final sharedPreferencesInitProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

final preferencesProvider = Provider<Preferences>((ref) {
  return ref
      .watch(sharedPreferencesInitProvider)
      .when(
        data: (prefs) => SharedPreferencesPreferences(prefs),
        loading: () => InMemoryPreferences(),
        error: (_, _) => InMemoryPreferences(),
      );
});

/// ─────────────────────────────────────────────────────────────
/// Database (SQLite) & DAOs
/// ─────────────────────────────────────────────────────────────

/// The database owner. Opened once in [appInitializationProvider].
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// The open connection. Throws until [appInitializationProvider] completes.
final databaseProvider = Provider<Database>((ref) {
  return ref.watch(appDatabaseProvider).db;
});

final userDaoProvider = Provider<UserDao>(
  (ref) => UserDao(ref.watch(databaseProvider)),
);

final transactionDaoProvider = Provider<TransactionDao>(
  (ref) => TransactionDao(ref.watch(databaseProvider)),
);

final outboxDaoProvider = Provider<OutboxDao>(
  (ref) => OutboxDao(ref.watch(databaseProvider)),
);

/// ─────────────────────────────────────────────────────────────
/// Network & Connectivity
/// ─────────────────────────────────────────────────────────────

final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityPlusService();
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(
    baseUrl: ApiConstants.baseUrl,
    secureStorage: ref.watch(secureStorageProvider),
    enableLogging: true,
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(dio: ref.watch(dioProvider));
});

/// ─────────────────────────────────────────────────────────────
/// Sync engine
/// ─────────────────────────────────────────────────────────────

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    outboxDao: ref.watch(outboxDaoProvider),
    connectivity: ref.watch(connectivityProvider),
  );
  ref.onDispose(engine.stop);
  return engine;
});

/// ─────────────────────────────────────────────────────────────
/// Repositories
/// ─────────────────────────────────────────────────────────────

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
    userDao: ref.watch(userDaoProvider),
  );
});

final transactionRepoProvider = Provider<TransactionRepo>((ref) {
  return TransactionRepo(
    api: ref.watch(apiClientProvider),
    local: ref.watch(transactionDaoProvider),
    outbox: ref.watch(outboxDaoProvider),
  );
});

/// ─────────────────────────────────────────────────────────────
/// Theme
/// ─────────────────────────────────────────────────────────────

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> loadInitialTheme() async {
    final modeName = await ref
        .read(preferencesProvider)
        .getString(StorageConstants.themeMode);
    if (modeName == null) return;

    final loadedMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == modeName,
      orElse: () => ThemeMode.system,
    );

    state = loadedMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(preferencesProvider)
        .setString(StorageConstants.themeMode, mode.name);
  }

  Future<void> toggle() async {
    await setThemeMode(
      state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// ─────────────────────────────────────────────────────────────
/// Bootstrap
/// ─────────────────────────────────────────────────────────────

/// One-shot startup: open the DB, load prefs/theme, register sync handlers,
/// and start connectivity-driven sync. The UI waits on this before rendering.
final appInitializationProvider = FutureProvider<bool>((ref) async {
  await ref.watch(appDatabaseProvider).open(await AppDatabase.defaultPath());
  await ref.watch(sharedPreferencesInitProvider.future);
  await ref.read(themeModeProvider.notifier).loadInitialTheme();

  final engine = ref.read(syncEngineProvider)
    ..register(
      TransactionSyncHandler(
        api: ref.read(apiClientProvider),
        local: ref.read(transactionDaoProvider),
      ),
    )
    ..start();
  // Flush anything queued from a previous offline session.
  await engine.sync();

  return true;
});
