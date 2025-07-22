import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/features/auth/data/services/auth_service.dart';
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
      final response = await _authService.login(
        email: event.username,
        password: event.password,
        rememberMe: event.rememberMe,
      );
      if (!response.isSuccess || response.data == null) {
        emit(AuthError(message: response.error?.message ?? 'Login failed'));
        return;
      } else {
        final token = response.data!.token;
        final userData = response.data!.user;

        await _prefs.setString(AppConstants.authTokenKey, token);
        await _prefs.setString(
          AppConstants.userDataKey,
          userData.toJson().toString(),
        );

        emit(AuthAuthenticated(token: token, user: userData.toJson()));
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
