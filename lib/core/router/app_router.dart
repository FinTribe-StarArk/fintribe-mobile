import 'package:fintribe/core/router/route_names.dart';
import 'package:fintribe/features/auth/data/provider/auth_provider.dart';
import 'package:fintribe/features/auth/ui/login/login_screen.dart';
import 'package:fintribe/features/auth/ui/register/register_screen.dart';
import 'package:fintribe/features/home/ui/screen/home_screen.dart';
import 'package:fintribe/features/transactions/ui/screen/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Application router with an auth-guard redirect.
///
/// Watches [authProvider]: unauthenticated users are bounced to login, and
/// authenticated users are kept out of the auth routes. Screens therefore never
/// navigate on login/logout themselves — they just mutate auth state.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshNotifier();
  ref.listen(authProvider, (_, _) => refresh.ping());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: RouteNames.loginPath,
    debugLogDiagnostics: true,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = ref.read(authProvider).asData?.value != null;
      const authRoutes = {
        RouteNames.loginPath,
        RouteNames.registerPath,
        RouteNames.forgotPasswordPath,
      };
      final onAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!loggedIn) return onAuthRoute ? null : RouteNames.loginPath;
      if (onAuthRoute) return RouteNames.homePath;
      return null;
    },
    routes: [
      // ── Auth ────────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordPath,
        name: RouteNames.forgotPassword,
        builder: (_, _) => const _Placeholder(title: 'Lupa Kata Sandi'),
      ),

      // ── Main ────────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.homePath,
        name: RouteNames.home,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.transactionsPath,
        name: RouteNames.transactions,
        builder: (_, _) => const TransactionsScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboardPath,
        name: RouteNames.dashboard,
        builder: (_, _) => const _Placeholder(title: 'Dashboard'),
      ),
      GoRoute(
        path: RouteNames.profilePath,
        name: RouteNames.profile,
        builder: (_, _) => const _Placeholder(title: 'Profile'),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (_, _) => const _Placeholder(title: 'Settings'),
      ),
    ],
  );
});

/// Bridges Riverpod auth changes to GoRouter's `refreshListenable`.
class _AuthRefreshNotifier extends ChangeNotifier {
  void ping() => notifyListeners();
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title — coming soon')),
  );
}
