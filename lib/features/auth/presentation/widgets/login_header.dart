import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/shared.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppHeroLogo(
          imagePath: AppConstants.logoSquarePath,
          heroTag: 'login_logo',
          width: 100,
          height: 100,
          fallback: _buildFallbackLogo(context),
        ),

        const SizedBox(height: AppSpacing.lg),

        // App title
        Text(
          AppConstants.appName,
          style: themeTextStyles.heading2.copyWith(
            color: themeColors.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.sm),

        // Subtitle
        Text(
          'İnsan Kaynakları Yönetim Sistemi',
          style: themeTextStyles.body2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFallbackLogo(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeColors.primaryColor,
            themeColors.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.business_rounded, color: Colors.white, size: 50),
    );
  }
}
