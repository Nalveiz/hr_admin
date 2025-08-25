import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import '../network/api_exceptions.dart';

/// HTTP interceptor for handling API errors and logging
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _mapDioExceptionToApiException(err);

    // Log the error (you can integrate with your logging service)
    developer.log(
      'API Error: ${apiException.message}',
      name: 'ErrorInterceptor',
    );
    developer.log(
      'Status Code: ${apiException.statusCode}',
      name: 'ErrorInterceptor',
    );
    developer.log(
      'Original Error: ${apiException.originalError}',
      name: 'ErrorInterceptor',
    );

    super.onError(err, handler);
  }

  ApiException _mapDioExceptionToApiException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Request timeout occurred',
          statusCode: dioException.response?.statusCode,
          originalError: dioException,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Network connection error',
          statusCode: dioException.response?.statusCode,
          originalError: dioException,
        );

      case DioExceptionType.badResponse:
        return _mapResponseStatusToException(dioException);

      case DioExceptionType.cancel:
        return ClientException(
          message: 'Request was cancelled',
          statusCode: dioException.response?.statusCode,
          originalError: dioException,
        );

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: dioException.message ?? 'Unknown error occurred',
          statusCode: dioException.response?.statusCode,
          originalError: dioException,
        );
    }
  }

  ApiException _mapResponseStatusToException(DioException dioException) {
    final statusCode = dioException.response?.statusCode;
    final message =
        _extractErrorMessage(dioException.response?.data) ??
        dioException.message ??
        'Unknown error occurred';

    switch (statusCode) {
      case 400:
        return ClientException(
          message: message,
          statusCode: statusCode,
          originalError: dioException,
        );

      case 401:
        return AuthException(
          message: message,
          statusCode: statusCode,
          originalError: dioException,
        );

      case 403:
        return AuthException(
          message: 'Access forbidden',
          statusCode: statusCode,
          originalError: dioException,
        );

      case 404:
        return NotFoundException(
          message: 'Resource not found',
          statusCode: statusCode,
          originalError: dioException,
        );

      case 422:
        return ValidationException(
          message: message,
          statusCode: statusCode,
          originalError: dioException,
          errors: _extractValidationErrors(dioException.response?.data),
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error occurred',
          statusCode: statusCode,
          originalError: dioException,
        );

      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ClientException(
            message: message,
            statusCode: statusCode,
            originalError: dioException,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: message,
            statusCode: statusCode,
            originalError: dioException,
          );
        } else {
          return NetworkException(
            message: message,
            statusCode: statusCode,
            originalError: dioException,
          );
        }
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? data['detail'];
    }
    return null;
  }

  Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> &&
        data['errors'] is Map<String, dynamic>) {
      final errorsMap = data['errors'] as Map<String, dynamic>;
      final validationErrors = <String, List<String>>{};

      errorsMap.forEach((key, value) {
        if (value is List) {
          validationErrors[key] = value.map((e) => e.toString()).toList();
        } else if (value is String) {
          validationErrors[key] = [value];
        }
      });

      return validationErrors.isNotEmpty ? validationErrors : null;
    }
    return null;
  }
}
