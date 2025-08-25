import 'package:equatable/equatable.dart';

/// Base exception class for application errors
abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.details});
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException({required super.message, super.code, super.details});
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.details});
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException({required super.message, super.code, super.details});
}
