import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/main.dart';

/// Production entry point.
///
/// Uses the production API. Debug features are disabled.
void main() {
  FinTribeApp.run(Environment.prod);
}
