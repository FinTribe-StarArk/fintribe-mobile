import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext].
extension ContextExtension on BuildContext {
  /// The current theme.
  ThemeData get theme => Theme.of(this);

  /// The current text theme.
  TextTheme get textTheme => theme.textTheme;

  /// The current color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Media query size.
  Size get mediaSize => MediaQuery.sizeOf(this);

  /// Whether the device is in landscape.
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Whether dark mode is active.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Open the device keyboard.
  void unfocus() => FocusScope.of(this).unfocus();

  /// Show a snackbar with [message].
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colorScheme.error : null,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }
}
