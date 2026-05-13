import 'package:arts_and_culture/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _appAuth = FlutterAppAuth();

  final List<String> _scopes = [
    'openid',
    'profile',
    'offline_access',
    'api://$djangoClientId/user_impersonation',
  ];

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'access_token');
    final expiry = await _storage.read(key: 'token_expiry');

    if (token != null && !_isExpired(expiry)) {
      return token;
    }

    return await _refreshAccessToken();
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) return null;

    try {
      final result = await _appAuth.token(
        TokenRequest(
          flutterClientId,
          redirectUrl,
          issuer: issuer,
          refreshToken: refreshToken,
          scopes: _scopes,
        ),
      );

      await _saveTokens(result);
      return result.accessToken;
    } catch (e) {
      debugPrint("Silent refresh failed: $e");
      await logout();
    }
    return null;
  }

  Future<bool> login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          flutterClientId,
          redirectUrl,
          issuer: issuer,
          scopes: _scopes,
        ),
      );

      // print("--- START FULL ACCESS TOKEN ---");
      // _printFullToken(result.accessToken!);
      // print("--- END FULL ACCESS TOKEN ---");

      await _saveTokens(result);
      return true;
    } catch (e) {
      debugPrint("Login failed: $e");
    }
    return false;
  }

  // void _printFullToken(String token) {
  //   final int chunkSize = 800;
  //   for (int i = 0; i < token.length; i += chunkSize) {
  //     int end = (i + chunkSize < token.length) ? i + chunkSize : token.length;
  //     print(token.substring(i, end));
  //   }
  // }

  Future<void> _saveTokens(TokenResponse result) async {
    await _storage.write(key: 'access_token', value: result.accessToken);
    await _storage.write(key: 'refresh_token', value: result.refreshToken);
    await _storage.write(
      key: 'token_expiry',
      value: result.accessTokenExpirationDateTime?.toIso8601String(),
    );
  }

  bool _isExpired(String? expiry) {
    if (expiry == null) return true;
    final expiryDate = DateTime.parse(expiry);
    return DateTime.now().add(const Duration(minutes: 1)).isAfter(expiryDate);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
