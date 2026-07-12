# Error Handling

## Exception Hierarchy

```
AppException (abstract)
├── NetworkException
│   ├── NoInternetException
│   ├── TimeoutException
│   └── ServerException
├── AuthException
│   ├── UnauthorizedException
│   ├── TokenExpiredException
│   └── ForbiddenException
├── ValidationException
└── UnknownException
```

## Handling in Repositories

```dart
Future<Result<User, AppException>> login(String email, String password) async {
  try {
    final response = await apiClient.post(ApiConstants.login, data: {...});
    return Result.success(UserModel.fromJson(response.data).toEntity());
  } on AppException catch (e) {
    return Result.failure(e);
  }
}
```

## Handling in UI

```dart
final authState = ref.watch(authStateProvider);

authState.when(
  data: (user) => DashboardScreen(user: user),
  loading: () => const AppLoader(),
  error: (error, stack) => AppErrorWidget(
    message: error is AppException ? error.userMessage : 'Something went wrong',
    onRetry: () => ref.invalidate(authStateProvider),
  ),
);
```

## User-Facing Messages

Each exception provides a `userMessage` getter for display:

```dart
class NoInternetException extends NetworkException {
  @override
  String get userMessage => 'No internet connection. Please check your network.';
}
```
