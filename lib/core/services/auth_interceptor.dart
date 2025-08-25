import 'package:dio/dio.dart';
import 'package:hr_admin/core/constants/app_constants.dart';
import 'package:hr_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hr_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:hr_admin/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SharedPreferences prefs;
  bool _isRefreshing = false;

  AuthInterceptor({
    required this.dio,
    required this.prefs,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString(AppConstants.authTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final refreshToken = prefs.getString(AppConstants.refreshTokenKey);

    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) &&
        refreshToken != null &&
        !_isRefreshing) {
      _isRefreshing = true;
      try {
        final res = await dio.post(
          '${AppConstants.baseUrl}/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = res.data['accessToken'];
        final newRefreshToken = res.data['refreshToken'];

        await prefs.setString(AppConstants.authTokenKey, newAccessToken);
        await prefs.setString(AppConstants.refreshTokenKey, newRefreshToken);

        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final cloneResponse = await dio.fetch(requestOptions);
        handler.resolve(cloneResponse);
        return;
      } catch (_) {
        // Sadece tokenları temizle, yönlendirme UI'da yapılacak
        await prefs.clear();
        di.sl<AuthBloc>().add(const AuthLogoutRequested());


      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }
}
