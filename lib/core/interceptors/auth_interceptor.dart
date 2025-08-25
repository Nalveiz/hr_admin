import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_exceptions.dart';

/// HTTP interceptor for handling authentication tokens
class AuthInterceptor extends Interceptor {
  final SharedPreferences prefs;
  final Dio dio;

  AuthInterceptor({required this.prefs, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add access token to all requests except login and refresh
    if (!_isAuthEndpoint(options.path)) {
      final accessToken = prefs.getString('access_token');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    // Add common headers
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(err.requestOptions.path)) {
      try {
        await _refreshToken();

        // Retry the original request with new token
        final accessToken = prefs.getString('access_token');
        if (accessToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (e) {
        // If refresh fails, clear tokens and let the error pass through
        await _clearTokens();
      }
    }

    super.onError(err, handler);
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/Auth/refresh-token') || // Updated endpoint
        path.contains('/Auth/logout'); // Updated endpoint
  }

  Future<void> _refreshToken() async {
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      throw const AuthException(message: 'No refresh token available');
    }

    try {
      final response = await dio.post(
        '/Auth/refresh-token', // Updated endpoint
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        await prefs.setString('access_token', data['access_token']);

        if (data['refresh_token'] != null) {
          await prefs.setString('refresh_token', data['refresh_token']);
        }
      } else {
        throw const AuthException(message: 'Token refresh failed');
      }
    } on DioException catch (e) {
      throw AuthException(
        message: 'Token refresh failed: ${e.message}',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    }
  }

  Future<void> _clearTokens() async {
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}
