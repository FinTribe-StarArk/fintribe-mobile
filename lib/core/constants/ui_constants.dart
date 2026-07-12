/// UI-related constants: spacing, sizing, durations, etc.
abstract final class UiConstants {
  UiConstants._();

  // ── Spacing ────────────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // ── Border Radius ──────────────────────────────────────────────
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 999;

  // ── Icon Sizes ─────────────────────────────────────────────────
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // ── Animation Durations ────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ── Misc ───────────────────────────────────────────────────────
  static const double buttonHeight = 48;
  static const double inputHeight = 52;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
  static const double maxContentWidth = 480;
}
