import 'package:dio/dio.dart';
import 'package:fintribe/core/network/network_exceptions.dart';

/// Maps raw exceptions and [DioException]s to typed [NetworkException] subclasses.
abstract final class ErrorHandler {
  ErrorHandler._();

  /// Converts an exception into the appropriate [NetworkException].
  static NetworkException handle(dynamic error) {
    if (error is NetworkException) return error;

    if (error is NoInternetException ||
        (error is DioException &&
            error.type == DioExceptionType.connectionError)) {
      return const NoInternetException();
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return TimeoutException(
            message: error.message ?? 'Request timed out',
          );
        case DioExceptionType.badResponse:
          return _mapStatusCode(error.response?.statusCode, error.response);
        case DioExceptionType.cancel:
          return const NetworkException(message: 'Request was cancelled');
        case DioExceptionType.badCertificate:
          return const NetworkException(message: 'Invalid server certificate');
        case DioExceptionType.connectionError:
          return const NoInternetException();
        case DioExceptionType.unknown:
          return NetworkException(
            message: error.message ?? 'An unknown error occurred',
          );
      }
    }

    return UnknownException(message: error.toString(), originalError: error);
  }

  static NetworkException _mapStatusCode(
    int? statusCode,
    Response<dynamic>? response,
  ) {
    final serverMessage = response?.data is Map
        ? response?.data['message'] as String?
        : null;
    final message = serverMessage ?? 'Something went wrong';

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message);
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return NotFoundException(message: message);
      case 409:
        return ConflictException(message: message);
      case 422:
        return ValidationException(
          message: message,
          errors: _extractValidationErrors(response),
        );
      case 429:
        return const TooManyRequestsException();
      case 500:
      case 501:
      case 502:
      case 503:
        return ServerException(
          message: serverMessage ?? 'Server error. Please try again later.',
          statusCode: statusCode ?? 500,
        );
      default:
        return ServerException(message: message, statusCode: statusCode ?? 0);
    }
  }

  static Map<String, List<String>>? _extractValidationErrors(
    Response<dynamic>? response,
  ) {
    if (response?.data is Map && response!.data['errors'] is Map) {
      final errors = <String, List<String>>{};
      (response.data['errors'] as Map).forEach((key, value) {
        if (value is List) {
          errors[key.toString()] = value.cast<String>();
        }
      });
      return errors;
    }
    return null;
  }
}
