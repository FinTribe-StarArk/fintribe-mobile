import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/main.dart';

/// Staging entry point.
///
/// Uses the staging API for QA/testing.
void main() {
  FinTribeApp.run(Environment.staging);
}
