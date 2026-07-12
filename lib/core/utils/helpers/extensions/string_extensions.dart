/// Convenience extensions on [String].
extension StringExtension on String {
  /// Capitalize the first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize the first letter of each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((w) => w.capitalize).join(' ');
  }

  /// Whether this string is a valid email address.
  bool get isValidEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(this);

  /// Whether this string is a valid password (min 8 chars, 1 upper, 1 digit).
  bool get isValidPassword =>
      RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(this);

  /// Mask all but the last [visibleChars] characters.
  String mask({int visibleChars = 4}) {
    if (length <= visibleChars) return this;
    return '${'*' * (length - visibleChars)}${substring(length - visibleChars)}';
  }

  /// Returns `true` if this string is null or whitespace.
  bool get isBlank => trim().isEmpty;

  /// Returns `true` if this string is not null and not whitespace.
  bool get isNotBlank => !isBlank;
}
