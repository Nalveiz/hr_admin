import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_admin/injection_container.dart';
import '../../../../shared/shared.dart';
import '../../../../core/routing/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            sl<SnackBarService>().showSuccess(context, 'Başarıyla giriş yaptınız!');
            context.go(AppRoutes.dashboard);
          } else if (state is AuthError) {
            sl<SnackBarService>().showError(context, state.message);
          }
        },
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(32),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppConstants.logoSquarePath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to app icon if logo fails to load
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Colors.white,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppConstants.appName,
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'İnsan Kaynakları Yönetim Sistemi',
                        style: AppTextStyles.body2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Username Field
                      AppTextFormField(
                        label: AppStrings.username,
                        controller: _usernameController,
                        prefixIcon: Icons.person_outline,
                        validator: AppValidators.required,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      AppPasswordField(
                        label: AppStrings.password,
                        controller: _passwordController,
                        validator: AppValidators.required,
                      ),
                      const SizedBox(height: 16),

                      // Remember Me and Forgot Password
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(AppStrings.rememberMe),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(AppStrings.forgotPassword),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return AppButton.primary(
                            text: Text(AppStrings.login),
                            onPressed: isLoading ? null : _handleLogin,
                            isLoading: isLoading,
                            width: double.infinity,
                            icon: Icons.login,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Demo Credentials
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.infoColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Demo Bilgileri:',
                              style: AppTextStyles.subtitle2.copyWith(
                                color: AppColors.infoColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kullanıcı Adı: admin\nŞifre: admin',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.infoColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }
}
