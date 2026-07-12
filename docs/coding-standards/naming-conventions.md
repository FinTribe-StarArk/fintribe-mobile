# Naming Conventions

## Files

| Type              | Convention              | Example                        |
|-------------------|-------------------------|--------------------------------|
| Dart files        | `snake_case`            | `login_screen.dart`            |
| Generated files   | `*.g.dart`, `*.freezed.dart` | `user.freezed.dart`      |
| Test files        | `*_test.dart`           | `auth_provider_test.dart`      |
| Asset files       | `snake_case`            | `app_logo.png`                 |

## Classes & Mixins

| Type              | Convention              | Example                        |
|-------------------|-------------------------|--------------------------------|
| Classes           | `PascalCase`            | `LoginScreen`                  |
| Mixins            | `PascalCase`            | `ValidationMixin`              |
| Extensions        | `PascalCase` + `Extension` | `ContextExtension`          |
| Enums             | `PascalCase`            | `AuthStatus`                   |
| Enum values       | `camelCase`             | `authStatus.pending`           |

## Variables & Functions

| Type              | Convention              | Example                        |
|-------------------|-------------------------|--------------------------------|
| Variables         | `camelCase`             | `userId`, `isLoading`          |
| Constants         | `camelCase`             | `apiBaseUrl`                   |
| Static const      | `camelCase`             | `AppColors.primary`            |
| Functions         | `camelCase`             | `fetchUserData()`              |
| Private members   | `_` prefix              | `_onSubmit()`                  |
| Booleans          | `is`/`has`/`should` prefix | `isLoading`, `hasError`    |

## Providers (Riverpod)

| Type              | Convention              | Example                        |
|-------------------|-------------------------|--------------------------------|
| Provider variable | `camelCase` + `Provider` | `authStateProvider`          |
| Notifier class    | `PascalCase` + `Notifier` | `AuthNotifier`              |
| Async provider    | `camelCase` + `Provider` | `userDataProvider`           |

## Routes

| Type              | Convention              | Example                        |
|-------------------|-------------------------|--------------------------------|
| Route path        | `kebab-case`            | `/user-profile`, `/auth/login` |
| Route name        | `camelCase`             | `userProfile`, `authLogin`     |

## Example

```dart
// File: lib/features/auth/data/provider/auth_provider.dart
// Manual provider — no @riverpod codegen.
class Auth extends AsyncNotifier<User?> {
  @override
  Future<User?> build() => ref.watch(authRepoProvider).fetchCurrentUser();

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepoProvider).login(email, password),
    );
  }
}

final authProvider = AsyncNotifierProvider<Auth, User?>(Auth.new);

// File: lib/features/auth/domain/model/user.dart
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String displayName,
    @Default(false) bool isEmailVerified,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```
