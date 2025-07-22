import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Ortak Form Field Widget'ları
/// Tüm projede kullanılacak standart form alanları için tutarlı tasarım

/// Form field'lar için ortak decoration mixin'i
mixin _FormFieldDecorationMixin {
  static const double _borderRadius = 12.0;
  static const double _borderWidth = 1.0;
  static const double _focusedBorderWidth = 2.0;
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );

  InputDecoration buildDecoration(
    BuildContext context, {
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final colors = AppThemeColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: isDark ? Colors.white38 : colors.borderColor,
          width: _borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: colors.primaryColor,
          width: _focusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: colors.errorColor, width: _borderWidth),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: colors.errorColor,
          width: _focusedBorderWidth,
        ),
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2A2A) : colors.surfaceColor,
      contentPadding: _contentPadding,
    );
  }
}

/// Standart Text Form Field Widget
class AppTextFormField extends StatelessWidget with _FormFieldDecorationMixin {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final int? maxLines;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool readOnly;

  const AppTextFormField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      decoration: buildDecoration(
        context,
        label: label,
        hint: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Password Field Widget
class AppPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;

  const AppPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.enabled = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField>
    with _FormFieldDecorationMixin {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      obscureText: !_isVisible,
      decoration: buildDecoration(
        context,
        label: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
    );
  }
}

/// Date Picker Field Widget
class AppDateField extends StatelessWidget with _FormFieldDecorationMixin {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onChanged;
  final FormFieldValidator<DateTime>? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hint;
  final IconData? prefixIcon;

  const AppDateField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.hint,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final textStyles = AppThemeTextStyles.of(context);

    return FormField<DateTime>(
      validator: validator,
      initialValue: selectedDate,
      builder: (field) {
        final displayText = field.value != null
            ? '${field.value!.day}.${field.value!.month}.${field.value!.year}'
            : hint ?? 'Tarih seçin';

        return InkWell(
          onTap: () => _selectDate(context, field), // ⬅️ Burada field parametresi eklendi
          child: InputDecorator(
            decoration: buildDecoration(
              context,
              label: label,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            ).copyWith(
              errorText: field.errorText,
            ),
            child: Text(
              displayText,
              style: field.value != null
                  ? textStyles.body1
                  : textStyles.body1.copyWith(color: colors.textSecondary),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, FormFieldState<DateTime> field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: field.value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (picked != null) {
      onChanged(picked);     // dışarıdan gelen state güncellemesi
      field.didChange(picked); // form field'a bildir
    }
  }
}


/// Dropdown Field Widget
class AppDropdownField<T> extends StatelessWidget
    with _FormFieldDecorationMixin {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final String? hint;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: buildDecoration(
        context,
        label: label,
        hint: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }
}
