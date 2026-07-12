import 'dart:convert';

/// Minimal, dependency-free JWT payload reader.
///
/// The backend's login/register response returns only a signed token; the
/// user's identity (`user_id`, `email`) lives in the JWT payload. This decodes
/// that payload **without verifying the signature** — verification is the
/// server's job; the client only reads claims to bootstrap the session.
abstract final class Jwt {
  Jwt._();

  /// Decodes the payload (2nd segment) of [token] into a claims map.
  ///
  /// Throws [FormatException] if [token] is not a well-formed JWT.
  static Map<String, dynamic> decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Not a valid JWT (expected 3 segments)');
    }
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final json = jsonDecode(decoded);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('JWT payload is not a JSON object');
    }
    return json;
  }

  /// The `exp` claim as a [DateTime], or `null` if absent/unparseable.
  static DateTime? expiry(Map<String, dynamic> claims) {
    final exp = claims['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  /// Whether [token] is expired (or malformed). A token with no `exp` is
  /// treated as non-expiring.
  static bool isExpired(String token) {
    try {
      final exp = expiry(decode(token));
      if (exp == null) return false;
      return DateTime.now().isAfter(exp);
    } on FormatException {
      return true;
    }
  }
}
