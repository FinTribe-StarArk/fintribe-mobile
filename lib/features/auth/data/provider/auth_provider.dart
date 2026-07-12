import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintribe/core/providers.dart';
import 'package:fintribe/features/auth/domain/model/user.dart';

class Auth extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final repo = ref.watch(authRepoProvider);
    return repo.fetchCurrentUser();
  }

  /// Email + password login.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepoProvider).login(email, password),
    );
  }

  /// Register a new account.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepoProvider)
          .register(name: name, email: email, password: password),
    );
  }

  /// Log out.
  Future<void> logout() async {
    await ref.read(authRepoProvider).logout();
    state = const AsyncData(null);
  }

  /// Force re-check (e.g. after token refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepoProvider).fetchCurrentUser(),
    );
  }
}

final authProvider = AsyncNotifierProvider<Auth, User?>(Auth.new);

final isLoggedInProvider = Provider<bool>((ref) {
  return ref
      .watch(authProvider)
      .maybeWhen(data: (user) => user != null, orElse: () => false);
});

final currentUserProvider = Provider<User?>((ref) {
  return ref
      .watch(authProvider)
      .maybeWhen(data: (user) => user, orElse: () => null);
});
