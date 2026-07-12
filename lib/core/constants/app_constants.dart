/// App-wide compile-time constants.
abstract final class AppConstants {
  AppConstants._();

  /// App name displayed in UI.
  static const String appName = 'FinTribe';

  /// Current app version.
  static const String appVersion = '0.1.0';

  /// Default locale.
  static const String defaultLocale = 'en';

  /// Supported locales.
  static const List<String> supportedLocales = ['en', 'id'];
}
