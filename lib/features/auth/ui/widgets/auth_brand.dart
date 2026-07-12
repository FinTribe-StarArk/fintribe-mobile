import 'package:fintribe/core/constants/ui_constants.dart';
import 'package:fintribe/core/theme/app_colors.dart';
import 'package:fintribe/core/utils/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// The FinTribe logo mark: a rounded primary-colored square with a leaf glyph.
final class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(Icons.eco, color: Colors.white, size: size * 0.55),
    );
  }
}

/// Shared footer shown beneath the auth cards (brand + legal links).
final class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key, this.showBrand = true});

  /// Whether to show the "FinTribe" wordmark above the links.
  final bool showBrand;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.grey500;
    return Column(
      children: [
        if (showBrand) ...[
          Text(
            'FinTribe',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UiConstants.spacingMd),
        ],
        const Wrap(
          alignment: WrapAlignment.center,
          spacing: UiConstants.spacingMd,
          children: [
            _FooterLink('Privacy Policy'),
            _FooterLink('Terms of Service'),
            _FooterLink('Help Center'),
          ],
        ),
        const SizedBox(height: UiConstants.spacingSm),
        Text(
          '© 2024 FinTribe Financial. All rights reserved.',
          style: context.textTheme.bodySmall?.copyWith(color: muted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.bodySmall?.copyWith(
        color: AppColors.grey700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// White (or dark) rounded card wrapper used across the auth screens.
final class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConstants.spacingLg),
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(UiConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A 4-segment password strength meter (0 = empty, 4 = strong).
final class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.strength});

  /// Strength score in the range 0–4.
  final int strength;

  static const _colors = [
    AppColors.error,
    AppColors.warning,
    AppColors.info,
    AppColors.success,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final filled = i < strength;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < 3 ? UiConstants.spacingSm : 0),
            decoration: BoxDecoration(
              color: filled
                  ? _colors[(strength - 1).clamp(0, 3)]
                  : AppColors.grey200,
              borderRadius: BorderRadius.circular(UiConstants.radiusFull),
            ),
          ),
        );
      }),
    );
  }
}

/// The "Atau masuk dengan" divider with a centered label.
final class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: UiConstants.spacingMd),
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// An outlined social-login button (Google / Apple). UI-only for now.
final class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UiConstants.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colorScheme.onSurface,
          side: const BorderSide(color: AppColors.grey300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: UiConstants.spacingSm),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
