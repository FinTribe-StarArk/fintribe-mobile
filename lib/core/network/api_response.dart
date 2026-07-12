import 'package:dio/dio.dart';

/// Generic wrapper for API responses.
///
/// Provides typed access to response data, status, and headers.
final class ApiResponse<T> {
  /// Creates an [ApiResponse] from raw values.
  const ApiResponse({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    this.headers,
    this.meta,
  });

  /// Creates an [ApiResponse] from a Dio [Response].
  factory ApiResponse.fromDioResponse(Response<T> response) {
    return ApiResponse(
      data: response.data,
      statusCode: response.statusCode ?? 200,
      statusMessage: response.statusMessage ?? 'OK',
      headers: response.headers.map,
      meta: response.data is Map
          ? (response.data as Map)['meta'] as Map<String, dynamic>?
          : null,
    );
  }

  /// The response body data.
  final T? data;

  /// HTTP status code.
  final int statusCode;

  /// HTTP status message.
  final String statusMessage;

  /// Response headers.
  final Map<String, List<String>>? headers;

  /// Pagination metadata if present.
  final Map<String, dynamic>? meta;

  /// Whether the response indicates success (2xx).
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Whether the response has data.
  bool get hasData => data != null;

  @override
  String toString() => 'ApiResponse($statusCode): $data';
}
