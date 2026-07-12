import 'package:fintribe/core/constants/api_constants.dart';
import 'package:fintribe/core/constants/storage_constants.dart';
import 'package:fintribe/core/network/api_client.dart';
import 'package:fintribe/core/network/network_exceptions.dart';
import 'package:fintribe/core/storage/secure_storage.dart';
import 'package:fintribe/core/utils/helpers/jwt.dart';
import 'package:fintribe/core/utils/helpers/logger.dart';
import 'package:fintribe/features/auth/data/local/user_dao.dart';
import 'package:fintribe/features/auth/domain/model/user.dart';

/// Concrete authentication repository — no abstract class, no Impl suffix.
///
/// The backend returns a single JWT in `data.token` (no user object, no refresh
/// token). The signed-in [User] is therefore derived from the token's claims
/// (`user_id`, `email`) plus any `name` known from the register form, and
/// cached locally so the session survives offline / app restarts.
final class AuthRepo {
  const AuthRepo({
    required this.apiClient,
    required this.secureStorage,
    required this.userDao,
  });

  final ApiClient apiClient;
  final SecureStorage secureStorage;

  /// Local cache of the signed-in user for offline session restore.
  final UserDao userDao;

  // ── Login ──────────────────────────────────────────────────────

  Future<User> login(String email, String password) async {
    AppLogger.I.d('🔑 Logging in $email');
    final token = await _postForToken(
      ApiConstants.login,
      {'email': email, 'password': password},
    );
    final user = _userFromToken(token);
    await _persistSession(token, user);
    AppLogger.I.d('✅ Logged in as ${user.email}');
    return user;
  }

  // ── Register ───────────────────────────────────────────────────

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    AppLogger.I.d('📝 Registering $email');
    final token = await _postForToken(
      ApiConstants.register,
      {'name': name, 'email': email, 'password': password},
    );
    // The token's claims carry id/email; the name comes from the form.
    final user = _userFromToken(token, name: name);
    await _persistSession(token, user);
    return user;
  }

  // ── Logout ─────────────────────────────────────────────────────

  Future<void> logout() async {
    await secureStorage.delete(StorageConstants.accessToken);
    await userDao.clear();
    AppLogger.I.d('🚪 Logged out');
  }

  // ── Session ────────────────────────────────────────────────────

  /// Restores the current session from the stored token (offline-friendly).
  ///
  /// Returns `null` when there is no token or it has expired; otherwise returns
  /// the cached user, reconstructing a minimal one from the token claims if the
  /// cache is empty.
  Future<User?> fetchCurrentUser() async {
    final token = await secureStorage.read(StorageConstants.accessToken);
    if (token == null || token.isEmpty) return null;

    if (Jwt.isExpired(token)) {
      await logout();
      return null;
    }

    final cached = await userDao.current();
    if (cached != null) return cached;

    // Token is valid but nothing cached — rebuild from claims.
    final user = _userFromToken(token);
    await userDao.cache(user);
    return user;
  }

  // ── Helpers ────────────────────────────────────────────────────

  /// POSTs [body] to [path] and extracts the token from `data.token`.
  Future<String> _postForToken(String path, Map<String, dynamic> body) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      path,
      data: body,
    );
    final data = response.data?['data'];
    final token = data is Map ? data['token'] as String? : null;
    if (token == null || token.isEmpty) {
      throw const NetworkException(message: 'No token returned by server');
    }
    return token;
  }

  User _userFromToken(String token, {String? name}) {
    final claims = Jwt.decode(token);
    return User.fromClaims(claims, name: name);
  }

  Future<void> _persistSession(String token, User user) async {
    await secureStorage.write(StorageConstants.accessToken, token);
    await userDao.cache(user);
  }
}
