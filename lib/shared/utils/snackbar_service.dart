import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_spacing.dart';

abstract class SnackBarService {
  void showSuccess(BuildContext context, String message);
  void showError(BuildContext context, String message);
  void showWarning(BuildContext context, String message);
  void showInfo(BuildContext context, String message);
  void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    SnackBarAction? action,
    Duration? duration,
  });
}

class SnackBarServiceImpl implements SnackBarService {
  const SnackBarServiceImpl();

  @override
  void showSuccess(BuildContext context, String message) =>
      _show(context, message, Colors.green, Icons.check_circle);

  @override
  void showError(BuildContext context, String message) => _show(
    context,
    message,
    Colors.red,
    Icons.error,
    duration: const Duration(seconds: 4),
  );

  @override
  void showWarning(BuildContext context, String message) =>
      _show(context, message, Colors.orange, Icons.warning);

  @override
  void showInfo(BuildContext context, String message) {
    final themeColors = AppThemeColors.of(context);
    _show(context, message, themeColors.primaryColor, Icons.info);
  }

  @override
  void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    SnackBarAction? action,
    Duration? duration,
  }) {
    _show(
      context,
      message,
      backgroundColor,
      icon,
      action: action,
      duration: duration,
    );
  }

  void _show(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData? icon, {
    SnackBarAction? action,
    Duration? duration,
  }) {
    final themeTextStyles = AppThemeTextStyles.of(context);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 20),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: Text(
                message,
                style: themeTextStyles.body2.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(AppSpacing.md),
        action: action,
      ),
    );
  }
}
