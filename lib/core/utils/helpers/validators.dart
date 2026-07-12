import 'extensions/string_extensions.dart';

/// Form validation utilities.
abstract final class Validators {
  Validators._();

  /// Validates an email address. Returns `null` if valid.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a password. Returns `null` if valid.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    return null;
  }

  /// Validates that two values match (e.g., password confirmation).
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates that a field is not empty.
  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }
}
