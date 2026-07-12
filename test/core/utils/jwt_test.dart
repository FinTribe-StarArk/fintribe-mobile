import 'dart:convert';

import 'package:fintribe/core/utils/helpers/jwt.dart';
import 'package:flutter_test/flutter_test.dart';

String fakeJwt(Map<String, dynamic> payload) {
  String seg(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  return '${seg({'alg': 'HS256'})}.${seg(payload)}.sig';
}

void main() {
  group('Jwt.decode', () {
    test('reads claims from the payload segment', () {
      final token = fakeJwt({'user_id': 'abc', 'email': 'a@b.com'});
      final claims = Jwt.decode(token);
      expect(claims['user_id'], 'abc');
      expect(claims['email'], 'a@b.com');
    });

    test('throws on a malformed token', () {
      expect(() => Jwt.decode('not.a'), throwsFormatException);
    });
  });

  group('Jwt.isExpired', () {
    test('false for a future exp', () {
      final token = fakeJwt({
        'exp': DateTime(2999).millisecondsSinceEpoch ~/ 1000,
      });
      expect(Jwt.isExpired(token), isFalse);
    });

    test('true for a past exp', () {
      final token = fakeJwt({
        'exp': DateTime(2000).millisecondsSinceEpoch ~/ 1000,
      });
      expect(Jwt.isExpired(token), isTrue);
    });

    test('non-expiring when exp is absent', () {
      expect(Jwt.isExpired(fakeJwt({'user_id': 'x'})), isFalse);
    });

    test('treats a malformed token as expired', () {
      expect(Jwt.isExpired('garbage'), isTrue);
    });
  });
}
