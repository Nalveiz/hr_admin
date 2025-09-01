import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';
import '../services/error_handling_service.dart';

/// Base HTTP service class providing common functionality
abstract class BaseHttpService {
  late final Dio _dio;
  final SharedPreferences _prefs;
  final ErrorHandlingService _errorHandlingService;

  BaseHttpService(this._prefs, this._errorHandlingService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(prefs: _prefs, dio: _dio),
      ErrorInterceptor(),
      LoggingInterceptor(
        logRequests: true,
        logResponses: true,
        logErrors: true,
      ),
    ]);
  }

  /// Access to SharedPreferences for subclasses
  SharedPreferences get prefs => _prefs;

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      T? data;

      if (fromJson != null && response.data != null) {
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          data = fromJson(response.data['data']);
        } else {
          data = fromJson(response.data);
        }
      } else {
        data = response.data;
      }

      if (data != null) {
        return ApiResponse.success(
          data,
          message: response.data is Map<String, dynamic>
              ? response.data['message']
              : null,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'No data received',
          statusCode: response.statusCode,
        );
      }
    } else {
      return ApiResponse.error(
        'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle error response
  ApiResponse<T> _handleError<T>(DioException error) {
    // ErrorHandlingService kullanarak kullanıcı dostu mesaj oluştur
    String userFriendlyMessage = _errorHandlingService.getNetworkErrorMessage(
      error,
    );

    return ApiResponse.error(
      userFriendlyMessage,
      statusCode: error.response?.statusCode,
    );
  }

  /// Get Dio instance (for advanced usage)
  Dio get dio => _dio;
}
