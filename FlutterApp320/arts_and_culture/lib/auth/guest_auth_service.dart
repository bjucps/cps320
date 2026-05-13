import 'dart:convert';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const String _keyStorageKey   = 'guest_api_key';
const String _expiryStorageKey = 'guest_key_expiry';

class GuestAuthService {
  static const _storage = FlutterSecureStorage();

  Future<void> saveKey(String rawKey, String expiresAt) async {
    await _storage.write(key: _keyStorageKey, value: rawKey);
    await _storage.write(key: _expiryStorageKey, value: expiresAt);
  }

  Future<String?> getKey() async {
    return _storage.read(key: _keyStorageKey);
  }

Future<bool> hasValidKey() async {
  final key    = await _storage.read(key: _keyStorageKey);
  final expiry = await _storage.read(key: _expiryStorageKey);
  if (key == null || expiry == null) {
    await clearKey();
    return false;
  }
  final expiryDate = DateTime.tryParse(expiry);
  if (expiryDate == null || !expiryDate.isAfter(DateTime.now())) {
    await clearKey();
    return false;
  }
  try {
    final resp = await http.post(
      Uri.parse('$baseUrl$guestLoginRenewLink'),
      headers: {
        'X-Guest-Key':    key,
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 5));

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final newExpiry = data['expires_at'] as String? ?? '';
      if (newExpiry.isNotEmpty) {
        await _storage.write(key: _expiryStorageKey, value: newExpiry);
      }
      return true;
    } else {
      await clearKey();
      return false;
    }
  } catch (_) {
    // Network unavailable...
    return true;
  }
}

  Future<bool> keyNeedsRenewal() async {
    final expiry = await _storage.read(key: _expiryStorageKey);
    if (expiry == null) return false;
    try {
      final exp = DateTime.parse(expiry);
      return exp.difference(DateTime.now()).inDays < renewThresholdDays;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearKey() async {
    await _storage.delete(key: _keyStorageKey);
    await _storage.delete(key: _expiryStorageKey);
  }

  Future<bool> renewIfNeeded() async {
    if (!await hasValidKey()) return false;
    if (!await keyNeedsRenewal()) return true;

    final rawKey = await getKey();
    if (rawKey == null) return false;

    try {
      final resp = await http.post(
        Uri.parse('$baseUrl$guestLoginRenewLink'),
        headers: {
          'X-Guest-Key': rawKey,
          'Content-Type': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final newExpiry = data['expires_at'] as String? ?? '';
        if (newExpiry.isNotEmpty) {
          await _storage.write(key: _expiryStorageKey, value: newExpiry);
          debugPrint('[GuestAuth] Key renewed, expires $newExpiry');
          return true;
        }
      }
      else if (resp.statusCode == 401) {
        debugPrint('[GuestAuth] Key rejected by server, clearing.');
        await clearKey();
      }
      else {
        debugPrint('[GuestAuth] Renewal failed (${resp.statusCode})');
      }
    } catch (e) {
      debugPrint('[GuestAuth] Renewal error: $e');
    }
    return false;
  }

  static String guestLoginUrl() {
    return '$baseUrl$guestLoginLink?app_token=$guestAppToken';
  }
}
