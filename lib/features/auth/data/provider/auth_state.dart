import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fintribe/features/auth/domain/model/user.dart';

part 'auth_state.freezed.dart';

/// Global auth states — used when [AsyncValue] is not expressive enough
/// (e.g. during initial session check where loading/error/data isn't
/// the primary pattern).
///
/// For most screens, prefer `ref.watch(authProvider)` which returns
/// `AsyncValue<User?>` and gives you `.when(loading:, data:, error:)`.
@freezed
class AuthStatus with _$AuthStatus {
  /// App just launched; session not checked yet.
  const factory AuthStatus.initial() = _Initial;

  /// Valid session found.
  const factory AuthStatus.authenticated(User user) = _Authenticated;

  /// No session / logged out.
  const factory AuthStatus.unauthenticated() = _Unauthenticated;
}
