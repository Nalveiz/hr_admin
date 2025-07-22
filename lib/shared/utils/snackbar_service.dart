import 'package:flutter/material.dart';

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
  });
}
class SnackBarServiceImpl implements SnackBarService {
  const SnackBarServiceImpl();

  @override
  void showSuccess(BuildContext context, String message) =>
      _show(context, message, Colors.green, Icons.check_circle_outline);

  @override
  void showError(BuildContext context, String message) =>
      _show(context, message, Colors.red, Icons.error_outline);

  @override
  void showWarning(BuildContext context, String message) =>
      _show(context, message, Colors.orange, Icons.warning_outlined);

  @override
  void showInfo(BuildContext context, String message) =>
      _show(context, message, Colors.blue, Icons.info_outline);

  @override
  void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    SnackBarAction? action,
  }) {
    _show(context, message, backgroundColor, icon, action: action);
  }

  void _show(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData? icon, {
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        action: action,
      ),
    );
  }
}
