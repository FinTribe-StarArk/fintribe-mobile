/// Storage key constants (SQLite DB name, secure-storage & preference keys).
abstract final class StorageConstants {
  StorageConstants._();

  // ── SQLite ─────────────────────────────────────────────────────
  static const String databaseName = 'fintribe.db';

  // ── Secure Storage Keys ────────────────────────────────────────
  static const String accessToken = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';

  // ── Preferences Keys ───────────────────────────────────────────
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String onboardingComplete = 'onboarding_complete';
  static const String biometricEnabled = 'biometric_enabled';
}
