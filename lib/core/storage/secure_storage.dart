import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction for secure token storage.
///
/// Implementations should use platform-specific secure storage
/// (e.g., flutter_secure_storage, Keychain, or EncryptedSharedPreferences).
abstract class SecureStorage {
  /// Reads a value by [key]. Returns `null` if not found.
  Future<String?> read(String key);

  /// Writes a [value] to [key].
  Future<void> write(String key, String value);

  /// Deletes the value at [key].
  Future<void> delete(String key);

  /// Clears all stored values.
  Future<void> clearAll();
}

/// Production implementation using platform secure storage.
final class FlutterSecureStorageService implements SecureStorage {
  const FlutterSecureStorageService([this._storage]);

  final FlutterSecureStorage? _storage;

  FlutterSecureStorage get storage =>
      _storage ??
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
      );

  @override
  Future<String?> read(String key) async => await storage.read(key: key);

  @override
  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  @override
  Future<void> clearAll() async {
    await storage.deleteAll();
  }
}

/// In-memory implementation of [SecureStorage] for development.
///
/// ⚠️ NOT secure. Use only for local development and testing.
/// Replace with [`FlutterSecureStorage`](https://pub.dev/packages/flutter_secure_storage)
/// in production builds.
final class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clearAll() async {
    _store.clear();
  }
}
