import 'package:flutter/material.dart';

/// A widget displayed when an error occurs, with an optional retry button.
final class AppErrorWidget extends StatelessWidget {
  /// Creates an [AppErrorWidget].
  const AppErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Error message to display.
  final String message;

  /// Called when the user taps retry.
  final VoidCallback? onRetry;

  /// Error icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
