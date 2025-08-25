import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/features/auth/data/models/user_model.dart';
import 'package:hr_admin/features/auth/data/services/auth_service_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;
  final AuthService _authService;

  AuthBloc(this._prefs, this._authService) : super(const AuthInitial()) {
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
      emit(AuthError(message: e.toString()));
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
        emit(AuthError(message: response.error ?? 'Login failed'));
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
      emit(AuthError(message: e.toString()));
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
      emit(AuthError(message: e.toString()));
    }
  }
}
