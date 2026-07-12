import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Authenticated user — unified domain entity + JSON DTO.
///
/// The backend's auth response returns only a JWT, so [id] and [email] are
/// derived from the token's claims and [name] from the register form (or a
/// later profile fetch). Timestamps are nullable because they aren't always
/// available at sign-in time.
@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Builds a [User] from decoded JWT claims (`user_id`, `email`), optionally
  /// enriched with a [name] known from the register form.
  factory User.fromClaims(Map<String, dynamic> claims, {String? name}) => User(
    id: (claims['user_id'] ?? claims['sub'] ?? '').toString(),
    email: (claims['email'] ?? '').toString(),
    name: name,
  );

  /// Display name, falling back to the email's local part.
  String get displayName =>
      (name != null && name!.trim().isNotEmpty)
      ? name!
      : email.split('@').first;

  /// Up to 2 initials from [displayName].
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }
}
