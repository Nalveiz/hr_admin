import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../injection_container.dart';
import '../../../../shared/shared.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Login form widget - handles user input and validation
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username Field
          AppTextFormField(
            label: AppStrings.username,
            controller: _usernameController,
            prefixIcon: Icons.person_outline,
            validator: AppValidators.required,
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: AppSpacing.md),

          // Password Field
          AppPasswordField(
            label: AppStrings.password,
            controller: _passwordController,
            validator: AppValidators.required,
          ),

          const SizedBox(height: AppSpacing.md),

          // Remember Me and Forgot Password Row
          _buildOptionsRow(context),

          const SizedBox(height: AppSpacing.lg),

          // Login Button
          _buildLoginButton(context),
        ],
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      children: [
        AppCheckbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          label: AppStrings.rememberMe,
        ),

        const Spacer(),

        TextButton(
          onPressed: _handleForgotPassword,
          child: Text(
            AppStrings.forgotPassword,
            style: AppThemeTextStyles.of(
              context,
            ).body2.copyWith(color: AppThemeColors.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppButton.primary(
          text: Text(AppStrings.login),
          onPressed: isLoading ? null : _handleLogin,
          isLoading: isLoading,
          width: double.infinity,
          icon: Icons.login,
          size: ButtonSize.large,
        );
      },
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      context.read<AuthBloc>().add(
        AuthLoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password functionality
    sl<SnackBarService>().showInfo(
      context,
      'Şifre sıfırlama özelliği yakında eklenecek.',
    );
  }
}
