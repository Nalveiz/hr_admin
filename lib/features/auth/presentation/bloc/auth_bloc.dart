import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;

  AuthBloc(this._prefs) : super(const AuthInitial()) {
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

      if (token != null && userDataString != null) {
        // In a real app, you would validate the token with the server
        final userData = <String, dynamic>{
          'id': '1',
          'username': 'admin',
          'email': 'admin@company.com',
          'firstName': 'Admin',
          'lastName': 'User',
          'role': 'admin',
        };

        emit(AuthAuthenticated(token: token, user: userData));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock login validation - admin/admin
      if (event.username == 'admin' && event.password == 'admin') {
        const token = 'mock_jwt_token_12345';
        final userData = <String, dynamic>{
          'id': '1',
          'username': event.username,
          'email': 'admin@company.com',
          'firstName': 'Admin',
          'lastName': 'User',
          'role': 'admin',
        };

        // Save to storage
        await _prefs.setString(AppConstants.authTokenKey, token);
        await _prefs.setString(AppConstants.userDataKey, userData.toString());

        emit(AuthAuthenticated(token: token, user: userData));
      } else {
        emit(const AuthError(message: 'Geçersiz kullanıcı adı veya şifre'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _prefs.remove(AppConstants.authTokenKey);
      await _prefs.remove(AppConstants.userDataKey);

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
