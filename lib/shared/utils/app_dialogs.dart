import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../presentation/widgets/buttons/app_buttons.dart';

/// Uygulama genelinde kullanılacak SnackBar yönetim sistemi
class AppSnackBar {
  AppSnackBar._();

  /// Success SnackBar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: AppThemeColors.of(context).successColor,
      icon: Icons.check_circle_outline,
      duration: duration,
      action: action,
    );
  }

  /// Error SnackBar
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: AppThemeColors.of(context).errorColor,
      icon: Icons.error_outline,
      duration: duration,
      action: action,
    );
  }

  /// Warning SnackBar
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: AppThemeColors.of(context).warningColor,
      icon: Icons.warning_outlined,
      duration: duration,
      action: action,
    );
  }

  /// Info SnackBar
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: AppThemeColors.of(context).infoColor,
      icon: Icons.info_outline,
      duration: duration,
      action: action,
    );
  }

  /// Custom SnackBar
  static void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
      action: action,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    // Önceki SnackBar'ı kapat
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: AppThemeTextStyles.of(
                context,
              ).body2.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      action: action,
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Dialog yönetim sistemi
class AppDialogs {
  AppDialogs._();

  /// Confirmation Dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Onayla',
    String cancelText = 'İptal',
    IconData? icon,
    Color? iconColor,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final themeColors = AppThemeColors.of(context);

        return AlertDialog(
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color:
                      iconColor ??
                      (isDanger
                          ? themeColors.errorColor
                          : themeColors.primaryColor),
                  size: 24,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(color: themeColors.textSecondary),
              ),
            ),
            isDanger
                ? AppButton.danger(
                    text: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                : AppButton.primary(
                    text: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
          ],
        );
      },
    );
  }

  /// Loading Dialog
  static void showLoading(
    BuildContext context, {
    String message = 'Yükleniyor...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  /// Hide Loading Dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Info Dialog
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Tamam',
    IconData? icon,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: AppThemeColors.of(context).infoColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            AppButton.primary(
              text: buttonText,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Error Dialog
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Tamam',
  }) {
    return showInfo(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.error_outline,
    );
  }

  /// Custom Dialog
  static Future<T?> showCustom<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => child,
    );
  }
}
