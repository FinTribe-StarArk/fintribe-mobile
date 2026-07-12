import 'package:logger/logger.dart';

/// Centralized application logger.
///
/// Use this instead of `print()` for all logging.
/// Log level is automatically adjusted per environment.
abstract final class AppLogger {
  static final Logger _instance = Logger(
    filter: AppLogFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  /// Returns the configured logger instance.
  static Logger get I => _instance;

  /// Set the minimum log level (e.g., [Level.off] to disable).
  static void setLevel(Level level) {
    (_instance.init as AppLogFilter?)?.level = level;
  }
}

class AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level.index >= Level.warning.index) {
      return true;
    }

    if (event.message.toString().contains('IgnoreMe')) {
      return false;
    }

    return true; 
  }
}
