import 'package:flutter/material.dart';

class AppHeroLogo extends StatelessWidget {
  final String? imagePath;
  final String heroTag;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Widget? fallback;

  const AppHeroLogo({
    super.key,
    this.imagePath,
    this.heroTag = 'app_logo',
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.fallback,
  });

  /// Named constructor for app logo
  const AppHeroLogo.appLogo({
    super.key,
    this.heroTag = 'app_logo',
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.fallback,
  }) : imagePath = 'assets/logo/logo.png';

  /// Named constructor for app mini logo
  const AppHeroLogo.miniLogo({
    super.key,
    this.heroTag = 'app_mini_logo',
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.fallback,
  }) : imagePath = 'assets/logo/logo-mini.png';

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath != null) {
      imageWidget = Image.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) {
          return fallback ?? const SizedBox.shrink();
        },
      );
    } else {
      imageWidget = fallback ?? const SizedBox.shrink();
    }

    return Hero(tag: heroTag, child: imageWidget);
  }
}
