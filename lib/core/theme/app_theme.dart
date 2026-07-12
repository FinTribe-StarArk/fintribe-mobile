import 'package:fintribe/core/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:fintribe/core/theme/app_colors.dart';

/// Light and dark [ThemeData] for the application.
///
/// Provides a [light] theme and a [dark] theme built from
/// Material 3 [ColorScheme] definitions.
abstract final class AppTheme {
  AppTheme._();

  // ── Color Schemes ──────────────────────────────────────────────

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.secondaryLight,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.errorLight,
    outline: AppColors.grey300,
    outlineVariant: AppColors.grey200,
    shadow: AppColors.black,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primary,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.black,
    secondaryContainer: AppColors.secondaryDark,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.error,
    outline: AppColors.darkDivider,
    outlineVariant: AppColors.grey700,
    shadow: AppColors.black,
  );

  // ── Themes ─────────────────────────────────────────────────────

  /// Light theme.
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    dividerColor: AppColors.lightDivider,
    cardColor: AppColors.lightCard,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(UiConstants.buttonHeight),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(UiConstants.buttonHeight),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UiConstants.spacingMd,
        vertical: UiConstants.spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(
        color: AppColors.lightTextSecondary,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(color: AppColors.lightTextHint, fontSize: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey100,
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
      labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusFull),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey400,
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusLg),
      ),
    ),
  );

  /// Dark theme.
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    dividerColor: AppColors.darkDivider,
    cardColor: AppColors.darkCard,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(UiConstants.buttonHeight),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(UiConstants.buttonHeight),
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UiConstants.spacingMd,
        vertical: UiConstants.spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(
        color: AppColors.darkTextSecondary,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextHint, fontSize: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.primary.withValues(alpha: 0.3),
      side: const BorderSide(color: AppColors.darkDivider),
      labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusFull),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.grey500,
      elevation: 8,
      backgroundColor: AppColors.darkSurface,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusMd),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.radiusLg),
      ),
    ),
  );
}
