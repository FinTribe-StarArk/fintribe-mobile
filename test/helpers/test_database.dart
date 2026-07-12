import 'package:fintribe/core/db/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Opens a fresh in-memory [AppDatabase] backed by the sqflite FFI factory.
///
/// Call [initFfi] once per test file (in `setUpAll`) before using this.
/// Each call returns an isolated database, so tests never share state.
Future<AppDatabase> openTestDatabase() async {
  final db = AppDatabase(factory: databaseFactoryFfi);
  await db.open(inMemoryDatabasePath);
  return db;
}

/// Initializes the sqflite FFI backend. Safe to call multiple times.
void initFfi() => sqfliteFfiInit();
