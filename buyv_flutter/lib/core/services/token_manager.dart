import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage — replaces KMP's TokenManager (EncryptedSharedPreferences).
/// Uses flutter_secure_storage for AES encryption on both Android and iOS.
class TokenManager {
  TokenManager._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';

  // ── Access Token ────────────────────────────────────────────────
  static Future<void> saveAccessToken(String token) async =>
      _storage.write(key: _accessTokenKey, value: token);

  static Future<String?> getAccessToken() async =>
      _storage.read(key: _accessTokenKey);

  // ── Refresh Token ───────────────────────────────────────────────
  static Future<void> saveRefreshToken(String token) async =>
      _storage.write(key: _refreshTokenKey, value: token);

  static Future<String?> getRefreshToken() async =>
      _storage.read(key: _refreshTokenKey);

  // ── User ID ─────────────────────────────────────────────────────
  static Future<void> saveUserId(String userId) async =>
      _storage.write(key: _userIdKey, value: userId);

  static Future<String?> getUserId() async =>
      _storage.read(key: _userIdKey);

  // ── Clear All ────────────────────────────────────────────────────
  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
    ]);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
