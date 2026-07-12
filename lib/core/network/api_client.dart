import 'package:dio/dio.dart';
import 'package:fintribe/core/network/api_response.dart';
import 'package:fintribe/core/network/error_handler.dart';

/// Thin, typed wrapper over [Dio]. The `apiClientProvider` that constructs it
/// lives in `lib/core/providers.dart`.
///
/// Intentionally not `final` so repositories can mock it in unit tests.
class ApiClient {
  /// Creates an [ApiClient] with the given [dio] instance.
  const ApiClient({required this.dio});

  /// The underlying Dio HTTP client.
  final Dio dio;

  /// Sends a GET request to [path].
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromDioResponse(response);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Sends a POST request to [path].
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromDioResponse(response);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Sends a PUT request to [path].
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromDioResponse(response);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Sends a PATCH request to [path].
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromDioResponse(response);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Sends a DELETE request to [path].
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromDioResponse(response);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
