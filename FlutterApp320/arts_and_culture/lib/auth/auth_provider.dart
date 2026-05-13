import 'package:arts_and_culture/auth/guest_auth_service.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final GuestAuthService _guestService = GuestAuthService();
  bool _isAuthenticated = false;
  bool _isGuest = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;
  bool get hasAccess => _isAuthenticated || _isGuest;

  Future<void> checkAuthStatus() async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      _isAuthenticated = true;
      _isGuest = false;
      notifyListeners();
      return;
    }
    // Fall back to guest key
    final hasGuest = await _guestService.hasValidKey();
    if (hasGuest) {
      _isGuest = true;
      _guestService.renewIfNeeded();
    } else {
      await _guestService.clearKey();
      _isGuest = false;
    }
    notifyListeners();
  }

  Future<bool> login() async {
    final success = await _authService.login();
    if (success) {
      _isAuthenticated = true;
      _isGuest = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setGuest() {
    _isGuest = true;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    await _guestService.clearKey();
    _isAuthenticated = false;
    _isGuest = false;
    notifyListeners();
  }
}