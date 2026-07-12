import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/main.dart';

/// Development entry point.
///
/// Uses the dev API, enables debug logging, and verbose error reporting.
void main() {
  FinTribeApp.run(Environment.dev);
}
