import 'dart:async';

/// A simple debouncer for callbacks.
///
/// ```dart
/// final debouncer = Debouncer(milliseconds: 300);
/// debouncer.run(() => search(query));
/// ```
class Debouncer {
  /// Creates a [Debouncer] with the specified [milliseconds] delay.
  Debouncer({this.milliseconds = 300});

  /// The debounce delay.
  final int milliseconds;

  Timer? _timer;

  /// Invokes [action] after the debounce period.
  /// If called again before the period elapses, the previous call is canceled.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
