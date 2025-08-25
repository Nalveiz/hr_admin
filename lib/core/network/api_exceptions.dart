/// Base exception class for API errors
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Network connection exception
class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Server error exception (5xx)
class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Client error exception (4xx)
class ClientException extends ApiException {
  const ClientException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Authentication exception (401, 403)
class AuthException extends ApiException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Validation exception (422)
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    required super.message,
    super.statusCode,
    super.originalError,
    this.errors,
  });
}

/// Not found exception (404)
class NotFoundException extends ApiException {
  const NotFoundException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Timeout exception
class TimeoutException extends ApiException {
  const TimeoutException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}
