import 'package:equatable/equatable.dart';
import 'package:hr_admin/features/auth/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String token;
  final UserModel user;
  final String refreshToken;

  const AuthAuthenticated({required this.token, required this.user, required this.refreshToken});

  @override
  List<Object?> get props => [token, user, refreshToken];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
