import 'package:flutter/material.dart';

/// Extension for BuildContext with additional utilities
extension ContextExtension on BuildContext {
  /// Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// MediaQuery shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Navigation shortcuts
  NavigatorState get navigator => Navigator.of(this);

  /// Responsive breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Responsive values
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Safe area
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Keyboard visibility
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Brightness
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  /// Colors
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;

  /// Text styles
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  /// Spacing
  double get smallSpacing => 8.0;
  double get mediumSpacing => 16.0;
  double get largeSpacing => 24.0;
  double get extraLargeSpacing => 32.0;

  /// Border radius
  double get smallRadius => 4.0;
  double get mediumRadius => 8.0;
  double get largeRadius => 12.0;
  double get extraLargeRadius => 16.0;

  /// Show snackbar
  void showSnackBar(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: errorColor,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  /// Focus utilities
  void unfocus() => FocusScope.of(this).unfocus();
  void requestFocus(FocusNode focusNode) =>
      FocusScope.of(this).requestFocus(focusNode);

  /// Navigation helpers
  void pop<T>([T? result]) => navigator.pop(result);
  Future<T?> push<T>(Route<T> route) => navigator.push(route);
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed(routeName, arguments: arguments);
  Future<T?> pushReplacement<T, TO>(Route<T> newRoute, {TO? result}) =>
      navigator.pushReplacement(newRoute, result: result);
  Future<T?> pushNamedAndClearStack<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );
}
