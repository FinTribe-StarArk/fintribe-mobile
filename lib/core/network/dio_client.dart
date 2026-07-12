import 'package:dio/dio.dart';
import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/network/auth_interceptor.dart';
import 'package:fintribe/core/storage/secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Factory for creating pre-configured [Dio] instances.
abstract final class DioClient {
  DioClient._();

  /// Creates a [Dio] instance with interceptors and default configuration.
  static Dio create({
    required String baseUrl,
    required SecureStorage secureStorage,
    bool enableLogging = true,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage: secureStorage),
      if (enableLogging) PrettyDioLogger(),
    ]);

    return dio;
  }
}
