import 'package:flutter/material.dart';

/// Centralized color palette for the application.
///
/// All colors are defined as static const for compile-time optimization.
abstract final class AppColors {
  AppColors._();

  // ── Primary ────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800

  // ── Secondary ──────────────────────────────────────────────────
  static const Color secondary = Color(0xFF06B6D4); // Cyan 500
  static const Color secondaryLight = Color(0xFF22D3EE); // Cyan 400
  static const Color secondaryDark = Color(0xFF0891B2); // Cyan 600

  // ── Neutral ────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);
  static const Color black = Color(0xFF000000);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFFD1FAE5); // Emerald 100
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue 100

  // ── Light Theme Specific ───────────────────────────────────────
  static const Color lightBackground = white;
  static const Color lightSurface = grey50;
  static const Color lightCard = white;
  static const Color lightDivider = grey200;
  static const Color lightTextPrimary = grey900;
  static const Color lightTextSecondary = grey600;
  static const Color lightTextHint = grey400;

  // ── Dark Theme Specific ────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF1E293B); // Slate 800
  static const Color darkDivider = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = grey100;
  static const Color darkTextSecondary = grey400;
  static const Color darkTextHint = grey500;
}
