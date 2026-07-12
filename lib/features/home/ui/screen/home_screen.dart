import 'package:fintribe/core/constants/ui_constants.dart';
import 'package:fintribe/core/router/route_names.dart';
import 'package:fintribe/core/utils/helpers/extensions/context_extensions.dart';
import 'package:fintribe/features/auth/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Placeholder home shown after authentication.
///
/// Confirms the signed-in user and offers logout + a jump to the (already
/// built) transactions feature. Replace with the real dashboard later.
final class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FinTribe'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(UiConstants.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: context.colorScheme.primaryContainer,
                child: Text(
                  user?.initials ?? '?',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: UiConstants.spacingLg),
              Text(
                'Halo, ${user?.displayName ?? 'Pengguna'} 👋',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UiConstants.spacingXs),
              Text(
                user?.email ?? '',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: UiConstants.spacingXl),
              FilledButton.icon(
                onPressed: () => context.pushNamed(RouteNames.transactions),
                icon: const Icon(Icons.receipt_long),
                label: const Text('Lihat Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
