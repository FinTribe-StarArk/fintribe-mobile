import 'package:fintribe/core/utils/helpers/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension', () {
    test('capitalize upper-cases the first letter only', () {
      expect('hello'.capitalize, 'Hello');
      expect(''.capitalize, '');
    });

    test('titleCase capitalizes each word', () {
      expect('john doe smith'.titleCase, 'John Doe Smith');
    });

    test('isValidEmail distinguishes valid from invalid', () {
      expect('a@b.com'.isValidEmail, isTrue);
      expect('a@b'.isValidEmail, isFalse);
    });

    test('mask hides all but the last N characters', () {
      expect('12345678'.mask(), '****5678');
      expect('123'.mask(), '123'); // shorter than visibleChars
    });

    test('isBlank / isNotBlank handle whitespace', () {
      expect('   '.isBlank, isTrue);
      expect(' x '.isNotBlank, isTrue);
    });
  });
}
