import 'package:flutter/material.dart';

/// Reusable primary button widget.
final class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  /// Button label text.
  final String label;

  /// Tap callback. Set to `null` to disable.
  final VoidCallback? onPressed;

  /// Whether to show a loading spinner.
  final bool isLoading;

  /// Whether to use outlined style.
  final bool isOutlined;

  /// Optional leading icon.
  final Widget? icon;

  /// Custom button width.
  final double? width;

  /// Custom button height.
  final double height;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon!, const SizedBox(width: 8), Text(label)],
      );
    }

    return Text(label);
  }
}
