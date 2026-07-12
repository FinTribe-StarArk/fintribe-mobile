/// API endpoint constants and base URL configuration.
abstract final class ApiConstants {
  ApiConstants._();

  /// Base URLs per environment. All auth/user paths are relative to these.
  ///
  /// Dev points at the local backend. On an Android emulator use
  /// `http://10.0.2.2:8080/api/v1` instead of `localhost` (the emulator's
  /// loopback is the emulator itself).
  static const String _devBaseUrl = 'http://10.0.2.2:8080/api/v1';
  static const String _stagingBaseUrl = 'https://staging-api.fintribe.com/api/v1';
  static const String _prodBaseUrl = 'https://api.fintribe.com/api/v1';

  /// Current base URL — overridden at startup based on flavor.
  static String baseUrl = _devBaseUrl;

  /// Set base URL for a specific environment.
  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        baseUrl = _devBaseUrl;
      case Environment.staging:
        baseUrl = _stagingBaseUrl;
      case Environment.prod:
        baseUrl = _prodBaseUrl;
    }
  }

  /// Connection timeout in milliseconds.
  static const int connectTimeout = 15000;

  /// Receive timeout in milliseconds.
  static const int receiveTimeout = 15000;

  // ── Auth Endpoints ─────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // ── User Endpoints ─────────────────────────────────────────────
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/account';

  // ── Transaction Endpoints ──────────────────────────────────────
  static const String transactions = '/transactions';

  /// Path for a single transaction by [id], e.g. `/transactions/abc`.
  static String transaction(String id) => '/transactions/$id';
}

/// Application environment flavor.
enum Environment { dev, staging, prod }
