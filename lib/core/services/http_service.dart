import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hr_admin/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// HTTP Service için temel sınıf
/// Vizyoneks API'sine istekler yapmak için Dio kullanır
class HttpService {
  late final Dio _dio;
  final SharedPreferences _prefs;

  HttpService(this._prefs) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor ekle
    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       // JWT token varsa ekle
    //       final token = _prefs.getString('auth_token');
    //       if (token != null && token.isNotEmpty) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //       }
    //       handler.next(options);
    //     },
    //     onError: (error, handler) {
    //       // Hata loglaması
    //       handler.next(error);
    //     },
    //   ),
    // );
  }

  /// GET isteği
  Future<HttpResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return HttpResponse<T>.error(_handleError(e));
    }
  }

  /// POST isteği
  Future<HttpResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      print('Created Employee: ${response.data}');
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('Error creating employee: $e');
      return HttpResponse<T>.error(_handleError(e));
    }
  }

  /// PUT isteği
  Future<HttpResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return HttpResponse<T>.error(_handleError(e));
    }
  }

  /// DELETE isteği
  Future<HttpResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return HttpResponse<T>.error(_handleError(e));
    }
  }

  /// Response'u handle eder
  HttpResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final statusCode = response.statusCode ?? 0;

    // Success responses (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.data == null) {
        return HttpResponse<T>.success(null, statusCode);
      }

      try {
        if (fromJson != null) {
          final data = fromJson(response.data);
          return HttpResponse<T>.success(data, statusCode);
        } else {
          return HttpResponse<T>.success(response.data as T?, statusCode);
        }
      } catch (e) {
        return HttpResponse<T>.error(
          HttpError(
            message: 'JSON parse hatası: ${e.toString()}',
            statusCode: statusCode,
          ),
        );
      }
    }

    // Error responses
    return HttpResponse<T>.error(_parseErrorResponse(response));
  }

  /// Error response'unu parse eder
  HttpError _parseErrorResponse(Response response) {
    try {
      final jsonData = response.data;

      // API error format
      String message = 'Bilinmeyen hata';

      if (jsonData is Map<String, dynamic>) {
        // Vizyoneks API error format
        if (jsonData.containsKey('message')) {
          message = jsonData['message'] as String;
        } else if (jsonData.containsKey('error')) {
          message = jsonData['error'] as String;
        } else if (jsonData.containsKey('title')) {
          message = jsonData['title'] as String;
        }

        // Validation errors
        if (jsonData.containsKey('errors')) {
          final errors = jsonData['errors'];
          final errorMessages = <String>[];

          if (errors is Map<String, dynamic>) {
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.cast<String>());
              } else {
                errorMessages.add(value.toString());
              }
            });
          } else if (errors is List) {
            errorMessages.addAll(errors.cast<String>());
          }

          if (errorMessages.isNotEmpty) {
            message = errorMessages.join(', ');
          }
        }
      } else if (jsonData is String) {
        message = jsonData;
      }

      return HttpError(
        message: message,
        statusCode: response.statusCode ?? 0,
        details: jsonData,
      );
    } catch (e) {
      return HttpError(
        message: 'HTTP ${response.statusCode}: ${response.statusMessage}',
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Exception'ları handle eder
  HttpError _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return HttpError(
            message: 'Bağlantı zaman aşımı. Lütfen tekrar deneyin.',
            statusCode: 408,
          );
        case DioExceptionType.badResponse:
          return _parseErrorResponse(error.response!);
        case DioExceptionType.cancel:
          return HttpError(message: 'İstek iptal edildi.', statusCode: 0);
        case DioExceptionType.connectionError:
          return HttpError(
            message:
                'Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.',
            statusCode: 0,
          );
        default:
          return HttpError(
            message: 'Beklenmeyen hata: ${error.message}',
            statusCode: error.response?.statusCode ?? 0,
          );
      }
    } else if (error is SocketException) {
      return HttpError(
        message: 'Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.',
        statusCode: 0,
      );
    } else {
      return HttpError(
        message: 'Beklenmeyen hata: ${error.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Token'ı kaydet
  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  /// Token'ı temizle
  Future<void> clearToken() async {
    await _prefs.remove('auth_token');
  }

  /// Mevcut token'ı al
  String? getToken() {
    return _prefs.getString('auth_token');
  }

  /// Dio client'ını kapat
  void dispose() {
    _dio.close();
  }
}

/// HTTP Response wrapper
class HttpResponse<T> {
  final T? data;
  final HttpError? error;
  final int statusCode;
  final bool isSuccess;

  const HttpResponse._({
    this.data,
    this.error,
    required this.statusCode,
    required this.isSuccess,
  });

  factory HttpResponse.success(T? data, int statusCode) {
    return HttpResponse._(data: data, statusCode: statusCode, isSuccess: true);
  }

  factory HttpResponse.error(HttpError error) {
    return HttpResponse._(
      error: error,
      statusCode: error.statusCode,
      isSuccess: false,
    );
  }
}

/// HTTP Error model
class HttpError {
  final String message;
  final int statusCode;
  final dynamic details;

  const HttpError({
    required this.message,
    required this.statusCode,
    this.details,
  });

  @override
  String toString() {
    return 'HttpError: $message (Status: $statusCode)';
  }
}
