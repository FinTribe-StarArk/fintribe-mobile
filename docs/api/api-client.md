# API Client

## Overview

The API client is built on **Dio** with the following features:

- Auth token injection (via interceptor)
- Automatic token refresh on 401
- Pretty-printed request/response logging
- Structured error handling
- Typed API responses

## Making API Calls

```dart
// In a repository — concrete final class, no abstract interface, no Impl suffix.
final class AuthRepo {
  const AuthRepo({required this.apiClient, ...});

  final ApiClient apiClient;

  Future<User> login(String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return User.fromJson(response.data['user'] as Map<String, dynamic>);
  }
}
```

## ApiClient Methods

| Method              | Description                        |
|---------------------|------------------------------------|
| `get<T>(path, ...)` | HTTP GET request                   |
| `post<T>(path, ...)`| HTTP POST request                  |
| `put<T>(path, ...)` | HTTP PUT request                   |
| `patch<T>(path, ...)`| HTTP PATCH request                |
| `delete<T>(path, ...)`| HTTP DELETE request              |

All methods return `ApiResponse<T>` and throw typed exceptions on failure.

## Interceptor Chain

1. **LoggingInterceptor** — Logs all requests/responses in pretty format (dev only).
2. **AuthInterceptor** — Injects Bearer token; handles 401 → token refresh → retry.
3. **ErrorInterceptor** — Maps DioException to app-specific exceptions.
