import 'package:dio/dio.dart';
import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/constants/storage_constants.dart';
import 'package:fintribe/core/utils/helpers/logger.dart';
import 'package:fintribe/core/storage/secure_storage.dart';

/// Interceptor that injects the Bearer auth token into every request
/// and handles automatic token refresh on 401 responses.
final class AuthInterceptor extends Interceptor {
  /// Creates an [AuthInterceptor].
  AuthInterceptor({required this.secureStorage});

  /// Secure storage for reading/writing tokens.
  final SecureStorage secureStorage;

  /// Prevents concurrent refresh token calls.
  bool _isRefreshing = false;

  /// Queued requests waiting for token refresh.
  final List<_QueuedRequest> _queue = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login/register/refresh endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await secureStorage.read(StorageConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.I.d('🔐 Auth token injected for ${options.path}');
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        _isPublicEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    AppLogger.I.w(
      '⚠️ 401 received for ${err.requestOptions.path}, attempting refresh...',
    );

    if (_isRefreshing) {
      // Queue this request until refresh completes
      final completer = _QueuedRequest(err, handler);
      _queue.add(completer);
      return;
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshToken();
      if (newToken != null) {
        await secureStorage.write(StorageConstants.accessToken, newToken);

        // Retry the original request
        final response = await _retry(err.requestOptions, newToken);
        handler.resolve(response);

        // Process queued requests
        for (final queued in _queue) {
          final retryResponse = await _retry(
            queued.error.requestOptions,
            newToken,
          );
          queued.handler.resolve(retryResponse);
        }
      } else {
        // No refresh token available — propagate error
        handler.next(err);
        _rejectQueued(err);
      }
    } on DioException catch (e) {
      handler.next(e);
      _rejectQueued(e);
    } finally {
      _isRefreshing = false;
      _queue.clear();
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await secureStorage.read(
        StorageConstants.refreshTokenKey,
      );
      if (refreshToken == null || refreshToken.isEmpty) return null;

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      return response.data?['access_token'] as String?;
    } catch (e) {
      AppLogger.I.e('Token refresh failed', error: e);
      // Clear tokens on refresh failure
      await secureStorage.delete(StorageConstants.accessToken);
      await secureStorage.delete(StorageConstants.refreshTokenKey);
      return null;
    }
  }

  Future<Response<dynamic>> _retry(
    RequestOptions requestOptions,
    String token,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void _rejectQueued(DioException err) {
    for (final queued in _queue) {
      queued.handler.next(err);
    }
  }

  bool _isPublicEndpoint(String path) {
    const publicPaths = [
      ApiConstants.login,
      ApiConstants.register,
      ApiConstants.refreshToken,
      ApiConstants.forgotPassword,
      ApiConstants.resetPassword,
    ];
    return publicPaths.contains(path);
  }
}

class _QueuedRequest {
  _QueuedRequest(this.error, this.handler);

  final DioException error;
  final ErrorInterceptorHandler handler;
}
