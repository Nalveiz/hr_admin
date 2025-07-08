import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;

  const AuthLoginRequested({
    required this.username,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [username, password, rememberMe];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
