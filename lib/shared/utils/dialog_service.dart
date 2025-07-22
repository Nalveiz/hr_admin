import 'package:flutter/material.dart';
import 'package:hr_admin/core/theme/app_theme.dart';
import 'package:hr_admin/shared/presentation/widgets/buttons/app_buttons.dart';

abstract class DialogService {
  Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText,
    String cancelText,
    IconData? icon,
    Color? iconColor,
    bool isDanger,
  });

  Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText,
    IconData? icon,
  });

  Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText,
  });

  void showLoading(BuildContext context, {String message});

  void hideDialog(BuildContext context);

  Future<T?> showCustom<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible,
  });
}

class DialogServiceImpl implements DialogService {
  @override
  Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Onayla',
    String cancelText = 'İptal',
    IconData? icon,
    Color? iconColor,
    bool isDanger = false,
  }) async {
    final themeColors = AppThemeColors.of(context);

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                    text: Text(confirmText),
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                : AppButton.primary(
                    text: Text(confirmText),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
          ],
        );
      },
    );
  }

  @override
  Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Tamam',
    IconData? icon,
  }) {
    final infoColor = AppThemeColors.of(context).infoColor;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: infoColor, size: 24),
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
              text: Text(buttonText),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<void> showError(
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

  @override
  void showLoading(BuildContext context, {String message = 'Yükleniyor...'}) {
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

  @override
  void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Future<T?> showCustom<T>(
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
