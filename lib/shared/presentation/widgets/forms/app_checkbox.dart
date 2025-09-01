import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable checkbox widget with consistent styling
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Color? activeColor;
  final Color? checkColor;
  final bool enabled;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeColor,
    this.checkColor,
    this.enabled = true,
    this.materialTapTargetSize,
    this.visualDensity,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    if (label == null) {
      return Checkbox(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: activeColor ?? themeColors.primaryColor,
        checkColor: checkColor ?? Colors.white,
        materialTapTargetSize:
            materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
        visualDensity: visualDensity ?? VisualDensity.compact,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: activeColor ?? themeColors.primaryColor,
          checkColor: checkColor ?? Colors.white,
          materialTapTargetSize:
              materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
          visualDensity: visualDensity ?? VisualDensity.compact,
        ),

        const SizedBox(width: AppSpacing.sm),

        GestureDetector(
          onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
          child: Text(
            label!,
            style: themeTextStyles.body2.copyWith(
              color: enabled ? themeColors.textPrimary : themeColors.textHint,
            ),
          ),
        ),
      ],
    );
  }
}
