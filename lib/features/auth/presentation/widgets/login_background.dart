import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/shared.dart';

/// Simple login page background with responsive design
class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= AppBreakpoints.desktop;
    final isTablet = screenWidth >= AppBreakpoints.tablet;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: themeColors.primaryGradient),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.md),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop
                    ? 450
                    : isTablet
                    ? 400
                    : double.infinity,
              ),
              child: Card(
                elevation: isDesktop ? 12 : 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    isDesktop
                        ? AppSpacing.xxl
                        : isTablet
                        ? AppSpacing.xl
                        : AppSpacing.lg,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
