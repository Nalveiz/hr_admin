import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../injection_container.dart';
import '../../../../shared/shared.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: LoginBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const SizedBox(height: AppSpacing.xl),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    switch (state) {
      case AuthAuthenticated():
        _handleSuccessfulLogin(context);
        break;
      case AuthError():
        _handleLoginError(context, state);
        break;
      case AuthLoading():
        break;
      default:
        break;
    }
  }

  void _handleSuccessfulLogin(BuildContext context) {
    sl<SnackBarService>().showSuccess(context, '🎉 Başarıyla giriş yaptınız!');

    context.go(AppRoutes.dashboard);
  }

  void _handleLoginError(BuildContext context, AuthError state) {
    sl<SnackBarService>().showError(context, '❌ ${state.message}');
    debugPrint('Login error: ${state.message}');
  }
}
