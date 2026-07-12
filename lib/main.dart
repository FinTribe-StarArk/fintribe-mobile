import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/providers.dart';
import 'package:fintribe/core/router/app_router.dart';
import 'package:fintribe/core/theme/app_theme.dart';

/// Application entry point.
///
/// Initializes SQLite, sets up Riverpod, and launches the app with
/// GoRouter navigation, light/dark theme support, and the configured
/// API base URL for the given [environment].
///
/// Usage:
/// ```dart
/// void main() {
///   FinTribeApp.run(Environment.dev);
/// }
/// ```
final class FinTribeApp extends ConsumerWidget {
  /// Creates the app shell. Does NOT call [runApp] — use [run].
  const FinTribeApp({super.key});

  /// Bootstrap the app with the given [environment] and call [runApp].
  static Future<void> run(Environment environment) async {
    WidgetsFlutterBinding.ensureInitialized();
    ApiConstants.setEnvironment(environment);
    runApp(const ProviderScope(child: FinTribeApp()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final initAsync = ref.watch(appInitializationProvider);

    return initAsync.when(
      data: (_) => MaterialApp.router(
        title: 'FinTribe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: ref.watch(routerProvider),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Initialization failed: $error')),
        ),
      ),
    );
  }
}
