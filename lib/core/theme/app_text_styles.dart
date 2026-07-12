import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintribe/core/theme/app_colors.dart';

/// Centralized typography definitions.
abstract final class AppTextStyles {
  AppTextStyles._();

  /// Base text style used as the foundation for all styles.
  static TextStyle get _base => GoogleFonts.inter();

  // ── Display ────────────────────────────────────────────────────
  static TextStyle displayLarge(BuildContext context) => _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.lightTextPrimary,
    height: 1.2,
  );

  // ── Headline ───────────────────────────────────────────────────
  static TextStyle headlineLarge(BuildContext context) => _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.lightTextPrimary,
    height: 1.3,
  );

  static TextStyle headlineMedium(BuildContext context) => _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
    height: 1.3,
  );

  static TextStyle headlineSmall(BuildContext context) => _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
    height: 1.4,
  );

  // ── Title ──────────────────────────────────────────────────────
  static TextStyle titleLarge(BuildContext context) => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
    height: 1.4,
  );

  static TextStyle titleMedium(BuildContext context) => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextPrimary,
    height: 1.4,
  );

  // ── Body ───────────────────────────────────────────────────────
  static TextStyle bodyLarge(BuildContext context) => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextHint,
    height: 1.5,
  );

  // ── Label ──────────────────────────────────────────────────────
  static TextStyle labelLarge(BuildContext context) => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium(BuildContext context) => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextSecondary,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall(BuildContext context) => _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextHint,
    letterSpacing: 0.5,
  );

  // ── Button ─────────────────────────────────────────────────────
  static TextStyle buttonLarge(BuildContext context) => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle buttonMedium(BuildContext context) => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // ── Caption ────────────────────────────────────────────────────
  static TextStyle caption(BuildContext context) => _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextHint,
  );
}
