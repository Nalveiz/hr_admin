import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/features/auth/data/models/user_model.dart';
import 'package:hr_admin/features/auth/data/services/auth_service_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/error_handling_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;
  final AuthService _authService;
  final ErrorHandlingService _errorHandlingService;

  AuthBloc(this._prefs, this._authService, this._errorHandlingService)
    : super(const AuthInitial()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = _prefs.getString(AppConstants.authTokenKey);
      final userDataString = _prefs.getString(AppConstants.userDataKey);
      final refreshToken = _prefs.getString(AppConstants.refreshTokenKey);

      print('Token: $token');
      print('User Data: $userDataString');
      print('Refresh Token: $refreshToken');

      if (token != null && userDataString != null && refreshToken != null) {
        final Map<String, dynamic> userMap = jsonDecode(userDataString);
        final user = UserModel.fromJson(userMap);

        emit(
          AuthAuthenticated(
            token: token,
            user: user,
            refreshToken: refreshToken,
          ),
        );
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      print('Error in _onCheckStatus: $e');
      // Check status hataları için basit mesaj
      emit(
        const AuthError(
          message:
              'Oturum durumu kontrol edilemedi. Lütfen tekrar giriş yapın.',
        ),
      );
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.login(
        username: event.username,
        password: event.password,
      );
      if (!response.isSuccess || response.data == null) {
        // response.error zaten ErrorHandlingService'ten gelen kullanıcı dostu mesaj
        final errorMessage =
            response.error ?? 'Giriş başarısız oldu. Tekrar deneyin.';
        emit(AuthError(message: errorMessage));
        return;
      }
      final tokens = response.data!.tokens;
      final user = response.data!.user;
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.userDataKey, userJson);

      await _prefs.setString(AppConstants.refreshTokenKey, tokens.refreshToken);
      await _prefs.setString(AppConstants.authTokenKey, tokens.accessToken);

      emit(
        AuthAuthenticated(
          token: tokens.accessToken,
          user: user,
          refreshToken: tokens.refreshToken,
        ),
      );
    } catch (e) {
      // Network hatalarını kullanıcı dostu mesajlara çevir
      String userFriendlyMessage = _errorHandlingService
          .getHumanReadableErrorMessage(e);
      emit(AuthError(message: userFriendlyMessage));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.logout();
      await _prefs.remove(AppConstants.authTokenKey);
      await _prefs.remove(AppConstants.userDataKey);

      emit(const AuthUnauthenticated());
    } catch (e) {
      // Logout hataları için de kullanıcı dostu mesaj
      String userFriendlyMessage = _errorHandlingService
          .getHumanReadableErrorMessage(e);
      emit(AuthError(message: userFriendlyMessage));
    }
  }
}
