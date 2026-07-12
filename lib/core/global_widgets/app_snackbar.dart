import 'package:flutter/material.dart';

/// Helper utilities for showing snackbars.
abstract final class AppSnackbar {
  AppSnackbar._();

  /// Shows a success snackbar.
  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade700,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Shows an error snackbar.
  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.red.shade700,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  /// Shows an info snackbar.
  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.blue.shade700,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Widget? icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[icon, const SizedBox(width: 12)],
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
