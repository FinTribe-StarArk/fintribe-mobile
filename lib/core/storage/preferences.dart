import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for simple key-value preferences.
///
/// Used for non-sensitive settings such as theme mode, locale, etc.
abstract class Preferences {
  /// Reads a string value.
  Future<String?> getString(String key);

  /// Writes a string value.
  Future<void> setString(String key, String value);

  /// Reads a boolean value.
  Future<bool?> getBool(String key);

  /// Writes a boolean value.
  Future<void> setBool(String key, bool value);

  /// Reads an integer value.
  Future<int?> getInt(String key);

  /// Writes an integer value.
  Future<void> setInt(String key, int value);

  /// Removes a value.
  Future<void> remove(String key);
}

/// Production implementation using SharedPreferences.
final class SharedPreferencesPreferences implements Preferences {
  SharedPreferencesPreferences(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<String?> getString(String key) async => _preferences.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async => _preferences.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async => _preferences.getInt(key);

  @override
  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }
}

/// In-memory implementation of [Preferences] for development.
///
/// Use `SharedPreferences` in production.
final class InMemoryPreferences implements Preferences {
  final Map<String, dynamic> _store = {};

  @override
  Future<String?> getString(String key) async => _store[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _store[key] as bool?;

  @override
  Future<void> setBool(String key, bool value) async {
    _store[key] = value;
  }

  @override
  Future<int?> getInt(String key) async => _store[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    _store[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }
}
