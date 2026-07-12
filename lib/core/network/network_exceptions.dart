/// Base class for all network-related exceptions.
 class NetworkException implements Exception {
  /// Creates a [NetworkException].
  const NetworkException({
    this.message = 'A network error occurred',
    this.statusCode,
  });

  /// Human-readable error message.
  final String message;

  /// HTTP status code if applicable.
  final int? statusCode;

  /// User-friendly message suitable for display.
  String get userMessage => message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when there is no internet connection.
final class NoInternetException extends NetworkException {
  /// Creates a [NoInternetException].
  const NoInternetException() : super(message: 'No internet connection');

  @override
  String get userMessage =>
      'No internet connection. Please check your network and try again.';
}

/// Thrown when a request times out.
final class TimeoutException extends NetworkException {
  /// Creates a [TimeoutException].
  const TimeoutException({super.message = 'Request timed out'});

  @override
  String get userMessage => 'The request took too long. Please try again.';
}

/// Thrown when the server returns a 400 status.
final class BadRequestException extends NetworkException {
  /// Creates a [BadRequestException].
  const BadRequestException({super.message = 'Bad request'});
}

/// Thrown when the user is not authenticated (401).
final class UnauthorizedException extends NetworkException {
  /// Creates an [UnauthorizedException].
  const UnauthorizedException()
    : super(message: 'Unauthorized', statusCode: 401);

  @override
  String get userMessage => 'Your session has expired. Please log in again.';
}

/// Thrown when the user lacks permissions (403).
final class ForbiddenException extends NetworkException {
  /// Creates a [ForbiddenException].
  const ForbiddenException() : super(message: 'Forbidden', statusCode: 403);

  @override
  String get userMessage =>
      'You don\'t have permission to perform this action.';
}

/// Thrown when a resource is not found (404).
final class NotFoundException extends NetworkException {
  /// Creates a [NotFoundException].
  const NotFoundException({super.message = 'Resource not found'});
}

/// Thrown on conflict (409).
final class ConflictException extends NetworkException {
  /// Creates a [ConflictException].
  const ConflictException({super.message = 'Resource conflict'});
}

/// Thrown on validation errors (422).
final class ValidationException extends NetworkException {
  /// Creates a [ValidationException].
  const ValidationException({super.message = 'Validation failed', this.errors})
    : super(statusCode: 422);

  /// Field-level validation errors.
  final Map<String, List<String>>? errors;

  @override
  String get userMessage {
    if (errors != null && errors!.isNotEmpty) {
      final firstError = errors!.values.first.first;
      return firstError;
    }
    return message;
  }
}

/// Thrown on rate limiting (429).
final class TooManyRequestsException extends NetworkException {
  /// Creates a [TooManyRequestsException].
  const TooManyRequestsException()
    : super(message: 'Too many requests', statusCode: 429);

  @override
  String get userMessage =>
      'Too many requests. Please wait a moment and try again.';
}

/// Thrown on server errors (5xx).
final class ServerException extends NetworkException {
  /// Creates a [ServerException].
  const ServerException({
    super.message = 'Internal server error',
    super.statusCode = 500,
  });

  @override
  String get userMessage =>
      'Something went wrong on our end. Please try again later.';
}

/// Thrown for unexpected/unclassified errors.
final class UnknownException extends NetworkException {
  /// Creates an [UnknownException].
  const UnknownException({
    super.message = 'An unexpected error occurred',
    this.originalError,
  });

  /// The original error that caused this exception.
  final dynamic originalError;
}
