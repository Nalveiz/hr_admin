import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';

/// Base HTTP service class providing common functionality
abstract class BaseHttpService {
  late final Dio _dio;
  final SharedPreferences _prefs;

  BaseHttpService(this._prefs) {
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
    String message = 'An error occurred';

    if (error.response?.data is Map<String, dynamic>) {
      final data = error.response!.data as Map<String, dynamic>;
      message = data['message'] ?? data['error'] ?? message;
    } else if (error.message != null) {
      message = error.message!;
    }

    return ApiResponse.error(message, statusCode: error.response?.statusCode);
  }

  /// Get Dio instance (for advanced usage)
  Dio get dio => _dio;
}
