import 'package:fintribe/core/utils/helpers/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty input', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email(null), 'Email is required');
    });

    test('rejects malformed addresses', () {
      expect(Validators.email('not-an-email'), 'Enter a valid email address');
      expect(Validators.email('a@b'), 'Enter a valid email address');
    });

    test('accepts a valid address', () {
      expect(Validators.email('user@fintribe.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('requires minimum length', () {
      expect(Validators.password('Ab1'), contains('at least 8'));
    });

    test('requires an uppercase letter', () {
      expect(Validators.password('lowercase1'), contains('uppercase'));
    });

    test('requires a digit', () {
      expect(Validators.password('NoDigitsHere'), contains('digit'));
    });

    test('accepts a strong password', () {
      expect(Validators.password('Str0ngPass'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('flags mismatch', () {
      expect(Validators.confirmPassword('a', 'b'), 'Passwords do not match');
    });

    test('passes when equal', () {
      expect(Validators.confirmPassword('same', 'same'), isNull);
    });
  });

  group('Validators.required', () {
    test('uses the provided label', () {
      expect(Validators.required('', 'Name'), 'Name is required');
    });

    test('passes for non-empty input', () {
      expect(Validators.required('value'), isNull);
    });
  });
}
