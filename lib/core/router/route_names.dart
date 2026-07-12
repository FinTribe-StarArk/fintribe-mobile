/// Named route constants for GoRouter.
abstract final class RouteNames {
  RouteNames._();

  // ── Auth ───────────────────────────────────────────────────────
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String verifyEmail = 'verifyEmail';

  // ── Main ───────────────────────────────────────────────────────
  static const String home = 'home';
  static const String dashboard = 'dashboard';
  static const String transactions = 'transactions';
  static const String profile = 'profile';
  static const String settings = 'settings';

  // ── Paths ──────────────────────────────────────────────────────
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String forgotPasswordPath = '/forgot-password';
  static const String verifyEmailPath = '/verify-email';
  static const String homePath = '/';
  static const String dashboardPath = '/dashboard';
  static const String transactionsPath = '/transactions';
  static const String profilePath = '/profile';
  static const String settingsPath = '/settings';
}
