import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Primary Button Widget
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonType type;
  final ButtonSize size;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.width,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.width,
  }) : type = ButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.width,
  }) : type = ButtonType.secondary;

  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.width,
  }) : type = ButtonType.danger;

  const AppButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.width,
  }) : type = ButtonType.ghost;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: colors.border != null
                ? BorderSide(color: colors.border!, width: 1)
                : BorderSide.none,
          ),
          elevation: type == ButtonType.ghost ? 0 : 2,
        ),
        child: isLoading
            ? SizedBox(
                height: textStyle.fontSize! + 4,
                width: textStyle.fontSize! + 4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: textStyle.fontSize! + 2),
                    const SizedBox(width: 8),
                  ],
                  Text(text, style: textStyle),
                ],
              ),
      ),
    );
  }

  _ButtonColors _getColors() {
    switch (type) {
      case ButtonType.primary:
        return _ButtonColors(
          background: AppColors.primaryColor,
          foreground: Colors.white,
        );
      case ButtonType.secondary:
        return _ButtonColors(
          background: AppColors.surfaceColor,
          foreground: AppColors.primaryColor,
          border: AppColors.primaryColor,
        );
      case ButtonType.danger:
        return _ButtonColors(
          background: AppColors.errorColor,
          foreground: Colors.white,
        );
      case ButtonType.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.primaryColor,
          border: AppColors.primaryColor,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600);
      case ButtonSize.medium:
        return AppTextStyles.button;
      case ButtonSize.large:
        return AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w600);
    }
  }
}

/// Icon Button Widget
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ButtonType type;
  final String? tooltip;
  final double? size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.type = ButtonType.primary,
    this.tooltip,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Tooltip(
      message: tooltip ?? '',
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: size),
        color: colors.foreground,
        style: IconButton.styleFrom(
          backgroundColor: colors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: colors.border != null
                ? BorderSide(color: colors.border!, width: 1)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  _ButtonColors _getColors() {
    switch (type) {
      case ButtonType.primary:
        return _ButtonColors(
          background: AppColors.primaryColor,
          foreground: Colors.white,
        );
      case ButtonType.secondary:
        return _ButtonColors(
          background: AppColors.surfaceColor,
          foreground: AppColors.primaryColor,
          border: AppColors.primaryColor,
        );
      case ButtonType.danger:
        return _ButtonColors(
          background: AppColors.errorColor,
          foreground: Colors.white,
        );
      case ButtonType.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.textPrimary,
          border: AppColors.borderColor,
        );
    }
  }
}

/// Floating Action Button Widget
class AppFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isExtended;
  final String? label;

  const AppFab({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isExtended = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        tooltip: tooltip,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      child: Icon(icon),
    );
  }
}

enum ButtonType { primary, secondary, danger, ghost }

enum ButtonSize { small, medium, large }

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}
