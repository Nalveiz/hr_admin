import 'package:flutter/material.dart';

/// Responsive design için kullanılan yardımcı sınıf
class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  // Breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Screen dimensions
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // Device type checks
  bool get isMobile => screenWidth < mobileBreakpoint;
  bool get isTablet =>
      screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;
  bool get isDesktop => screenWidth >= tabletBreakpoint;

  // Responsive spacing
  double spacing(double baseValue) {
    if (isMobile) return baseValue * 0.8;
    if (isTablet) return baseValue;
    return baseValue * 1.2;
  }

  // Responsive padding
  EdgeInsets paddingAll(double value) => EdgeInsets.all(spacing(value));
  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(
        horizontal: spacing(horizontal),
        vertical: spacing(vertical),
      );

  // Responsive font sizes
  double fontSize(double baseSize) {
    if (isMobile) return baseSize * 0.9;
    if (isTablet) return baseSize;
    return baseSize * 1.1;
  }

  // Grid columns
  int get gridColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }

  // Form field sizing
  double get formFieldSpacing => spacing(16);
  EdgeInsets get formPadding => paddingAll(isMobile ? 16 : 24);
}
