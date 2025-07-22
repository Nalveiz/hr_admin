import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../buttons/app_buttons.dart';

/// Uygulama genelinde kullanılacak ortak card widget'ı
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isSelected;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isSelected = false,
  });

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.isSelected = false,
  }) : elevation = 0,
       border = null;

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final isOutlined = elevation == 0 && border == null;

    final cardChild = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? themeColors.surfaceColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: themeColors.primaryColor, width: 2)
            : isOutlined
            ? Border.all(color: themeColors.borderColor, width: 1)
            : border,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation! / 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: cardChild,
        ),
      );
    }

    return Container(margin: margin, child: cardChild);
  }
}

/// Header ile birlikte card
class AppHeaderCard extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final IconData? icon;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const AppHeaderCard({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.icon,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: themeColors.primaryColor),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: themeTextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: themeColors.primaryColor,
                    ),
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          // Content
          Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

/// Stats Card Widget
class AppStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);
    final cardColor = color ?? themeColors.primaryColor;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: cardColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: themeTextStyles.caption.copyWith(
                    color: themeColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: themeTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: themeTextStyles.caption.copyWith(
                      color: themeColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Empty State Card
class AppEmptyCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyCard({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return AppCard(
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48, color: themeColors.textSecondary),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: themeTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.w600,
              color: themeColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: themeTextStyles.body2.copyWith(
              color: themeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 16),
            AppButton.primary(text: Text(actionText!), onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
