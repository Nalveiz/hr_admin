import 'package:flutter/material.dart';

// Tema-aware renk sistemi
class AppThemeColors {
  final BuildContext context;

  const AppThemeColors._(this.context);
  static AppThemeColors of(BuildContext context) => AppThemeColors._(context);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // Primary Colors
  Color get primaryColor =>
      _isDark ? AppColors.primaryLight : AppColors.primaryColor;
  Color get primaryLight => AppColors.primaryLight;
  Color get primaryDark => AppColors.primaryDark;

  // Secondary Colors
  Color get secondaryColor =>
      _isDark ? AppColors.secondaryLight : AppColors.secondaryColor;
  Color get secondaryLight => AppColors.secondaryLight;
  Color get secondaryDark => AppColors.secondaryDark;

  // Background Colors
  Color get backgroundColor =>
      _isDark ? const Color(0xFF121212) : AppColors.backgroundColor;
  Color get surfaceColor =>
      _isDark ? const Color(0xFF1E1E1E) : AppColors.surfaceColor;
  Color get cardColor =>
      _isDark ? const Color(0xFF2E2E2E) : AppColors.cardColor;

  // Text Colors
  Color get textPrimary => _isDark ? Colors.white : AppColors.textPrimary;
  Color get textSecondary => _isDark ? Colors.white70 : AppColors.textSecondary;
  Color get textHint => _isDark ? Colors.white54 : AppColors.textHint;
  Color get textLight => AppColors.textLight;

  // Status Colors
  Color get successColor => AppColors.successColor;
  Color get errorColor => AppColors.errorColor;
  Color get warningColor => AppColors.warningColor;
  Color get infoColor => AppColors.infoColor;

  // Border Colors
  Color get borderColor => _isDark ? Colors.white24 : AppColors.borderColor;
  Color get dividerColor => _isDark ? Colors.white12 : AppColors.dividerColor;

  // HR Colors
  Color get attendanceGreen => AppColors.attendanceGreen;
  Color get attendanceRed => AppColors.attendanceRed;
  Color get attendanceOrange => AppColors.attendanceOrange;
  Color get leaveBlue => AppColors.leaveBlue;
  Color get salaryGreen => AppColors.salaryGreen;

  // Chart Colors
  List<Color> get chartColors => AppColors.chartColors;

  // Gradients
  LinearGradient get primaryGradient => AppColors.primaryGradient;
  LinearGradient get cardGradient => _isDark
      ? LinearGradient(
          colors: [surfaceColor, const Color(0xFF242424)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : AppColors.cardGradient;
}

// Tema-aware text stiller
class AppThemeTextStyles {
  final BuildContext context;

  const AppThemeTextStyles._(this.context);
  static AppThemeTextStyles of(BuildContext context) =>
      AppThemeTextStyles._(context);

  AppThemeColors get _colors => AppThemeColors.of(context);

  TextStyle get heading1 =>
      AppTextStyles.heading1.copyWith(color: _colors.textPrimary);
  TextStyle get heading2 =>
      AppTextStyles.heading2.copyWith(color: _colors.textPrimary);
  TextStyle get heading3 =>
      AppTextStyles.heading3.copyWith(color: _colors.textPrimary);
  TextStyle get subtitle1 =>
      AppTextStyles.subtitle1.copyWith(color: _colors.textPrimary);
  TextStyle get subtitle2 =>
      AppTextStyles.subtitle2.copyWith(color: _colors.textPrimary);
  TextStyle get body1 =>
      AppTextStyles.body1.copyWith(color: _colors.textPrimary);
  TextStyle get body2 =>
      AppTextStyles.body2.copyWith(color: _colors.textSecondary);
  TextStyle get caption =>
      AppTextStyles.caption.copyWith(color: _colors.textHint);
  TextStyle get button => AppTextStyles.button;
}

// Sabit renkler
class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF018786);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textLight = Color(0xFFFFFFFF);

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // HR Colors
  static const Color attendanceGreen = Color(0xFF4CAF50);
  static const Color attendanceRed = Color(0xFFF44336);
  static const Color attendanceOrange = Color(0xFFFF9800);
  static const Color leaveBlue = Color(0xFF2196F3);
  static const Color salaryGreen = Color(0xFF00C853);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFF44336),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
    Color(0xFF795548),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Sabit text stiller
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
}

// Tema tanımları
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        filled: true,
        fillColor: AppColors.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(
          AppColors.primaryColor.withValues(alpha: 0.1),
        ),
        dataRowColor: WidgetStateProperty.all(AppColors.surfaceColor),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
        labelStyle: const TextStyle(color: AppColors.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textLight,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF2E2E2E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF2E2E2E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
